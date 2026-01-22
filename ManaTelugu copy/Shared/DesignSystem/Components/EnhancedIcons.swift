import SwiftUI

// MARK: - Enhanced Icon System
struct EnhancedIcons {
    
    // MARK: - Custom Icon View
    struct CustomIcon: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let weight: Font.Weight
        let isAnimated: Bool
        
        @State private var isAnimating = false
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            weight: Font.Weight = .medium,
            isAnimated: Bool = false
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.weight = weight
            self.isAnimated = isAnimated
        }
        
        var body: some View {
            Image(systemName: systemName)
                .font(.system(size: size, weight: weight))
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    isAnimated ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                    value: isAnimating
                )
                .onAppear {
                    if isAnimated {
                        isAnimating = true
                    }
                }
        }
    }
    
    // MARK: - Pulsing Icon
    struct PulsingIcon: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let pulseColor: Color
        let pulseSize: CGFloat
        
        @State private var isPulsing = false
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            pulseColor: Color? = nil,
            pulseSize: CGFloat = 1.2
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.pulseColor = pulseColor ?? color
            self.pulseSize = pulseSize
        }
        
        var body: some View {
            ZStack {
                // Pulse ring
                if isPulsing {
                    Circle()
                        .fill(pulseColor.opacity(0.3))
                        .frame(width: size * pulseSize, height: size * pulseSize)
                        .scaleEffect(isPulsing ? 1.5 : 1.0)
                        .opacity(isPulsing ? 0.0 : 1.0)
                        .animation(.easeOut(duration: 1.0).repeatForever(autoreverses: false), value: isPulsing)
                }
                
                // Main icon
                Image(systemName: systemName)
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(color)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.0).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
        }
    }
    
    // MARK: - Glowing Icon
    struct GlowingIcon: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let glowColor: Color
        let glowRadius: CGFloat
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            glowColor: Color? = nil,
            glowRadius: CGFloat = 8
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.glowColor = glowColor ?? color
            self.glowRadius = glowRadius
        }
        
        var body: some View {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(color)
                .shadow(color: glowColor, radius: glowRadius, x: 0, y: 0)
        }
    }
    
    // MARK: - Rotating Icon
    struct RotatingIcon: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let rotationSpeed: Double
        let isRotating: Bool
        
        @State private var rotation: Double = 0
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            rotationSpeed: Double = 2.0,
            isRotating: Bool = true
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.rotationSpeed = rotationSpeed
            self.isRotating = isRotating
        }
        
        var body: some View {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(color)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    if isRotating {
                        withAnimation(.linear(duration: rotationSpeed).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                }
        }
    }
    
    // MARK: - Bouncing Icon
    struct BouncingIcon: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let bounceHeight: CGFloat
        let bounceSpeed: Double
        
        @State private var isBouncing = false
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            bounceHeight: CGFloat = 5,
            bounceSpeed: Double = 0.5
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.bounceHeight = bounceHeight
            self.bounceSpeed = bounceSpeed
        }
        
        var body: some View {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(color)
                .offset(y: isBouncing ? -bounceHeight : 0)
                .animation(
                    .easeInOut(duration: bounceSpeed).repeatForever(autoreverses: true),
                    value: isBouncing
                )
                .onAppear {
                    isBouncing = true
                }
        }
    }
    
    // MARK: - Icon with Badge
    struct IconWithBadge: View {
        let systemName: String
        let size: CGFloat
        let color: Color
        let badgeText: String
        let badgeColor: Color
        let badgePosition: BadgePosition
        
        enum BadgePosition {
            case topTrailing
            case topLeading
            case bottomTrailing
            case bottomLeading
        }
        
        init(
            systemName: String,
            size: CGFloat = 24,
            color: Color = .primary,
            badgeText: String,
            badgeColor: Color = .red,
            badgePosition: BadgePosition = .topTrailing
        ) {
            self.systemName = systemName
            self.size = size
            self.color = color
            self.badgeText = badgeText
            self.badgeColor = badgeColor
            self.badgePosition = badgePosition
        }
        
        var body: some View {
            ZStack {
                // Main icon
                Image(systemName: systemName)
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(color)
                
                // Badge
                Text(badgeText)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                    .background(
                        Circle()
                            .fill(badgeColor)
                    )
                    .offset(badgeOffset)
            }
        }
        
        private var badgeOffset: CGSize {
            let offset: CGFloat = size * 0.4
            switch badgePosition {
            case .topTrailing:
                return CGSize(width: offset, height: -offset)
            case .topLeading:
                return CGSize(width: -offset, height: -offset)
            case .bottomTrailing:
                return CGSize(width: offset, height: offset)
            case .bottomLeading:
                return CGSize(width: -offset, height: offset)
            }
        }
    }
}

// MARK: - Custom Icon Set
extension EnhancedIcons {
    
    // MARK: - Learning Icons
    static let alphabet = CustomIcon(systemName: "textformat.abc", size: 28, color: ModernDesignSystem.Colors.funBlue, weight: .semibold)
    static let vocabulary = CustomIcon(systemName: "book.fill", size: 28, color: ModernDesignSystem.Colors.funGreen, weight: .semibold)
    static let stories = CustomIcon(systemName: "books.vertical.fill", size: 28, color: ModernDesignSystem.Colors.funPurple, weight: .semibold)
    static let games = CustomIcon(systemName: "gamecontroller.fill", size: 28, color: ModernDesignSystem.Colors.funPink, weight: .semibold)
    static let progress = CustomIcon(systemName: "chart.bar.fill", size: 28, color: RefinedColors.warmYellow, weight: .semibold)
    
    // MARK: - Navigation Icons
    static let home = CustomIcon(systemName: "house.fill", size: 20, color: .primary, weight: .medium)
    static let lessons = CustomIcon(systemName: "book.fill", size: 20, color: .primary, weight: .medium)
    static let storiesNav = CustomIcon(systemName: "books.vertical.fill", size: 20, color: .primary, weight: .medium)
    static let gamesNav = CustomIcon(systemName: "gamecontroller.fill", size: 20, color: .primary, weight: .medium)
    static let more = CustomIcon(systemName: "ellipsis.circle.fill", size: 20, color: .primary, weight: .medium)
    
    // MARK: - Action Icons
    static let play = CustomIcon(systemName: "play.fill", size: 24, color: .white, weight: .semibold)
    static let pause = CustomIcon(systemName: "pause.fill", size: 24, color: .white, weight: .semibold)
    static let stop = CustomIcon(systemName: "stop.fill", size: 24, color: .white, weight: .semibold)
    static let next = CustomIcon(systemName: "forward.fill", size: 24, color: .white, weight: .semibold)
    static let previous = CustomIcon(systemName: "backward.fill", size: 24, color: .white, weight: .semibold)
    
    // MARK: - Status Icons
    static let checkmark = CustomIcon(systemName: "checkmark.circle.fill", size: 24, color: .green, weight: .semibold)
    static let lock = CustomIcon(systemName: "lock.fill", size: 24, color: .gray, weight: .semibold)
    static let star = CustomIcon(systemName: "star.fill", size: 24, color: .yellow, weight: .semibold)
    static let heart = CustomIcon(systemName: "heart.fill", size: 24, color: .red, weight: .semibold)
    static let flame = CustomIcon(systemName: "flame.fill", size: 24, color: .orange, weight: .semibold)
    
    // MARK: - Animated Icons
    static let loading = RotatingIcon(systemName: "arrow.clockwise", size: 20, color: .accentColor, rotationSpeed: 1.0)
    static let pulsingHeart = PulsingIcon(systemName: "heart.fill", size: 24, color: .red, pulseColor: .red)
    static let glowingStar = GlowingIcon(systemName: "star.fill", size: 24, color: .yellow, glowColor: .yellow, glowRadius: 8)
    static let bouncingArrow = BouncingIcon(systemName: "arrow.up", size: 24, color: .accentColor, bounceHeight: 3, bounceSpeed: 0.8)
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: EnhancedIcons.CustomIcon
    let action: () -> Void
    let backgroundColor: Color
    let size: CGFloat
    
    @State private var isPressed = false
    
    init(
        icon: EnhancedIcons.CustomIcon,
        action: @escaping () -> Void,
        backgroundColor: Color = .clear,
        size: CGFloat = 44
    ) {
        self.icon = icon
        self.action = action
        self.backgroundColor = backgroundColor
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
            
            // Visual feedback
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                if backgroundColor != .clear {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: size, height: size)
                }
                
                icon
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}
