import AVFoundation
import Combine
import Foundation
import Speech

// MARK: - On-Device Speech Recognition Service
// Uses Apple's SFSpeechRecognizer with the te-IN locale.
// Exposes the same @Published surface as SarvamSpeechToTextService so
// PronunciationPracticeView can swap between engines without restructuring.

@MainActor
final class OnDeviceSpeechService: NSObject, ObservableObject {

    // MARK: - Published State (mirrors SarvamSpeechToTextService)
    @Published var isRecording: Bool = false
    @Published var isProcessing: Bool = false
    @Published var permissionGranted: Bool = false
    @Published var lastResult: PronunciationResult?
    @Published var errorMessage: String?
    @Published var audioLevel: Float = 0.0

    // MARK: - Private
    private let recognizer: SFSpeechRecognizer? = {
        let r = SFSpeechRecognizer(locale: Locale(identifier: "te-IN"))
        return r
    }()

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var levelTimer: Timer?
    private var currentExpected: String = ""

    // MARK: - Init
    override init() {
        super.init()
        Task { await checkPermissions() }
    }

    // MARK: - Permissions

    func checkPermissions() async {
        let micStatus = AVAudioApplication.shared.recordPermission
        let speechStatus = SFSpeechRecognizer.authorizationStatus()

        if micStatus == .granted && speechStatus == .authorized {
            permissionGranted = true
            return
        }
    }

    func requestPermission() async {
        // 1. Microphone
        let micGranted = await withCheckedContinuation { cont in
            AVAudioApplication.requestRecordPermission { granted in
                cont.resume(returning: granted)
            }
        }
        guard micGranted else {
            permissionGranted = false
            errorMessage = "Microphone access is required. Please enable it in Settings."
            return
        }

        // 2. Speech Recognition
        let speechStatus = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status)
            }
        }
        guard speechStatus == .authorized else {
            permissionGranted = false
            errorMessage =
                "Speech recognition permission is required. Please enable it in Settings."
            return
        }

        permissionGranted = true
    }

    // MARK: - Recording

    func startRecording() throws {
        // Stop any lingering run before starting fresh
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        // Recognizer must at least exist (nil = locale completely unsupported by OS)
        guard let recognizer else {
            errorMessage =
                "On-device Telugu recognition is not supported on this iOS version. Please use Sarvam AI."
            throw STTError.recordingFailed
        }

        // Cancel stale task
        recognitionTask?.cancel()
        recognitionTask = nil
        lastResult = nil
        errorMessage = nil

        // Configure audio session — try strict mode first, fall back to playAndRecord
        let avSession = AVAudioSession.sharedInstance()
        do {
            try avSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try avSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            // Fallback: some devices refuse .measurement when another session is active
            do {
                try avSession.setCategory(
                    .playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try avSession.setActive(true)
            } catch {
                errorMessage = "Could not activate microphone: \(error.localizedDescription)"
                throw STTError.recordingFailed
            }
        }

        // Build recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { throw STTError.recordingFailed }
        recognitionRequest.shouldReportPartialResults = true
        // Don't force on-device — Apple falls back to its servers if the te-IN
        // on-device model isn't yet downloaded on the user's device.
        recognitionRequest.requiresOnDeviceRecognition = false

        // Wire audio tap
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)

            // Compute RMS for live waveform level
            let frameLength = Int(buffer.frameLength)
            guard let channelData = buffer.floatChannelData?[0], frameLength > 0 else { return }
            var sumOfSquares: Float = 0
            for i in 0..<frameLength { sumOfSquares += channelData[i] * channelData[i] }
            let rms = sqrt(sumOfSquares / Float(frameLength))
            Task { @MainActor [weak self] in
                self?.audioLevel = min(1.0, rms * 10)
            }
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            audioEngine.inputNode.removeTap(onBus: 0)
            errorMessage = "Failed to start audio engine: \(error.localizedDescription)"
            throw STTError.recordingFailed
        }

        isRecording = true
        _ = recognizer  // silence "unused" warning; recognizer used in transcribe()
    }

    func stopRecording() {
        audioEngine.stop()
        // Guard against double-remove (tap may already be gone)
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        isRecording = false
        audioLevel = 0
    }

    // MARK: - Transcribe (mirrors SarvamSpeechToTextService.transcribe)

    func transcribe(expectedText: String) async {
        currentExpected = expectedText
        guard let recognitionRequest else {
            errorMessage = "No audio data recorded. Please try again."
            return
        }

        guard let recognizer else {
            errorMessage = "On-device Telugu recognition is not available. Please use Sarvam AI."
            return
        }

        isProcessing = true
        defer { isProcessing = false }

        do {
            let transcript = try await withCheckedThrowingContinuation {
                (cont: CheckedContinuation<String, Error>) in
                var resumed = false
                recognitionTask = recognizer.recognitionTask(with: recognitionRequest) {
                    result, error in
                    guard !resumed else { return }
                    if let result, result.isFinal {
                        resumed = true
                        cont.resume(returning: result.bestTranscription.formattedString)
                    } else if let error {
                        resumed = true
                        cont.resume(throwing: error)
                    }
                }
            }

            let result = buildResult(transcript: transcript, expected: expectedText)
            lastResult = result

        } catch {
            // If on-device fails, show a friendly message
            let nsErr = error as NSError
            if nsErr.code == 203 {  // kAFAssistantErrorDomain - no speech detected
                errorMessage = "No speech detected. Speak clearly and try again."
            } else if nsErr.domain == "kAFAssistantErrorDomain" && nsErr.code == 209 {
                errorMessage =
                    "On-device Telugu model not downloaded yet. Connect to Wi-Fi to download it, or use Sarvam AI."
            } else {
                errorMessage = "Recognition failed: \(error.localizedDescription)"
            }
        }

        // Clean up
        recognitionTask = nil
        self.recognitionRequest = nil
    }

    // MARK: - Scoring

    private func buildResult(transcript: String, expected: String) -> PronunciationResult {
        let score = transcript.pronunciationScore(comparedTo: expected)
        let normalised = Double(score) / 100.0

        let feedback: String
        switch score {
        case 90...100: feedback = "Excellent! 🎉 Perfect pronunciation!"
        case 75..<90: feedback = "Great job! 👍 Very close to perfect."
        case 60..<75: feedback = "Good effort! Keep practising."
        case 40..<60: feedback = "Getting there! Try slowing down."
        default: feedback = "Keep going! Pronunciation takes practice."
        }

        // Simple word-level matching
        let expectedWords = expected.components(separatedBy: " ").filter { !$0.isEmpty }
        let transcriptWords = transcript.components(separatedBy: " ").filter { !$0.isEmpty }
        let matched = expectedWords.filter { transcriptWords.contains($0) }
        let missed = expectedWords.filter { !transcriptWords.contains($0) }

        return PronunciationResult(
            transcript: transcript,
            expectedText: expected,
            score: normalised,
            feedback: feedback,
            matchedWords: matched,
            missedWords: missed
        )
    }
}
