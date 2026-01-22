import SwiftUI

// MARK: - Enhanced Background System
struct EnhancedBackgrounds {
    
    // MARK: - Layered Blur Background
    struct LayeredBlurBackground<Content: View>: View {
        let content: Content
        let backgroundBlur: CGFloat
        let cardBlur: CGFloat
        
        init(
            backgroundBlur: CGFloat = 40,
            cardBlur: CGFloat = 20,
            @ViewBuilder content: () -> Content
        ) {
            self.backgroundBlur = backgroundBlur
            self.cardBlur = cardBlur
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                // Base background with high blur
                content
                    .blur(radius: backgroundBlur)
                    .scaleEffect(1.1) // Slight scale to prevent edge artifacts
                
                // Main content with lower blur
                content
                    .blur(radius: cardBlur)
            }
        }
    }
    
    // MARK: - Dynamic Animated Background
    struct DynamicAnimatedBackground<Content: View>: View {
        @State private var animationOffset: CGFloat = 0
        @State private var rotationAngle: Double = 0
        
        let colors: [Color]
        let speed: Double
        
        init(
            colors: [Color] = [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.3),
                Color.pink.opacity(0.3),
                Color.orange.opacity(0.3)
            ],
            speed: Double = 20.0
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
                
                // Animated gradient overlay
                LinearGradient(
                    colors: colors.map { $0.opacity(0.2) },
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
                .offset(x: animationOffset, y: animationOffset * 0.5)
                .rotationEffect(.degrees(rotationAngle))
                
                // Subtle noise texture
                // NoiseTextureOverlay() - removed for simplicity
                    .opacity(0.1)
            }
            .onAppear {
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    animationOffset = 100
                    rotationAngle = 360
                }
            }
        }
    }
    
    // MARK: - Glass Morphism Background
    struct GlassMorphismBackground<Content: View>: View {
        let content: Content
        let intensity: Double
        let cornerRadius: CGFloat
        
        init(
            intensity: Double = 0.2,
            cornerRadius: CGFloat = 20,
            @ViewBuilder content: () -> Content
        ) {
            self.intensity = intensity
            self.cornerRadius = cornerRadius
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                // Background blur
                content
                    .blur(radius: 30)
                    .scaleEffect(1.05)
                
                // Glass overlay
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            }
        }
    }
    
    // MARK: - Parallax Background
    struct ParallaxBackground<Content: View>: View {
        let content: Content
        let scrollOffset: CGFloat
        let parallaxFactor: CGFloat
        
        init(
            scrollOffset: CGFloat = 0,
            parallaxFactor: CGFloat = 0.5,
            @ViewBuilder content: () -> Content
        ) {
            self.scrollOffset = scrollOffset
            self.parallaxFactor = parallaxFactor
            self.content = content()
        }
        
        var body: some View {
            content
                .offset(y: scrollOffset * parallaxFactor)
                .scaleEffect(1.1)
                .clipped()
        }
    }
}

// MARK: - Noise Texture Overlay (moved to LiquidGlassView.swift to avoid duplication)

// MARK: - Enhanced Global Animated Background
struct EnhancedGlobalAnimatedBackground: View {
    @State private var animationOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    let colors: [Color]
    let speed: Double
    
    init(
        colors: [Color] = [
            Color.blue.opacity(0.1),
            Color.purple.opacity(0.1),
            Color.pink.opacity(0.1),
            Color.orange.opacity(0.1)
        ],
        speed: Double = 30.0
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
            
            // Animated gradient overlay 1
            LinearGradient(
                colors: colors.map { $0.opacity(0.15) },
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            .offset(x: animationOffset, y: animationOffset * 0.3)
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(scale)
            
            // Animated gradient overlay 2
            LinearGradient(
                colors: colors.map { $0.opacity(0.1) },
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
            .ignoresSafeArea()
            .offset(x: -animationOffset * 0.5, y: -animationOffset * 0.2)
            .rotationEffect(.degrees(-rotationAngle * 0.7))
            .scaleEffect(1.2 - scale * 0.2)
            
            // Subtle noise texture
            // NoiseTextureOverlay() - removed for simplicity
                .opacity(0.05)
        }
        .onAppear {
            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                animationOffset = 150
                rotationAngle = 360
            }
            
            withAnimation(.easeInOut(duration: speed * 0.5).repeatForever(autoreverses: true)) {
                scale = 1.1
            }
        }
    }
}

// MARK: - Floating Particles Background
struct FloatingParticlesBackground: View {
    @State private var particles: [Particle] = []
    let particleCount: Int
    let colors: [Color]
    
    init(particleCount: Int = 20, colors: [Color] = [.blue, .purple, .pink, .orange]) {
        self.particleCount = particleCount
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(particle.color.opacity(0.3))
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
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 20...80),
                color: colors.randomElement() ?? .blue,
                blur: CGFloat.random(in: 2...8)
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let blur: CGFloat
}

// MARK: - Enhanced Card Background
struct EnhancedCardBackground<Content: View>: View {
    let content: Content
    let intensity: Double
    let cornerRadius: CGFloat
    
    init(
        intensity: Double = 0.15,
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.intensity = intensity
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background blur
            content
                .blur(radius: blurRadius)
                .scaleEffect(1.02)
            
            // Glass overlay
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(materialOpacity)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(highlightOpacity),
                                    Color.white.opacity(highlightOpacity * 0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: Color.black.opacity(shadowOpacity),
                    radius: shadowRadius,
                    x: 0,
                    y: shadowOffset
                )
        }
    }
    
    private var blurRadius: CGFloat {
        return 20
    }
    
    private var materialOpacity: Double {
        return 0.6 + intensity * 0.2
    }
    
    private var highlightOpacity: Double {
        0.2 + intensity * 0.1
    }
    
    private var shadowOpacity: Double {
        return 0.1
    }
    
    private var shadowRadius: CGFloat {
        return 15
    }
    
    private var shadowOffset: CGFloat {
        return 8
    }
}

// MARK: - Glass Layer Enum (moved to avoid duplication)
// This enum is now defined in LiquidGlassView.swift to avoid conflicts
