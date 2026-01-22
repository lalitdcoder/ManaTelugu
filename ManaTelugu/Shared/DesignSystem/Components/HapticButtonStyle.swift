import SwiftUI

struct HapticButtonStyle: ButtonStyle {
    let hapticType: HapticType
    
    init(hapticType: HapticType = .medium) {
        self.hapticType = hapticType
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    performHaptic()
                }
            }
    }
    
    private func performHaptic() {
        switch hapticType {
        case .light:
            HapticsService.shared.lightImpact()
        case .medium:
            HapticsService.shared.mediumImpact()
        case .heavy:
            HapticsService.shared.heavyImpact()
        case .selection:
            HapticsService.shared.selection()
        case .success:
            HapticsService.shared.success()
        case .error:
            HapticsService.shared.error()
        case .warning:
            HapticsService.shared.warning()
        }
    }
}

struct HapticPlainButtonStyle: ButtonStyle {
    let hapticType: HapticType
    
    init(hapticType: HapticType = .light) {
        self.hapticType = hapticType
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    performHaptic()
                }
            }
    }
    
    private func performHaptic() {
        switch hapticType {
        case .light:
            HapticsService.shared.lightImpact()
        case .medium:
            HapticsService.shared.mediumImpact()
        case .heavy:
            HapticsService.shared.heavyImpact()
        case .selection:
            HapticsService.shared.selection()
        case .success:
            HapticsService.shared.success()
        case .error:
            HapticsService.shared.error()
        case .warning:
            HapticsService.shared.warning()
        }
    }
}

// MARK: - Haptic Type Enum
enum HapticType {
    case light
    case medium
    case heavy
    case selection
    case success
    case error
    case warning
}

// MARK: - Convenience Button Styles
struct SuccessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HapticButtonStyle(hapticType: .success).makeBody(configuration: configuration)
    }
}

struct ErrorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HapticButtonStyle(hapticType: .error).makeBody(configuration: configuration)
    }
}

struct ImportantButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HapticButtonStyle(hapticType: .medium).makeBody(configuration: configuration)
    }
}

struct SelectionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HapticButtonStyle(hapticType: .selection).makeBody(configuration: configuration)
    }
}
