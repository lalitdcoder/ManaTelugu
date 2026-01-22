import SwiftUI

// MARK: - State-Based UI System
struct StateBasedUI {
    
    // MARK: - Animated Progress Bar
    struct AnimatedProgressBar: View {
        let progress: Double
        let total: Double
        let accentColor: Color
        let height: CGFloat
        let cornerRadius: CGFloat
        
        @State private var animatedProgress: Double = 0
        
        init(
            progress: Double,
            total: Double = 1.0,
            accentColor: Color = .accentColor,
            height: CGFloat = 8,
            cornerRadius: CGFloat = 4
        ) {
            self.progress = progress
            self.total = total
            self.accentColor = accentColor
            self.height = height
            self.cornerRadius = cornerRadius
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: height)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor,
                                    accentColor.opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * animatedProgress, height: height)
                        .animation(.easeInOut(duration: 0.8), value: animatedProgress)
                }
            }
            .frame(height: height)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animatedProgress = progress / total
                }
            }
            .onChange(of: progress) { _, newValue in
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedProgress = newValue / total
                }
            }
        }
    }
    
    // MARK: - State-Based Card
    struct StateBasedCard<Content: View>: View {
        let content: Content
        let state: CardState
        let accentColor: Color
        let onTap: (() -> Void)?
        
        @State private var isPressed = false
        
        enum CardState {
            case available
            case completed
            case locked
            case loading
            case disabled
        }
        
        init(
            state: CardState = .available,
            accentColor: Color = .accentColor,
            onTap: (() -> Void)? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.state = state
            self.accentColor = accentColor
            self.onTap = onTap
            self.content = content()
        }
        
        var body: some View {
            Button(action: {
                guard state == StateBasedCard<Content>.CardState.available || state == StateBasedCard<Content>.CardState.completed else { return }
                
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
                    onTap?()
                }
            }) {
                ZStack {
                    // Card background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(cardBackgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(cardBorderColor, lineWidth: cardBorderWidth)
                        )
                        .shadow(
                            color: shadowColor,
                            radius: shadowRadius,
                            x: 0,
                            y: shadowOffset
                        )
                    
                    // Content
                    content
                        .opacity(contentOpacity)
                    
                    // State overlay
                    if state == .completed {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .background(
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 24, height: 24)
                                    )
                            }
                            Spacer()
                        }
                        .padding(12)
                    }
                    
                    if state == .locked {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .background(
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 24, height: 24)
                                    )
                            }
                            Spacer()
                        }
                        .padding(12)
                    }
                    
                    if state == .loading {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(accentColor)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
.buttonStyle(HapticPlainButtonStyle())
            .disabled(state != .available && state != .completed)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        
        private var cardBackgroundColor: Color {
            switch state {
            case .available:
                return Color(.systemBackground)
            case .completed:
                return accentColor.opacity(0.1)
            case .locked:
                return Color.gray.opacity(0.1)
            case .loading:
                return Color(.systemBackground)
            case .disabled:
                return Color.gray.opacity(0.05)
            }
        }
        
        private var cardBorderColor: Color {
            switch state {
            case .available:
                return accentColor.opacity(0.3)
            case .completed:
                return accentColor
            case .locked:
                return Color.gray.opacity(0.3)
            case .loading:
                return accentColor.opacity(0.3)
            case .disabled:
                return Color.gray.opacity(0.2)
            }
        }
        
        private var cardBorderWidth: CGFloat {
            switch state {
            case .available, .loading:
                return 1
            case .completed:
                return 2
            case .locked, .disabled:
                return 1
            }
        }
        
        private var shadowColor: Color {
            switch state {
            case .available, .loading:
                return accentColor.opacity(0.1)
            case .completed:
                return accentColor.opacity(0.2)
            case .locked, .disabled:
                return Color.gray.opacity(0.1)
            }
        }
        
        private var shadowRadius: CGFloat {
            switch state {
            case .available, .loading:
                return 4
            case .completed:
                return 8
            case .locked, .disabled:
                return 2
            }
        }
        
        private var shadowOffset: CGFloat {
            switch state {
            case .available, .loading:
                return 2
            case .completed:
                return 4
            case .locked, .disabled:
                return 1
            }
        }
        
        private var contentOpacity: Double {
            switch state {
            case .available, .completed:
                return 1.0
            case .locked, .disabled:
                return 0.6
            case .loading:
                return 0.8
            }
        }
    }
    
    // MARK: - Animated Counter
    struct AnimatedCounter: View {
        let value: Int
        let duration: Double
        let font: Font
        let color: Color
        
        @State private var displayValue: Int = 0
        
        init(
            value: Int,
            duration: Double = 1.0,
            font: Font = .title,
            color: Color = .primary
        ) {
            self.value = value
            self.duration = duration
            self.font = font
            self.color = color
        }
        
        var body: some View {
            Text("\(displayValue)")
                .font(font)
                .foregroundColor(color)
                .onAppear {
                    animateToValue()
                }
                .onChange(of: value) { _, newValue in
                    animateToValue()
                }
        }
        
        private func animateToValue() {
            let steps = 20
            let stepDuration = duration / Double(steps)
            let stepValue = value / steps
            
            for i in 0...steps {
                DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                    withAnimation(.easeOut(duration: stepDuration)) {
                        displayValue = min(stepValue * i, value)
                    }
                }
            }
        }
    }
    
    // MARK: - Pulsing Badge
    struct PulsingBadge: View {
        let text: String
        let color: Color
        let size: CGFloat
        
        @State private var isPulsing = false
        
        init(text: String, color: Color = .red, size: CGFloat = 20) {
            self.text = text
            self.color = color
            self.size = size
        }
        
        var body: some View {
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(color)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .opacity(isPulsing ? 0.7 : 1.0)
                )
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isPulsing = true
                    }
                }
        }
    }
    
    // MARK: - State Transition View
    struct StateTransitionView<Content: View>: View {
        let content: Content
        let isVisible: Bool
        let transition: AnyTransition
        
        init(
            isVisible: Bool,
            transition: AnyTransition = .opacity.combined(with: .scale),
            @ViewBuilder content: () -> Content
        ) {
            self.isVisible = isVisible
            self.transition = transition
            self.content = content()
        }
        
        var body: some View {
            if isVisible {
                content
                    .transition(transition)
            }
        }
    }
}

// MARK: - Enhanced Progress Ring
struct EnhancedProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let accentColor: Color
    let backgroundColor: Color
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 100,
        accentColor: Color = .accentColor,
        backgroundColor: Color = Color.gray.opacity(0.2)
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
            
            // Center text
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.2, weight: .bold))
                .foregroundColor(accentColor)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Interactive Card with State
struct InteractiveCard<Content: View>: View {
    let content: Content
    let state: StateBasedUI.StateBasedCard<Content>.CardState
    let accentColor: Color
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    @State private var rippleOffset = CGSize.zero
    @State private var rippleOpacity = 0.0
    
    init(
        state: StateBasedUI.StateBasedCard<Content>.CardState = .available,
        accentColor: Color = .accentColor,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.state = state
        self.accentColor = accentColor
        self.onTap = onTap
        self.content = content()
    }
    
    var body: some View {
        Button(action: handleTap) {
            ZStack {
                StateBasedUI.StateBasedCard(
                    state: state,
                    accentColor: accentColor,
                    onTap: nil
                ) {
                    content
                }
                
                // Ripple effect
                if rippleOpacity > 0 {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    accentColor.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .offset(rippleOffset)
                        .opacity(rippleOpacity)
                        .animation(.easeOut(duration: 0.6), value: rippleOpacity)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    private func handleTap() {
        guard state == .available || state == .completed else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        // Visual feedback
        withAnimation(.easeOut(duration: 0.1)) {
            isPressed = true
            rippleOffset = .zero
            rippleOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isPressed = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.3)) {
                rippleOpacity = 0.0
            }
        }
        
        onTap?()
    }
}
