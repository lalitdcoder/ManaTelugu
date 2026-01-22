import Foundation

enum FeedbackCenter {
    static func correct() {
        HapticsManager.shared.notification(.success)
        AudioFeedbackService.shared.playSuccess()
    }
    static func wrong() {
        HapticsManager.shared.notification(.error)
        AudioFeedbackService.shared.playTryAgain()
    }
}


