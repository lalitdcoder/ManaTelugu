import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    private init() {}

    // Bridge to existing service so user setting is respected
    private var service: HapticsService { HapticsService.shared }

    var isEnabled: Bool {
        get { service.isEnabled }
        set { service.isEnabled = newValue }
    }

    // Unified APIs
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard service.isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard service.isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func selection() {
        guard service.isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    enum HapticStyle {
        case light
        case medium
        case heavy
        case success
        case error
        case warning
    }

    func trigger(_ style: HapticStyle) {
        guard service.isEnabled else { return }
        switch style {
        case .light: impact(.light)
        case .medium: impact(.medium)
        case .heavy: impact(.heavy)
        case .success: notification(.success)
        case .error: notification(.error)
        case .warning: notification(.warning)
        }
    }
}
