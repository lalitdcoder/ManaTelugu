import AVFoundation
import SwiftUI

class AudioFeedbackService: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    func playSuccess() {
        playSound(named: "success")
    }
    
    func playTryAgain() {
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
