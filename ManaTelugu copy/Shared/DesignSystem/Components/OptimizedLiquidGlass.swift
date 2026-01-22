import SwiftUI

// MARK: - Performance-Optimized Liquid Glass System
struct OptimizedLiquidGlassView<Content: View>: View {
    let content: Content
    let intensity: Double
    let cornerRadius: CGFloat
    let padding: CGFloat
    let layer: LiquidGlassLayer
    @Environment(\.colorScheme) private var colorScheme
    
    // Performance optimizations
    @State private var isVisible = false
    @State private var animationPhase: CGFloat = 0
    
    init(
        layer: LiquidGlassLayer = .content,
        intensity: Double = 0.14,
        cornerRadius: CGFloat = 18,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.layer = layer
        self.content = content()
        self.intensity = intensity
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    // Optimized blur radius calculation
    private var blurRadius: CGFloat {
        switch layer {
        case .background: return 40  // Reduced from 60
        case .content: return 20     // Reduced from 28
        case .navigation: return 25  // Reduced from 38
        case .modal: return 30       // Reduced from 45
        }
    }
    
    // Optimized material opacity
    private var materialOpacity: Double {
        let baseOpacity = switch layer {
        case .background: 0.12
        case .content: 0.65
        case .navigation: 0.75
        case .modal: 0.85
        }
        return baseOpacity + intensity * 0.15
    }
    
    // Optimized highlight opacity
    private var highlightOpacity: Double {
        colorScheme == .dark ? 0.03 : 0.12
    }
    
    // Optimized shadow properties
    private var shadowRadius: CGFloat {
        switch layer {
        case .background: return 8
        case .content: return 12
        case .navigation: return 16
        case .modal: return 20
        }
    }
    
    private var shadowOpacity: Double {
        switch layer {
        case .background: return 0.06
        case .content: return 0.12
        case .navigation: return 0.16
        case .modal: return 0.20
        }
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                // Simplified glass effect with fewer layers
                ZStack {
                    // Primary glass layer
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(materialOpacity)
                        .blur(radius: blurRadius * 0.02) // Reduced blur multiplier
                    
                    // Single highlight layer
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(highlightOpacity),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .blur(radius: 0.5) // Reduced blur
                }
            )
            .background(
                // Simplified background blur
                Color.clear
                    .background(.thinMaterial)
                    .blur(radius: blurRadius * 0.8) // Reduced blur multiplier
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                // Simplified edge
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0, y: 4
            )
            .opacity(isVisible ? 1.0 : 0.0)
            .scaleEffect(isVisible ? 1.0 : 0.95)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - Optimized Unified Liquid Glass Card
struct OptimizedUnifiedLiquidGlassCard<Content: View>: View {
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
        OptimizedLiquidGlassView(
            layer: layer,
            intensity: intensity,
            cornerRadius: cornerRadius,
            padding: padding
        ) {
            content
        }
    }
}

// MARK: - Optimized Global Animated Background
struct OptimizedGlobalAnimatedBackground: View {
    @State private var animationOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var isVisible = false
    
    let colors: [Color]
    let speed: Double
    
    init(
        colors: [Color] = [
            Color.blue.opacity(0.08),    // Reduced opacity
            Color.purple.opacity(0.08),
            Color.pink.opacity(0.08),
            Color.orange.opacity(0.08)
        ],
        speed: Double = 40.0  // Slower animation
    ) {
        self.colors = colors
        self.speed = speed
    }
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Single animated overlay (reduced from multiple)
            LinearGradient(
                colors: colors.map { $0.opacity(0.1) },
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            .offset(x: animationOffset, y: animationOffset * 0.2)
            .rotationEffect(.degrees(rotationAngle))
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
            
            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                animationOffset = 100  // Reduced from 150
                rotationAngle = 360
            }
        }
    }
}

// MARK: - Performance-Optimized Background Extension
extension View {
    @ViewBuilder
    func optimizedLiquidGlassBackground() -> some View {
        self.background(
            OptimizedGlobalAnimatedBackground()
        )
    }
}

// MARK: - Lazy Loading Liquid Glass Card
struct LazyLiquidGlassCard<Content: View>: View {
    let content: Content
    let layer: LiquidGlassLayer
    let intensity: Double
    let cornerRadius: CGFloat
    let padding: CGFloat
    let isInteractive: Bool
    
    @State private var isInView = false
    
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
        Group {
            if isInView {
                OptimizedUnifiedLiquidGlassCard(
                    layer: layer,
                    intensity: intensity,
                    cornerRadius: cornerRadius,
                    padding: padding,
                    isInteractive: isInteractive
                ) {
                    content
                }
            } else {
                // Placeholder with basic styling
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.3)
                    .overlay {
                        content
                            .padding(padding)
                    }
            }
        }
        .onAppear {
            // Delay the liquid glass effect until the view is visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isInView = true
                }
            }
        }
    }
}

// MARK: - Memory-Efficient Particle System
struct OptimizedParticleField: View {
    @State private var particles: [OptimizedParticle] = []
    let particleCount: Int
    let colors: [Color]
    
    init(particleCount: Int = 10, colors: [Color] = [.blue, .purple, .pink, .orange]) {
        self.particleCount = particleCount
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(particle.color.opacity(0.2))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .blur(radius: particle.blur)
            }
        }
        .onAppear {
            generateParticles()
            animateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<particleCount).map { _ in
            OptimizedParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 15...40),  // Reduced size range
                color: colors.randomElement() ?? .blue,
                blur: CGFloat.random(in: 1...4)     // Reduced blur range
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
}

// MARK: - Optimized Particle Model
struct OptimizedParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let blur: CGFloat
}
