import AVFoundation
import Foundation

protocol AudioServiceProtocol {
    func play(name: String, rate: Float)
    func stop()
    func isPlaying() -> Bool
}

class AudioService: AudioServiceProtocol {
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        // Configure audio session for playback
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true, options: [])
    }
    
    func play(name: String, rate: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Audio file not found: \(name)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.enableRate = true
            audioPlayer?.rate = rate
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
}