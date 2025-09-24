import SwiftUI
import UIKit

// MARK: - Professional Card System
// High-quality cards with proper visual hierarchy and professional styling

struct ProfessionalCard<Content: View>: View {
    let type: ProfessionalCardType
    let isInteractive: Bool
    let content: () -> Content
    @State private var isPressed = false
    
    init(
        type: ProfessionalCardType = .primary,
        isInteractive: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.type = type
        self.isInteractive = isInteractive
        self.content = content
    }
    
    var body: some View {
        let config = ProfessionalCardConfig.config(for: type)
        
        content()
            .padding(config.padding)
            .background(
                ZStack {
                    // Professional glass background
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .background(
                            // Additional glass layer for depth
                            RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                                .fill(config.backgroundColor)
                        )
                        .overlay(
                            // Professional highlight effect
                            RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                    
                    // No shimmer effects - cleaner design
                    
                    // Professional border
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    config.borderColor,
                                    config.borderColor.opacity(0.5),
                                    config.borderColor.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: config.borderWidth
                        )
                }
            )
            .shadow(
                color: config.shadowColor.opacity(config.shadowOpacity),
                radius: config.shadowRadius,
                x: 0,
                y: config.shadowOffset
            )
            .shadow(
                color: config.shadowColor.opacity(config.shadowOpacity * 0.5),
                radius: config.shadowRadius * 1.5,
                x: 0,
                y: config.shadowOffset * 1.5
            )
            .shadow(
                color: Color.white.opacity(0.1),
                radius: 2,
                x: 0,
                y: -1
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
            .onTapGesture {
                if isInteractive {
                    ProfessionalHaptics.medium()
                    withAnimation(ProfessionalAnimation.cardPress) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(ProfessionalAnimation.cardRelease) {
                            isPressed = false
                        }
                    }
                }
            }
    }
}

// MARK: - Professional Button System
struct ProfessionalButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    @State private var isPressed = false
    
    enum ButtonStyle {
        case primary
        case secondary
        case accent
        case ghost
    }
    
    init(
        _ title: String,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            ProfessionalHaptics.light()
            action()
        }) {
            ProfessionalText(
                title,
                style: .buttonText,
                color: textColor,
                alignment: .center
            )
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .opacity(isPressed ? 0.9 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(ProfessionalAnimation.cardPress) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .professionalBlue
        case .secondary:
            return .cardPrimary
        case .accent:
            return .professionalOrange
        case .ghost:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .accent:
            return .white
        case .secondary, .ghost:
            return .textPrimary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .accent:
            return Color.clear
        case .secondary:
            return .white.opacity(0.3)
        case .ghost:
            return .white.opacity(0.2)
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .accent:
            return 0
        case .secondary, .ghost:
            return 1
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return .professionalBlue.opacity(0.3)
        case .secondary:
            return .black.opacity(0.15)
        case .accent:
            return .professionalOrange.opacity(0.3)
        case .ghost:
            return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .primary, .accent:
            return 12
        case .secondary:
            return 8
        case .ghost:
            return 0
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .primary, .accent:
            return 6
        case .secondary:
            return 4
        case .ghost:
            return 0
        }
    }
}

// MARK: - Professional Stat Card
struct ProfessionalStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let type: ProfessionalCardType
    
    init(
        icon: String,
        value: String,
        label: String,
        color: Color = .professionalBlue,
        type: ProfessionalCardType = .stat
    ) {
        self.icon = icon
        self.value = value
        self.label = label
        self.color = color
        self.type = type
    }
    
    var body: some View {
        ProfessionalCard(type: type) {
            VStack(spacing: ProfessionalSpacing.small.value) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )
                
                // Value
                ProfessionalText(
                    value,
                    style: .statValue,
                    color: .textPrimary,
                    alignment: .center
                )
                
                // Label
                ProfessionalText(
                    label,
                    style: .statLabel,
                    color: .textSecondary,
                    alignment: .center
                )
            }
        }
    }
}

// MARK: - Professional Progress Card
struct ProfessionalProgressCard: View {
    let title: String
    let progress: Double
    let currentValue: Int
    let totalValue: Int
    let color: Color
    let type: ProfessionalCardType
    
    init(
        title: String,
        progress: Double,
        currentValue: Int,
        totalValue: Int,
        color: Color = .professionalBlue,
        type: ProfessionalCardType = .primary
    ) {
        self.title = title
        self.progress = progress
        self.currentValue = currentValue
        self.totalValue = totalValue
        self.color = color
        self.type = type
    }
    
    var body: some View {
        ProfessionalCard(type: type) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                // Title
                ProfessionalText(
                    title,
                    style: .cardTitle,
                    color: .textPrimary
                )
                
                // Progress bar
                VStack(spacing: ProfessionalSpacing.small.value) {
                    // Progress track
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 12)
                            
                            // Progress fill
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [color, color.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progress, height: 12)
                                .animation(ProfessionalAnimation.progressUpdate, value: progress)
                        }
                    }
                    .frame(height: 12)
                    
                    // Progress text
                    HStack {
                        ProfessionalText(
                            "\(currentValue) of \(totalValue)",
                            style: .caption,
                            color: .textSecondary
                        )
                        
                        Spacer()
                        
                        ProfessionalText(
                            "\(Int(progress * 100))%",
                            style: .caption,
                            color: color
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Professional Section Header
struct ProfessionalSectionHeader: View {
    let title: String
    let subtitle: String?
    let action: (() -> Void)?
    let actionTitle: String?
    
    init(
        title: String,
        subtitle: String? = nil,
        action: (() -> Void)? = nil,
        actionTitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.actionTitle = actionTitle
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.tiny.value) {
                ProfessionalText(
                    title,
                    style: .sectionHeader,
                    color: .textPrimary
                )
                
                if let subtitle = subtitle {
                    ProfessionalText(
                        subtitle,
                        style: .bodyText,
                        color: .textSecondary
                    )
                }
            }
            
            Spacer()
            
            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    HStack(spacing: ProfessionalSpacing.tiny.value) {
                        ProfessionalText(
                            actionTitle,
                            style: .buttonText,
                            color: .professionalBlue
                        )
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.professionalBlue)
                    }
                }
            }
        }
        .padding(.horizontal, ProfessionalSpacing.medium.value)
        .padding(.vertical, ProfessionalSpacing.small.value)
    }
}
