import AVFoundation
import SwiftUI

class AudioFeedbackService: ObservableObject {
    static let shared = AudioFeedbackService()
    @Published var isEnabled: Bool = true
    private var audioPlayer: AVAudioPlayer?
    
    func playSuccess() {
        guard isEnabled else { return }
        playSound(named: "success")
    }
    
    func playTryAgain() {
        guard isEnabled else { return }
        playSound(named: "tryagain")
    }
    
    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Could not find \(soundName).mp3 file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
