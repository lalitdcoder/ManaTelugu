import AVFoundation
import Combine
import Foundation

// MARK: - Models

struct PronunciationResult {
    let transcript: String
    let expectedText: String
    let score: Double  // 0.0 – 1.0
    let feedback: String
    let matchedWords: [String]
    let missedWords: [String]
}

enum STTError: LocalizedError {
    case microphonePermissionDenied
    case recordingFailed
    case audioFileNotFound
    case networkError(Error)
    case invalidResponse(String)
    case sessionActive

    var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return
                "Microphone access is required for pronunciation practice. Please enable it in Settings."
        case .recordingFailed:
            return "Failed to start recording. Please try again."
        case .audioFileNotFound:
            return "No recording found. Please record first."
        case .networkError(let e):
            return "Network error: \(e.localizedDescription)"
        case .invalidResponse(let msg):
            return "API error: \(msg)"
        case .sessionActive:
            return "A recording is already in progress."
        }
    }
}

// MARK: - Service

@MainActor
final class SarvamSpeechToTextService: NSObject, ObservableObject {

    // MARK: - Published State
    @Published var isRecording: Bool = false
    @Published var isProcessing: Bool = false
    @Published var permissionGranted: Bool = false
    @Published var lastResult: PronunciationResult?
    @Published var errorMessage: String?
    @Published var audioLevel: Float = 0.0  // 0..1 for visualiser

    // MARK: - Private
    private let apiKey = "sk_ouzk5p4u_yodCfGE23Bd9TqeAnPuV3hBB"
    private let baseURL = "https://api.sarvam.ai/speech-to-text"
    private var audioRecorder: AVAudioRecorder?
    private var levelTimer: Timer?
    private var audioSession: AVAudioSession { AVAudioSession.sharedInstance() }

    private var recordingURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("stt_recording.wav")
    }

    // MARK: - Init
    override init() {
        super.init()
        Task { await checkPermission() }
    }

    // MARK: - Permission

    func checkPermission() async {
        let status = AVAudioApplication.shared.recordPermission
        switch status {
        case .granted:
            permissionGranted = true
        case .denied:
            permissionGranted = false
        case .undetermined:
            permissionGranted = await AVAudioApplication.requestRecordPermission()
        @unknown default:
            permissionGranted = false
        }
    }

    func requestPermission() async {
        permissionGranted = await AVAudioApplication.requestRecordPermission()
    }

    // MARK: - Recording

    func startRecording() throws {
        guard !isRecording else { throw STTError.sessionActive }
        guard permissionGranted else { throw STTError.microphonePermissionDenied }

        // Configure session for recording
        do {
            try audioSession.setCategory(
                .playAndRecord, mode: .measurement,
                options: [.defaultToSpeaker, .allowBluetoothHFP])
            try audioSession.setActive(true)
        } catch {
            throw STTError.recordingFailed
        }

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
            errorMessage = nil
            startLevelMonitoring()
        } catch {
            throw STTError.recordingFailed
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        audioLevel = 0
        stopLevelMonitoring()
        // Restore playback session
        try? audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
    }

    // MARK: - Level Monitoring

    private func startLevelMonitoring() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self,
                    let recorder = self.audioRecorder,
                    recorder.isRecording
                else { return }
                recorder.updateMeters()
                let avg = recorder.averagePower(forChannel: 0)
                // avg is in dB: usually -160 to 0. Map to 0..1
                let normalised = max(0, (avg + 60) / 60)
                self.audioLevel = normalised
            }
        }
    }

    private func stopLevelMonitoring() {
        levelTimer?.invalidate()
        levelTimer = nil
    }

    // MARK: - Transcription

    func transcribe(expectedText: String = "") async {
        guard FileManager.default.fileExists(atPath: recordingURL.path) else {
            errorMessage = STTError.audioFileNotFound.errorDescription
            return
        }

        isProcessing = true
        errorMessage = nil

        do {
            let transcript = try await callSarvamAPI()
            let result = buildPronunciationResult(transcript: transcript, expected: expectedText)
            lastResult = result
        } catch let error as STTError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = STTError.networkError(error).errorDescription
        }

        isProcessing = false
    }

    // MARK: - API Call

    private func callSarvamAPI() async throws -> String {
        guard let audioData = try? Data(contentsOf: recordingURL) else {
            throw STTError.audioFileNotFound
        }
        guard let url = URL(string: baseURL) else {
            throw STTError.invalidResponse("Invalid base URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "api-subscription-key")
        request.timeoutInterval = 30

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")

        var body = Data()

        // model
        body.appendFormField(boundary: boundary, name: "model", value: "saarika:v2.5")
        // language
        body.appendFormField(boundary: boundary, name: "language_code", value: "te-IN")
        // timestamps for better feedback
        body.appendFormField(boundary: boundary, name: "with_timestamps", value: "true")
        // audio file
        body.appendFile(
            boundary: boundary, name: "file",
            filename: "recording.wav", mimeType: "audio/wav", data: audioData)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
            !(200...299).contains(httpResponse.statusCode)
        {
            let raw = String(data: data, encoding: .utf8) ?? "unknown"
            throw STTError.invalidResponse("HTTP \(httpResponse.statusCode): \(raw)")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw STTError.invalidResponse("Could not parse JSON response")
        }

        if let transcript = json["transcript"] as? String {
            return transcript
        }

        // Fallback: check for error message from API
        if let message = json["message"] as? String {
            throw STTError.invalidResponse(message)
        }

        throw STTError.invalidResponse("No transcript in response")
    }

    // MARK: - Pronunciation Scoring

    func buildPronunciationResult(transcript: String, expected: String) -> PronunciationResult {
        guard !expected.isEmpty else {
            return PronunciationResult(
                transcript: transcript,
                expectedText: "",
                score: 1.0,
                feedback: "Recorded successfully!",
                matchedWords: [],
                missedWords: []
            )
        }

        let expectedWords =
            expected
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: .punctuationCharacters).lowercased() }
            .filter { !$0.isEmpty }

        let spokenWords =
            transcript
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: .punctuationCharacters).lowercased() }
            .filter { !$0.isEmpty }

        let spokenSet = Set(spokenWords)
        let matched = expectedWords.filter { spokenSet.contains($0) }
        let missed = expectedWords.filter { !spokenSet.contains($0) }

        let score =
            expectedWords.isEmpty ? 1.0 : Double(matched.count) / Double(expectedWords.count)

        let feedback = feedbackMessage(score: score, missed: missed)

        return PronunciationResult(
            transcript: transcript,
            expectedText: expected,
            score: score,
            feedback: feedback,
            matchedWords: matched,
            missedWords: missed
        )
    }

    private func feedbackMessage(score: Double, missed: [String]) -> String {
        switch score {
        case 0.9...1.0:
            return "🎉 Excellent! Perfect pronunciation!"
        case 0.7..<0.9:
            return "👏 Great job! Almost perfect."
        case 0.5..<0.7:
            return "👍 Good effort! Keep practising."
        case 0.3..<0.5:
            return "💪 Keep going! Focus on the missed words."
        default:
            return "🔄 Try again — speak clearly and slowly."
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension SarvamSpeechToTextService: AVAudioRecorderDelegate {
    nonisolated func audioRecorderDidFinishRecording(
        _ recorder: AVAudioRecorder, successfully flag: Bool
    ) {
        Task { @MainActor in
            if !flag {
                self.errorMessage = "Recording was interrupted."
                self.isRecording = false
                self.audioLevel = 0
            }
        }
    }

    nonisolated func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        Task { @MainActor in
            self.errorMessage = error?.localizedDescription ?? "Encoding error occurred."
            self.isRecording = false
            self.audioLevel = 0
        }
    }
}

// MARK: - Data helpers

extension Data {
    fileprivate mutating func appendFormField(boundary: String, name: String, value: String) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        append("\(value)\r\n".data(using: .utf8)!)
    }

    fileprivate mutating func appendFile(
        boundary: String, name: String,
        filename: String, mimeType: String, data fileData: Data
    ) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append(
            "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(
                using: .utf8)!)
        append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        append(fileData)
        append("\r\n".data(using: .utf8)!)
    }
}
