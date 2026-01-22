import SwiftUI

// MARK: - View Extensions for Easy Haptic Integration
extension View {
    /// Adds haptic feedback to any view when tapped
    func hapticTap(_ type: HapticType = .light) -> some View {
        self.onTapGesture {
            switch type {
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
    
    /// Adds context-specific haptic feedback
    func hapticFeedback(for context: HapticContext) -> some View {
        self.onTapGesture {
            switch context {
            case .buttonTap:
                HapticsService.shared.buttonTap()
            case .navigation:
                HapticsService.shared.navigationTap()
            case .correctAnswer:
                HapticsService.shared.correctAnswer()
            case .wrongAnswer:
                HapticsService.shared.wrongAnswer()
            case .lessonComplete:
                HapticsService.shared.lessonComplete()
            case .audioPlay:
                HapticsService.shared.audioPlay()
            case .optionSelect:
                HapticsService.shared.optionSelect()
            case .importantAction:
                HapticsService.shared.importantAction()
            case .gameStart:
                HapticsService.shared.gameStart()
            case .progressUpdate:
                HapticsService.shared.progressUpdate()
            }
        }
    }
}

// MARK: - Haptic Context Enum
enum HapticContext {
    case buttonTap
    case navigation
    case correctAnswer
    case wrongAnswer
    case lessonComplete
    case audioPlay
    case optionSelect
    case importantAction
    case gameStart
    case progressUpdate
}

// MARK: - Haptic Feedback Modifiers
struct HapticFeedbackModifier: ViewModifier {
    let hapticType: HapticType
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .onChange(of: trigger) { _, newValue in
                if newValue {
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

extension View {
    /// Triggers haptic feedback when a boolean value changes to true
    func hapticFeedback(_ type: HapticType, trigger: Bool) -> some View {
        self.modifier(HapticFeedbackModifier(hapticType: type, trigger: trigger))
    }
}