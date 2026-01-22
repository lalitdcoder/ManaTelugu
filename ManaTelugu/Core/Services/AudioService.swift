import AVFoundation
import Foundation

protocol AudioServiceProtocol {
    func play(name: String, rate: Float)
    func stop()
    func isPlaying() -> Bool
}

class AudioService: NSObject, AudioServiceProtocol, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("❌ Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    func play(name: String, rate: Float = 1.0) {
        // Try different path combinations
        var url: URL?

        // 1. Try direct path
        url = Bundle.main.url(forResource: name, withExtension: nil)

        // 2. Try in Sounds folder
        if url == nil {
            url = Bundle.main.url(forResource: name, withExtension: nil, subdirectory: "Sounds")
        }

        // 3. Try removing .mp3 and adding it back
        if url == nil {
            let nameWithoutExtension = name.replacingOccurrences(of: ".mp3", with: "")
            url = Bundle.main.url(
                forResource: nameWithoutExtension, withExtension: "mp3", subdirectory: "Sounds")
        }

        // 4. Try just the name with .mp3 in Sounds folder
        if url == nil {
            url = Bundle.main.url(forResource: name, withExtension: "mp3", subdirectory: "Sounds")
        }

        guard let audioURL = url else {
            print("❌ Audio file not found: \(name)")
            return
        }

        print("🎵 Playing audio: \(name) from \(audioURL.lastPathComponent)")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.enableRate = true
            audioPlayer?.rate = rate
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("✅ Audio playback started successfully")
        } catch {
            print("❌ Failed to play audio: \(error.localizedDescription)")
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("🏁 Audio playback finished")
        if player === audioPlayer {
            audioPlayer = nil
        }
    }
}
