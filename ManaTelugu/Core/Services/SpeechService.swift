import Foundation
import AVFoundation
import Speech

// MARK: - Speech Service Protocol
protocol SpeechServiceProtocol {
    func requestPermissions() async -> Bool
    func startListening() async throws -> String
    func stopListening()
    func speak(_ text: String, language: String) async
    var isListening: Bool { get }
    var isSpeaking: Bool { get }
    var currentLanguage: String { get }
}

// MARK: - Speech Service
class SpeechService: NSObject, SpeechServiceProtocol, ObservableObject {
    static let shared = SpeechService()
    
    @Published var isListening = false
    @Published var isSpeaking = false
    @Published var recognizedText = ""
    @Published var errorMessage: String?
    
    var currentLanguage: String {
        if currentSpeechRecognizer == teluguSpeechRecognizer {
            return "Telugu"
        } else if currentSpeechRecognizer == englishSpeechRecognizer {
            return "English"
        } else {
            return "Unknown"
        }
    }
    
    private let teluguSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "te-IN")) // Telugu (India)
    private let englishSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) // English (US) - fallback
    private var currentSpeechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private override init() {
        super.init()
        setupAudioSession()
        setupSpeechRecognizer()
    }
    
    private func setupSpeechRecognizer() {
        // Prefer Telugu speech recognition, fall back to English if not available
        if let teluguRecognizer = teluguSpeechRecognizer, teluguRecognizer.isAvailable {
            currentSpeechRecognizer = teluguRecognizer
            print("✅ Telugu speech recognition is available")
        } else if let englishRecognizer = englishSpeechRecognizer, englishRecognizer.isAvailable {
            currentSpeechRecognizer = englishRecognizer
            print("⚠️ Telugu not available, using English speech recognition")
        } else {
            print("❌ No speech recognition available")
        }
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: [])
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Permissions
    func requestPermissions() async -> Bool {
        let speechAuth = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
        
        let micAuth = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        
        return speechAuth && micAuth
    }
    
    // MARK: - Speech Recognition
    func startListening() async throws -> String {
        print("Starting speech recognition...")
        
        guard let speechRecognizer = currentSpeechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognizer not available")
            throw SpeechError.recognizerNotAvailable
        }
        
        // Cancel any existing recognition task
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Failed to create recognition request")
            throw SpeechError.requestCreationFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure audio engine
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        isListening = true
        print("Audio engine started, listening...")
        
        return try await withCheckedThrowingContinuation { continuation in
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let error = error {
                    print("Speech recognition error: \(error)")
                    self.isListening = false
                    continuation.resume(throwing: error)
                    return
                }
                
                if let result = result {
                    let text = result.bestTranscription.formattedString
                    print("Recognized text: \(text)")
                    DispatchQueue.main.async {
                        self.recognizedText = text
                    }
                    
                    if result.isFinal {
                        print("Final result: \(text)")
                        self.isListening = false
                        continuation.resume(returning: text)
                    }
                }
            }
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isListening = false
    }
    
    // MARK: - Language Switching
    func switchToTelugu() -> Bool {
        if let teluguRecognizer = teluguSpeechRecognizer, teluguRecognizer.isAvailable {
            currentSpeechRecognizer = teluguRecognizer
            print("✅ Switched to Telugu speech recognition")
            return true
        } else {
            print("❌ Telugu speech recognition not available")
            return false
        }
    }
    
    func switchToEnglish() -> Bool {
        if let englishRecognizer = englishSpeechRecognizer, englishRecognizer.isAvailable {
            currentSpeechRecognizer = englishRecognizer
            print("✅ Switched to English speech recognition")
            return true
        } else {
            print("❌ English speech recognition not available")
            return false
        }
    }
    
    // MARK: - Text-to-Speech
    func speak(_ text: String, language: String = "te-IN") async {
        await withCheckedContinuation { continuation in
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = 0.5 // Slower rate for language learning
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            synthesizer.delegate = self
            synthesizer.speak(utterance)
            
            // Resume continuation when speech finishes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                continuation.resume()
            }
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}

// MARK: - Speech Errors
enum SpeechError: LocalizedError {
    case recognizerNotAvailable
    case requestCreationFailed
    case permissionDenied
    case audioEngineError
    
    var errorDescription: String? {
        switch self {
        case .recognizerNotAvailable:
            return "Speech recognition is not available for Telugu"
        case .requestCreationFailed:
            return "Failed to create speech recognition request"
        case .permissionDenied:
            return "Microphone or speech recognition permission denied"
        case .audioEngineError:
            return "Audio engine error occurred"
        }
    }
}
