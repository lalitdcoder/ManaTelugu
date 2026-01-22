import SwiftUI

// MARK: - Missing Components for ManaTelugu App

// MARK: - Liquid Glass Header
struct LiquidGlassHeader: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let layer: LiquidGlassLayer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(20)
                .glassEffect(GlassEffectPreset.card)
    }
}


// MARK: - Enhanced Word of the Day Card
struct EnhancedWordOfTheDayCard: View {
    let word: String
    let translation: String
    let progress: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Word of the Day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(word)
                        .font(ModernDesignSystem.Typography.teluguTitle)
                        .fontWeight(.bold)
                        .foregroundColor(ModernDesignSystem.Colors.culturalGold)
                    
                    Text(translation)
                        .font(ModernDesignSystem.Typography.teluguHeading)
                        .foregroundColor(ModernDesignSystem.Colors.culturalOrange)
                }
                
                Spacer()
                
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(ModernDesignSystem.Colors.textTertiary.opacity(0.2), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [ModernDesignSystem.Colors.culturalGold, ModernDesignSystem.Colors.culturalOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(20)
        .glassEffect(.regular, shape: .rect(cornerRadius: 24))
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Horizontal Learning Cards
struct HorizontalLearningCards: View {
    let learningModes: [LearningMode]
    let onModeSelected: (LearningMode) -> Void
    
    struct LearningMode: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let iconName: String
        let color: Color
        let progress: Double
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(learningModes) { mode in
                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            onModeSelected(mode)
                        },
                        content: {
                            UnifiedLiquidGlassCard(
                                layer: .content,
                                intensity: 0.15,
                                cornerRadius: 20,
                                padding: 16,
                                isInteractive: true
                            ) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: mode.iconName)
                                            .font(.title2)
                                            .foregroundColor(mode.color)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(mode.progress * 100))%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(mode.color)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(mode.title)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Text(mode.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    // Progress bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
.fill(ModernDesignSystem.Colors.textTertiary.opacity(0.2))
                                                .frame(height: 4)
                                            
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(mode.color)
                                                .frame(width: geometry.size.width * mode.progress, height: 4)
                                                .animation(.easeInOut(duration: 0.8), value: mode.progress)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }
                        }
                    )
                    .frame(width: 200)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}


// MARK: - Last Activity Model (duplicate removed - already exists in UserProfile.swift)

// MARK: - Enhanced Progress Bar (duplicate removed - already exists in EnhancedProgressBar.swift)

// MARK: - Recent Badges View (duplicate removed - already exists in RecentBadgesView.swift)

// MARK: - Daily Missions View (duplicate removed - already exists in DailyMissionsView.swift)

// MARK: - Dynamic Liquid Glass Card
struct DynamicLiquidGlassCard<Content: View>: View {
    let content: Content
    let layer: LiquidGlassLayer
    let intensity: Double
    let cornerRadius: CGFloat
    let padding: CGFloat
    let isInteractive: Bool
    
    init(
        layer: LiquidGlassLayer = .content,
        intensity: Double = 0.15,
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 16,
        isInteractive: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.layer = layer
        self.intensity = intensity
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.isInteractive = isInteractive
        self.content = content()
    }
    
    var body: some View {
        LiquidGlassView(
            layer: layer,
            intensity: intensity,
            cornerRadius: cornerRadius,
            padding: padding
        ) {
            content
        }
    }
}

// MARK: - Liquid Glass Card
struct LiquidGlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let padding: CGFloat
    
    init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        LiquidGlassView(
            layer: .content,
            intensity: 0.15,
            cornerRadius: cornerRadius,
            padding: padding
        ) {
            content
        }
    }
}

// MARK: - Liquid Glass Stats Card
struct LiquidGlassStatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        LiquidGlassCard(cornerRadius: 16, padding: 16) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Liquid Glass Toggle
struct LiquidGlassToggle: View {
    let title: String
    let isOn: Binding<Bool>
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: ModernDesignSystem.Colors.funBlue))
                .onChange(of: isOn.wrappedValue) { _, _ in
                    HapticsManager.shared.selection()
                }
        }
        .padding()
        .background(
            LiquidGlassView(
                layer: .content,
                intensity: 0.1,
                cornerRadius: 12,
                padding: 0
            ) {
                Color.clear
            }
        )
    }
}

// MARK: - Global Animated Background (defined in LiquidGlassView.swift)

// MARK: - Unified Liquid Glass Card (defined in LiquidGlassView.swift)

// MARK: - Liquid Glass Button
struct LiquidGlassButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        EnhancedButton(
            interaction: .medium,
            isLoading: false,
            isEnabled: true,
            action: action,
            content: {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
.foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .padding(.vertical, 12)
                    .background(
                        LiquidGlassView(
                            layer: .content,
                            intensity: 0.2,
                            cornerRadius: 25,
                            padding: 0
                        ) {
                            ModernDesignSystem.Colors.funBlue
                        }
                    )
            }
        )
    }
}

// MARK: - Global Alert
struct GlobalAlert: View {
    let title: String
    let message: String
    let primaryButton: AlertButton
    let secondaryButton: AlertButton?
    let isPresented: Binding<Bool>
    
    struct AlertButton {
        let title: String
        let style: Style
        let action: () -> Void
        
        enum Style {
            case primary
            case secondary
            case destructive
        }
    }
    
    var body: some View {
        if isPresented.wrappedValue {
            ZStack {
                ModernDesignSystem.Colors.shadow.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
                
                VStack(spacing: 20) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        if let secondary = secondaryButton {
                            EnhancedButton(
                                interaction: .medium,
                                isLoading: false,
                                isEnabled: true,
                                action: {
                                    secondary.action()
                                    isPresented.wrappedValue = false
                                },
                                content: {
                                    Text(secondary.title)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(.systemGray5))
                                        )
                                }
                            )
                        }
                        
                        EnhancedButton(
                            interaction: .medium,
                            isLoading: false,
                            isEnabled: true,
                            action: {
                                primaryButton.action()
                                isPresented.wrappedValue = false
                            },
                            content: {
                                Text(primaryButton.title)
                                    .font(.body)
                                    .fontWeight(.medium)
.foregroundColor(ModernDesignSystem.Colors.textPrimary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(primaryButton.style == .destructive ? ModernDesignSystem.Colors.error : ModernDesignSystem.Colors.funBlue)
                                    )
                            }
                        )
                    }
                }
                .padding(24)
                .background(
                    LiquidGlassView(
                        layer: .content,
                        intensity: 0.15,
                        cornerRadius: 20,
                        padding: 0
                    ) {
                        Color(.systemBackground)
                    }
                )
                .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - Global Interactive Button
struct GlobalInteractiveButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        EnhancedButton(
            interaction: .medium,
            isLoading: false,
            isEnabled: true,
            action: action,
            content: {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LiquidGlassView(
                            layer: .content,
                            intensity: 0.2,
                            cornerRadius: 12,
                            padding: 0
                        ) {
                            ModernDesignSystem.Colors.funBlue
                        }
                    )
            }
        )
    }
}

// MARK: - Continue Learning View
struct ContinueLearningView: View {
    let learningModes: [HorizontalLearningCards.LearningMode]
    let onModeSelected: (HorizontalLearningCards.LearningMode) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(learningModes) { mode in
                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            onModeSelected(mode)
                        },
                        content: {
                            ContinueLearningCard(mode: mode)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Continue Learning Card
struct ContinueLearningCard: View {
    let mode: HorizontalLearningCards.LearningMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Enhanced icon with liquid glass effect
                ZStack {
                    Circle()
                        .fill(mode.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: mode.iconName)
                        .font(.title2)
                        .foregroundColor(mode.color)
                }
                
                Spacer()
                
                // Progress indicator
                Text("\(Int(mode.progress * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(mode.color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(mode.title)
                    .font(EnhancedTypography.cardTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(mode.description)
                    .font(EnhancedTypography.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(ModernDesignSystem.Colors.textTertiary.opacity(0.2))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(mode.color)
                        .frame(width: geometry.size.width * mode.progress, height: 4)
                        .animation(.easeInOut(duration: 0.8), value: mode.progress)
                }
            }
            .frame(height: 4)
        }
        .padding(16)
        .frame(width: 180, height: 160, alignment: .topLeading)
    }
}

// MARK: - Home Navigation Destination (duplicate removed - already exists in HomeNavigationDestination.swift)
