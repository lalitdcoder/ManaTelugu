import UIKit
import CoreHaptics

class HapticsService {
    static let shared = HapticsService()
    
    // User-controlled enable flag
    var isEnabled: Bool = true
    
    private init() {}
    
    // Device capability
    private var isDeviceCapable: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    private var canHaptic: Bool { isEnabled && isDeviceCapable }
    
    // MARK: - Impact Feedback
    func lightImpact() {
        guard canHaptic else { return }
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
    }
    
    func mediumImpact() {
        guard canHaptic else { return }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
    }
    
    func heavyImpact() {
        guard canHaptic else { return }
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.prepare()
        impact.impactOccurred()
    }
    
    // MARK: - Notification Feedback
    func warning() {
        guard canHaptic else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.warning)
    }
    
    func success() {
        guard canHaptic else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.success)
    }
    
    func error() {
        guard canHaptic else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.prepare()
        impact.notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback
    func selection() {
        guard canHaptic else { return }
        let selection = UISelectionFeedbackGenerator()
        selection.prepare()
        selection.selectionChanged()
    }
    
    // MARK: - Context-Specific Feedback
    func buttonTap() {
        lightImpact()
    }
    
    func navigationTap() {
        selection()
    }
    
    func correctAnswer() {
        success()
    }
    
    func wrongAnswer() {
        error()
    }
    
    func lessonComplete() {
        heavyImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.success()
        }
    }
    
    func audioPlay() {
        selection()
    }
    
    func optionSelect() {
        lightImpact()
    }
    
    func importantAction() {
        mediumImpact()
    }
    
    func gameStart() {
        mediumImpact()
    }
    
    func progressUpdate() {
        lightImpact()
    }
    
    // Debug function to test haptic feedback
    func testHaptics() {
        print("Testing haptic feedback - Device supports haptics: \(isDeviceCapable), enabled: \(isEnabled)")
        lightImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mediumImpact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.heavyImpact()
        }
    }
}
