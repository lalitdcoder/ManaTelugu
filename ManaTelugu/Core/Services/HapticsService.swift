import UIKit

class HapticsService {
    static let shared = HapticsService()
    
    private init() {}
    
    func lightImpact() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    func warning() {
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.warning)
    }
    
    func success() {
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)
    }
}