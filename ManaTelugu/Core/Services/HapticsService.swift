import UIKit

class HapticsService {
    static let shared = HapticsService()
    
    private init() {}
    
    private var isHapticFeedbackEnabled: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func lightImpact() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
    }
    
    func mediumImpact() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
    }
    
    func heavyImpact() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.prepare()
        impact.impactOccurred()
    }
    
    func warning() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.warning)
    }
    
    func success() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.success)
    }
    
    func error() {
        guard isHapticFeedbackEnabled else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.error)
    }
    
    // Debug function to test haptic feedback
    func testHaptics() {
        print("Testing haptic feedback - Device supports haptics: \(isHapticFeedbackEnabled)")
        lightImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mediumImpact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.heavyImpact()
        }
    }
}