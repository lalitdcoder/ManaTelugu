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
}
