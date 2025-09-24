import SwiftUI

// MARK: - Enhanced Button Interaction System
struct EnhancedButtonInteraction {
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let visualScale: CGFloat
    let animationDuration: Double
    let loadingDuration: Double?
    
    static let light = EnhancedButtonInteraction(
        hapticStyle: .light,
        visualScale: 0.98,
        animationDuration: 0.1,
        loadingDuration: nil
    )
    
    static let medium = EnhancedButtonInteraction(
        hapticStyle: .medium,
        visualScale: 0.96,
        animationDuration: 0.15,
        loadingDuration: 0.3
    )
    
    static let heavy = EnhancedButtonInteraction(
        hapticStyle: .heavy,
        visualScale: 0.94,
        animationDuration: 0.2,
        loadingDuration: 0.5
    )
}

// MARK: - Interactive Button State
struct InteractiveButtonState {
    var isPressed: Bool = false
    var isLoading: Bool = false
    var isCompleted: Bool = false
    var rippleOffset: CGSize = .zero
    var rippleOpacity: Double = 0.0
    var scale: CGFloat = 1.0
}

// MARK: - Enhanced Button Base
struct EnhancedButton<Content: View>: View {
    let content: Content
    let interaction: EnhancedButtonInteraction
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    @State private var state = InteractiveButtonState()
    
    init(
        interaction: EnhancedButtonInteraction = .medium,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.interaction = interaction
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: handleButtonPress) {
            ZStack {
                content
                    .scaleEffect(state.scale)
                    .opacity(isEnabled ? 1.0 : 0.6)
                
                // Loading indicator
                if state.isLoading {
                    LoadingIndicator()
                        .transition(.opacity.combined(with: .scale))
                }
                
                // Ripple effect
                if state.rippleOpacity > 0 {
                    RippleEffect(offset: state.rippleOffset, opacity: state.rippleOpacity)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled || state.isLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state.scale)
        .animation(.easeOut(duration: 0.6), value: state.rippleOpacity)
    }
    
    private func handleButtonPress() {
        guard isEnabled && !state.isLoading else { return }
        
        // Part 1: Tactile Feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: interaction.hapticStyle)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        // Part 2: Visual Feedback
        withAnimation(.easeOut(duration: interaction.animationDuration)) {
            state.isPressed = true
            state.scale = interaction.visualScale
            state.rippleOffset = .zero
            state.rippleOpacity = 1.0
        }
        
        // Part 3: Action Execution
        if let loadingDuration = interaction.loadingDuration {
            state.isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingDuration) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    state.isPressed = false
                    state.scale = 1.0
                    state.isLoading = false
                }
                
                action()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + interaction.animationDuration) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    state.isPressed = false
                    state.scale = 1.0
                }
                
                action()
            }
        }
        
        // Ripple animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.3)) {
                state.rippleOpacity = 0.0
            }
        }
    }
}

// MARK: - Ripple Effect
struct RippleEffect: View {
    let offset: CGSize
    let opacity: Double
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 50
                )
            )
            .frame(width: 100, height: 100)
            .offset(offset)
            .opacity(opacity)
    }
}

// MARK: - Loading Indicator
struct LoadingIndicator: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.white, lineWidth: 2)
            .frame(width: 20, height: 20)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Standardized Button Styles
enum MTButtonStyles {
    
    // MARK: - Transparent Button Style (No Visual Changes)
    struct PrimaryButtonStyle: ButtonStyle {
        let isEnabled: Bool
        let isLoading: Bool
        let interaction: EnhancedButtonInteraction
        
        init(isEnabled: Bool = true, isLoading: Bool = false, interaction: EnhancedButtonInteraction = .medium) {
            self.isEnabled = isEnabled
            self.isLoading = isLoading
            self.interaction = interaction
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? interaction.visualScale : 1.0)
                .opacity(isEnabled ? 1.0 : 0.6)
                .animation(.easeInOut(duration: interaction.animationDuration), value: configuration.isPressed)
                .onChange(of: configuration.isPressed) { _, isPressed in
                    if isPressed {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: interaction.hapticStyle)
                        impactFeedback.prepare()
                        impactFeedback.impactOccurred()
                    }
                }
        }
    }
    
    // MARK: - Transparent Secondary Button Style (No Visual Changes)
    struct SecondaryButtonStyle: ButtonStyle {
        let isEnabled: Bool
        let interaction: EnhancedButtonInteraction
        
        init(isEnabled: Bool = true, interaction: EnhancedButtonInteraction = .light) {
            self.isEnabled = isEnabled
            self.interaction = interaction
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? interaction.visualScale : 1.0)
                .opacity(isEnabled ? 1.0 : 0.6)
                .animation(.easeInOut(duration: interaction.animationDuration), value: configuration.isPressed)
                .onChange(of: configuration.isPressed) { _, isPressed in
                    if isPressed {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: interaction.hapticStyle)
                        impactFeedback.prepare()
                        impactFeedback.impactOccurred()
                    }
                }
        }
    }
    
    // MARK: - Destructive Button Style
    struct DestructiveButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                )
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }
    
    // MARK: - Icon Button Style
    struct IconButtonStyle: ButtonStyle {
        let color: Color
        let size: CGFloat
        
        init(color: Color = .accentColor, size: CGFloat = 44) {
            self.color = color
            self.size = size
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }
    
    // MARK: - Transparent Card Button Style (No Visual Changes)
    struct CardButtonStyle: ButtonStyle {
        let color: Color
        let interaction: EnhancedButtonInteraction
        
        init(color: Color = .accentColor, interaction: EnhancedButtonInteraction = .light) {
            self.color = color
            self.interaction = interaction
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? interaction.visualScale : 1.0)
                .animation(.easeInOut(duration: interaction.animationDuration), value: configuration.isPressed)
                .onChange(of: configuration.isPressed) { _, isPressed in
                    if isPressed {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: interaction.hapticStyle)
                        impactFeedback.prepare()
                        impactFeedback.impactOccurred()
                    }
                }
        }
    }
    
    // MARK: - Liquid Glass Button Style
    struct LiquidGlassButtonStyle: ButtonStyle {
        let accentColor: Color
        let interaction: EnhancedButtonInteraction
        
        init(accentColor: Color = .accentColor, interaction: EnhancedButtonInteraction = .medium) {
            self.accentColor = accentColor
            self.interaction = interaction
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.8),
                                    accentColor
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                )
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.semibold)
                .scaleEffect(configuration.isPressed ? interaction.visualScale : 1.0)
                .animation(.easeInOut(duration: interaction.animationDuration), value: configuration.isPressed)
                .onChange(of: configuration.isPressed) { _, isPressed in
                    if isPressed {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: interaction.hapticStyle)
                        impactFeedback.prepare()
                        impactFeedback.impactOccurred()
                    }
                }
        }
    }
}

// MARK: - Button Style Extensions
extension ButtonStyle where Self == MTButtonStyles.PrimaryButtonStyle {
    static func primary(isEnabled: Bool = true, isLoading: Bool = false, interaction: EnhancedButtonInteraction = .medium) -> MTButtonStyles.PrimaryButtonStyle {
        MTButtonStyles.PrimaryButtonStyle(isEnabled: isEnabled, isLoading: isLoading, interaction: interaction)
    }
}

extension ButtonStyle where Self == MTButtonStyles.SecondaryButtonStyle {
    static func secondary(isEnabled: Bool = true, interaction: EnhancedButtonInteraction = .light) -> MTButtonStyles.SecondaryButtonStyle {
        MTButtonStyles.SecondaryButtonStyle(isEnabled: isEnabled, interaction: interaction)
    }
}

extension ButtonStyle where Self == MTButtonStyles.CardButtonStyle {
    static func card(color: Color = .accentColor, interaction: EnhancedButtonInteraction = .light) -> MTButtonStyles.CardButtonStyle {
        MTButtonStyles.CardButtonStyle(color: color, interaction: interaction)
    }
}

extension ButtonStyle where Self == MTButtonStyles.LiquidGlassButtonStyle {
    static func liquidGlass(accentColor: Color = .accentColor, interaction: EnhancedButtonInteraction = .medium) -> MTButtonStyles.LiquidGlassButtonStyle {
        MTButtonStyles.LiquidGlassButtonStyle(accentColor: accentColor, interaction: interaction)
    }
}

// MARK: - Navigation Button with Loading States
struct NavigationButton<Destination: View, Content: View>: View {
    let destination: Destination
    let content: Content
    let isLoading: Bool
    let isEnabled: Bool
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let loadingMessage: String?
    
    @State private var isPressed = false
    @State private var scale: CGFloat = 1.0
    @State private var showLoading = false
    @State private var navigationTriggered = false
    
    init(
        destination: Destination,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        loadingMessage: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.destination = destination
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.hapticStyle = hapticStyle
        self.loadingMessage = loadingMessage
        self.content = content()
    }
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $navigationTriggered) {
            ZStack {
                content
                    .scaleEffect(scale)
                    .opacity(isEnabled ? 1.0 : 0.6)
                
                // Loading indicator overlay
                if showLoading {
                    LoadingOverlay(message: loadingMessage)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled || showLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: scale)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isEnabled && !showLoading {
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = true
                            scale = 0.96
                        }
                    }
                }
                .onEnded { _ in
                    if isEnabled && !showLoading {
                        handleNavigation()
                    }
                }
        )
    }
    
    private func handleNavigation() {
        // Immediate haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: hapticStyle)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        // Visual feedback
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isPressed = false
            scale = 1.0
        }
        
        // Show loading state if needed
        if isLoading {
            showLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showLoading = false
                navigationTriggered = true
            }
        } else {
            navigationTriggered = true
        }
    }
}

// MARK: - Action Button with Result Feedback
struct ActionButton<Content: View>: View {
    let content: Content
    let action: () async -> Void
    let isEnabled: Bool
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let successMessage: String?
    let errorMessage: String?
    
    @State private var isPressed = false
    @State private var scale: CGFloat = 1.0
    @State private var showLoading = false
    @State private var showResult = false
    @State private var resultMessage = ""
    @State private var isSuccess = false
    
    init(
        action: @escaping () async -> Void,
        isEnabled: Bool = true,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        successMessage: String? = nil,
        errorMessage: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.isEnabled = isEnabled
        self.hapticStyle = hapticStyle
        self.successMessage = successMessage
        self.errorMessage = errorMessage
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Button(action: handleAction) {
                ZStack {
                    content
                        .scaleEffect(scale)
                        .opacity(isEnabled ? 1.0 : 0.6)
                    
                    // Loading indicator overlay
                    if showLoading {
                        LoadingOverlay()
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!isEnabled || showLoading)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: scale)
            
            // Result feedback overlay
            if showResult {
                ResultFeedbackView(
                    message: resultMessage,
                    isSuccess: isSuccess
                ) {
                    showResult = false
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    private func handleAction() {
        guard isEnabled && !showLoading else { return }
        
        // Immediate haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: hapticStyle)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        // Visual press animation
        withAnimation(.easeOut(duration: 0.15)) {
            isPressed = true
            scale = 0.96
        }
        
        // Show loading state
        showLoading = true
        
        // Execute async action
        Task {
            do {
                await action()
                
                // Success feedback
                await MainActor.run {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isPressed = false
                        scale = 1.0
                        showLoading = false
                    }
                    
                    if let successMessage = successMessage {
                        resultMessage = successMessage
                        isSuccess = true
                        showResult = true
                        
                        // Auto-hide after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showResult = false
                        }
                    }
                }
            } catch {
                // Error feedback
                await MainActor.run {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isPressed = false
                        scale = 1.0
                        showLoading = false
                    }
                    
                    resultMessage = errorMessage ?? "Something went wrong"
                    isSuccess = false
                    showResult = true
                    
                    // Auto-hide after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showResult = false
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct LoadingOverlay: View {
    let message: String?
    
    init(message: String? = nil) {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Pulsing spinner
                PulsingSpinner()
                
                if let message = message {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(16)
            .glassEffect(GlassEffectPreset.button)
        }
    }
}

struct PulsingSpinner: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(
                    colors: [.accentColor, .accentColor.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: 24, height: 24)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct ResultFeedbackView: View {
    let message: String
    let isSuccess: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(isSuccess ? .green : .red)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            onDismiss()
        }
    }
}

// MARK: - Convenience Extensions for EnhancedButton

extension EnhancedButton {
    static func primary(
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> EnhancedButton {
        EnhancedButton(
            interaction: .medium,
            isLoading: isLoading,
            isEnabled: isEnabled,
            action: action,
            content: content
        )
    }
    
    static func secondary(
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> EnhancedButton {
        EnhancedButton(
            interaction: .light,
            isLoading: isLoading,
            isEnabled: isEnabled,
            action: action,
            content: content
        )
    }
    
    static func heavy(
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> EnhancedButton {
        EnhancedButton(
            interaction: .heavy,
            isLoading: isLoading,
            isEnabled: isEnabled,
            action: action,
            content: content
        )
    }
}

// MARK: - Legacy Button Styles (duplicates removed - already defined above)
