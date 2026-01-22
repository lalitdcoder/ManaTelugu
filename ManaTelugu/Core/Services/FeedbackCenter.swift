import Foundation

enum FeedbackCenter {
    static func correct() {
        HapticsManager.shared.trigger(.success)
        AudioFeedbackService.shared.playSuccess()
    }
    static func wrong() {
        HapticsManager.shared.trigger(.error)
        AudioFeedbackService.shared.playTryAgain()
    }
}
