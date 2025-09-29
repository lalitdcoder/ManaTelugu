import SwiftUI

// MARK: - HIG Compliant Button System
// Ensures all buttons meet Apple's accessibility and design standards

struct HIGPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isEnabled: Bool
    let isLoading: Bool
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            guard isEnabled && !isLoading else { return }
            session.hapticsService.lightImpact()
            action()
        }) {
            HStack(spacing: MTSpacing.small) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                HIGDynamicText(
                    title,
                    style: .body,
                    weight: .semibold,
                    color: .white
                )
            }
            .padding(.horizontal, MTSpacing.large)
            .padding(.vertical, MTSpacing.medium)
            .frame(minHeight: MTSpacing.minimumTouchTarget)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEnabled ? MTColors.primary : MTColors.primary.opacity(0.5))
            )
        }
        .disabled(!isEnabled || isLoading)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityHint(isLoading ? "Loading" : "Double tap to activate")
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isLoading ? "Loading" : "")
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if isEnabled && !isLoading {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct HIGSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isEnabled: Bool
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            session.hapticsService.lightImpact()
            action()
        }) {
            HStack(spacing: MTSpacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                HIGDynamicText(
                    title,
                    style: .body,
                    weight: .medium,
                    color: isEnabled ? MTColors.primary : MTColors.secondaryText
                )
            }
            .padding(.horizontal, MTSpacing.large)
            .padding(.vertical, MTSpacing.medium)
            .frame(minHeight: MTSpacing.minimumTouchTarget)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isEnabled ? MTColors.primary : MTColors.secondaryText, lineWidth: 1.5)
            )
        }
        .disabled(!isEnabled)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to activate")
        .accessibilityAddTraits(.isButton)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if isEnabled {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct HIGIconButton: View {
    let icon: String
    let label: String
    let hint: String
    let size: HIGButtonSize
    let style: HIGIconButtonStyle
    let action: () -> Void
    let isEnabled: Bool
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        icon: String,
        label: String,
        hint: String,
        size: HIGButtonSize = .medium,
        style: HIGIconButtonStyle = .filled,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.hint = hint
        self.size = size
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            session.hapticsService.lightImpact()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundColor(style.foregroundColor(isEnabled: isEnabled))
                .frame(width: size.frameSize, height: size.frameSize)
                .background(
                    Circle()
                        .fill(style.backgroundColor(isEnabled: isEnabled))
                )
        }
        .disabled(!isEnabled)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(label)
        .accessibilityHint(hint)
        .accessibilityAddTraits(.isButton)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if isEnabled {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct HIGFloatingActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        icon: String,
        label: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            session.hapticsService.mediumImpact()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(MTColors.primary)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(label)
        .accessibilityHint("Double tap to activate")
        .accessibilityAddTraits(.isButton)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Supporting Types
enum HIGButtonSize {
    case small, medium, large
    
    var frameSize: CGFloat {
        switch self {
        case .small: return MTSpacing.minimumTouchTarget
        case .medium: return MTSpacing.recommendedTouchTarget
        case .large: return 56
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }
}

enum HIGIconButtonStyle {
    case filled, outlined, plain
    
    func backgroundColor(isEnabled: Bool) -> Color {
        switch self {
        case .filled:
            return isEnabled ? MTColors.primary : MTColors.primary.opacity(0.5)
        case .outlined:
            return Color.clear
        case .plain:
            return Color.clear
        }
    }
    
    func foregroundColor(isEnabled: Bool) -> Color {
        switch self {
        case .filled:
            return .white
        case .outlined, .plain:
            return isEnabled ? MTColors.primary : MTColors.secondaryText
        }
    }
}

// MARK: - Button Group
struct HIGButtonGroup<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = MTSpacing.medium, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            content
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Convenience Extensions
extension View {
    func higPrimaryButton(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        HIGPrimaryButton(title, icon: icon, isEnabled: isEnabled, isLoading: isLoading, action: action)
    }
    
    func higSecondaryButton(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        HIGSecondaryButton(title, icon: icon, isEnabled: isEnabled, action: action)
    }
}
