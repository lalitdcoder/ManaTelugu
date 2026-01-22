import SwiftUI
import UIKit

// MARK: - Simplified Accessibility System

struct AccessibilityEnhancements {
    static func configureAppForAccessibility() {
        // Basic accessibility configuration
    }
}

// MARK: - Accessibility-Aware View Modifiers
extension View {
    func teluguAccessible(
        label: String,
        hint: String? = nil,
        value: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
            .accessibilityAddTraits(traits)
    }
    
    func accessibleTouchTarget() -> some View {
        self.frame(minWidth: 44, minHeight: 44)
    }
    
    func accessibleAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        self.animation(
            UIAccessibility.isReduceMotionEnabled ? nil : animation,
            value: value
        )
    }
    
    func accessibleTransparency(opacity: Double) -> some View {
        self.opacity(
            UIAccessibility.isReduceTransparencyEnabled ? 1.0 : opacity
        )
    }
    
    func accessibleFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        self.font(.system(style, design: .rounded, weight: weight))
    }
    
    func accessibleGroup(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
    
    func announceChange(_ message: String) -> some View {
        self.onChange(of: message) { _, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(notification: .announcement, argument: newValue)
            }
        }
    }
}

// MARK: - Accessibility State Manager
class AccessibilityStateManager: ObservableObject {
    @Published var isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
    @Published var isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
    @Published var isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
    @Published var isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
    @Published var preferredContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
    
    init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.boldTextStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.preferredContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        }
    }
}

// MARK: - Accessibility Announcements Helper
struct AccessibilityAnnouncer {
    static func announce(_ message: String, delay: TimeInterval = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    
    static func announceLayoutChange() {
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
    }
    
    static func announceScreenChange() {
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
