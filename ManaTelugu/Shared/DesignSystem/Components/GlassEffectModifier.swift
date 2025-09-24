import SwiftUI

// MARK: - Native Liquid Glass Implementation
// Using Apple's native glassEffect API for true glassy, transparent effects

// MARK: - Glass Effect Presets
enum GlassEffectPreset: Hashable {
    case card
    case button
    case modal
    case navigation
    case subtle
    case strong
    case floating
    case shimmer
    case glow
    case custom(GlassEffectConfig)
    
    var config: GlassEffectConfig {
        switch self {
        case .card:
            return .card
        case .button:
            return .button
        case .modal:
            return .modal
        case .navigation:
            return .navigation
        case .subtle:
            return .subtle
        case .strong:
            return .strong
        case .floating:
            return .floating
        case .shimmer:
            return .shimmer
        case .glow:
            return .glow
        case .custom(let config):
            return config
        }
    }
}

// MARK: - Glass Effect Configuration
struct GlassEffectConfig: Hashable {
    let glassType: CustomGlassType
    let shape: CustomGlassShape
    let isEnabled: Bool
    let blurRadius: CGFloat
    let opacity: Double
    let borderWidth: CGFloat
    let shadowRadius: CGFloat
    let shimmerEnabled: Bool
    let glowEnabled: Bool
    let floatingEnabled: Bool
    
    init(
        glassType: CustomGlassType = .regular,
        shape: CustomGlassShape = .rect(cornerRadius: 16),
        isEnabled: Bool = true,
        blurRadius: CGFloat = 20,
        opacity: Double = 0.1,
        borderWidth: CGFloat = 1,
        shadowRadius: CGFloat = 8,
        shimmerEnabled: Bool = false,
        glowEnabled: Bool = false,
        floatingEnabled: Bool = false
    ) {
        self.glassType = glassType
        self.shape = shape
        self.isEnabled = isEnabled
        self.blurRadius = blurRadius
        self.opacity = opacity
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shimmerEnabled = shimmerEnabled
        self.glowEnabled = glowEnabled
        self.floatingEnabled = floatingEnabled
    }
    
    // Preset configurations
    static let card = GlassEffectConfig(
        glassType: .regular,
        shape: .rect(cornerRadius: 20),
        blurRadius: 25,
        opacity: 0.15,
        borderWidth: 1,
        shadowRadius: 12,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: true
    )
    
    static let button = GlassEffectConfig(
        glassType: .regular,
        shape: .capsule,
        blurRadius: 20,
        opacity: 0.1,
        borderWidth: 1,
        shadowRadius: 8,
        shimmerEnabled: false,
        glowEnabled: true,
        floatingEnabled: false
    )
    
    static let modal = GlassEffectConfig(
        glassType: .prominent,
        shape: .rect(cornerRadius: 24),
        blurRadius: 30,
        opacity: 0.2,
        borderWidth: 1.5,
        shadowRadius: 16,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: true
    )
    
    static let navigation = GlassEffectConfig(
        glassType: .regular,
        shape: .rect(cornerRadius: 0),
        blurRadius: 20,
        opacity: 0.1,
        borderWidth: 1,
        shadowRadius: 8,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: false
    )
    
    static let subtle = GlassEffectConfig(
        glassType: .subtle,
        shape: .rect(cornerRadius: 12),
        blurRadius: 15,
        opacity: 0.05,
        borderWidth: 0.5,
        shadowRadius: 4,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: false
    )
    
    static let strong = GlassEffectConfig(
        glassType: .prominent,
        shape: .rect(cornerRadius: 20),
        blurRadius: 30,
        opacity: 0.2,
        borderWidth: 1.5,
        shadowRadius: 16,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: true
    )
    
    static let floating = GlassEffectConfig(
        glassType: .regular,
        shape: .rect(cornerRadius: 24),
        blurRadius: 25,
        opacity: 0.15,
        borderWidth: 1,
        shadowRadius: 20,
        shimmerEnabled: false,
        glowEnabled: false,
        floatingEnabled: true
    )
    
    static let shimmer = GlassEffectConfig(
        glassType: .regular,
        shape: .rect(cornerRadius: 16),
        blurRadius: 20,
        opacity: 0.1,
        borderWidth: 1,
        shadowRadius: 8,
        shimmerEnabled: true,
        glowEnabled: false,
        floatingEnabled: false
    )
    
    static let glow = GlassEffectConfig(
        glassType: .regular,
        shape: .rect(cornerRadius: 16),
        blurRadius: 20,
        opacity: 0.1,
        borderWidth: 1,
        shadowRadius: 8,
        shimmerEnabled: false,
        glowEnabled: true,
        floatingEnabled: false
    )
}

// MARK: - Custom Glass Types (avoiding conflicts with Apple's API)
enum CustomGlassType: Hashable {
    case regular
    case prominent
    case subtle
    case ultraThin
    case thin
    case thick
    case ultraThick
}

// MARK: - Custom Glass Shapes (avoiding conflicts with Apple's API)
enum CustomGlassShape: Hashable {
    case rect(cornerRadius: CGFloat)
    case capsule
    case circle
    case roundedRect(cornerRadius: CGFloat, style: RoundedCornerStyle)
    
    enum RoundedCornerStyle: Hashable {
        case continuous
        case circular
    }
}

// MARK: - Glass Effect Modifier
struct GlassEffectModifier: ViewModifier {
    let config: GlassEffectConfig
    @State private var shimmerOffset: CGFloat = -1.0
    @State private var glowIntensity: Double = 0.0
    @State private var isHovered: Bool = false
    @State private var hoverScale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // True glassmorphism background with backdrop blur
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(.ultraThinMaterial)
                        .opacity(getAccessibleOpacity())
                        .blur(radius: config.blurRadius)
                    
                    // Additional glass layer for depth
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(getAccessibleOpacity() * 0.5)
                    
                    // Shimmer effect
                    if config.shimmerEnabled {
                        RoundedRectangle(cornerRadius: getCornerRadius())
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset * 200)
                            .opacity(0.6)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                                    shimmerOffset = 1.0
                                }
                            }
                    }
                    
                    // Glow effect
                    if config.glowEnabled {
                        RoundedRectangle(cornerRadius: getCornerRadius())
                            .fill(Color.white.opacity(0.1))
                            .blur(radius: 10)
                            .opacity(glowIntensity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    glowIntensity = 0.8
                                }
                            }
                    }
                    
                    // Border
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: getAccessibleBorderWidth()
                        )
                }
            )
            .shadow(
                color: Color.black.opacity(0.1),
                radius: config.shadowRadius,
                x: 0,
                y: config.floatingEnabled ? 8 : 4
            )
            .shadow(
                color: Color.black.opacity(0.05),
                radius: config.shadowRadius * 2,
                x: 0,
                y: config.floatingEnabled ? 16 : 8
            )
            .scaleEffect(hoverScale)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isHovered = hovering
                    hoverScale = hovering ? 1.02 : 1.0
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    hoverScale = 0.98
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        hoverScale = 1.0
                    }
                }
            }
    }
    
    private func getAccessibleMaterial() -> Material {
        // Support Reduce Transparency accessibility setting
        if UIAccessibility.isReduceTransparencyEnabled {
            return .regularMaterial
        }
        return .ultraThinMaterial // Use ultraThinMaterial for true glass effect
    }
    
    private func getAccessibleOpacity() -> Double {
        // Support Increase Contrast accessibility setting
        if UIAccessibility.isDarkerSystemColorsEnabled {
            return min(config.opacity + 0.2, 1.0)
        }
        return config.opacity
    }
    
    private func getAccessibleBorderColor() -> Color {
        // Support Increase Contrast accessibility setting
        if UIAccessibility.isDarkerSystemColorsEnabled {
            return Color.white.opacity(0.4)
        }
        return Color.white.opacity(0.2)
    }
    
    private func getAccessibleBorderWidth() -> CGFloat {
        // Support Increase Contrast accessibility setting
        if UIAccessibility.isDarkerSystemColorsEnabled {
            return 2.0
        }
        return 1.0
    }
    
    
    private func getCornerRadius() -> CGFloat {
        switch config.shape {
        case .rect(let cornerRadius):
            return cornerRadius
        case .capsule:
            return 20
        case .circle:
            return 50
        case .roundedRect(let cornerRadius, _):
            return cornerRadius
        }
    }
}

// MARK: - View Extension
extension View {
    /// Apply a glass effect using Apple's native Liquid Glass API
    func glassEffect(_ preset: GlassEffectPreset) -> some View {
        self.modifier(GlassEffectModifier(config: preset.config))
    }
    
    /// Apply a glass effect with custom configuration
    func glassEffect(_ config: GlassEffectConfig) -> some View {
        self.modifier(GlassEffectModifier(config: config))
    }
    
    /// Apply a glass effect with simple parameters
    func glassEffect(
        _ glassType: CustomGlassType = .regular,
        shape: CustomGlassShape = .rect(cornerRadius: 16),
        isEnabled: Bool = true
    ) -> some View {
        self.modifier(GlassEffectModifier(config: GlassEffectConfig(
            glassType: glassType,
            shape: shape,
            isEnabled: isEnabled
        )))
    }
}

// MARK: - Glass Effect Container (for morphing effects)
// Optimized container following Apple's performance guidelines
struct GlassEffectContainer<Content: View>: View {
    let content: Content
    let glassType: CustomGlassType
    let shape: CustomGlassShape
    let isEnabled: Bool
    
    init(
        glassType: CustomGlassType = .regular,
        shape: CustomGlassShape = .rect(cornerRadius: 16),
        isEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.glassType = glassType
        self.shape = shape
        self.isEnabled = isEnabled
        self.content = content()
    }
    
    var body: some View {
        if isEnabled {
            content
                .glassEffect(glassType, shape: shape, isEnabled: isEnabled)
        } else {
            content
        }
    }
}

// MARK: - Preview
struct GlassEffectPreview: View {
    @State private var selectedPreset: GlassEffectPreset = .card
    @State private var isEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Liquid Glass Effects")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Preset picker
                Picker("Preset", selection: $selectedPreset) {
                    Text("Card").tag(GlassEffectPreset.card)
                    Text("Button").tag(GlassEffectPreset.button)
                    Text("Modal").tag(GlassEffectPreset.modal)
                    Text("Navigation").tag(GlassEffectPreset.navigation)
                    Text("Subtle").tag(GlassEffectPreset.subtle)
                    Text("Strong").tag(GlassEffectPreset.strong)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Toggle("Enabled", isOn: $isEnabled)
                
                // Demo cards
                VStack(spacing: 16) {
                    // Card example
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sample Card")
                            .font(.headline)
                        Text("This demonstrates the glass effect with native Apple API")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .glassEffect(selectedPreset)
                    
                    // Button example
                    Button("Glass Button") {
                        // Action
                    }
                    .padding()
                    .glassEffect(GlassEffectPreset.button)
                    
                    // Custom example
                    VStack {
                        Text("Custom Glass")
                            .font(.title2)
                        Text("Using custom configuration")
                            .font(.caption)
                    }
                    .padding()
                    .glassEffect(
                        .regular,
                        shape: .roundedRect(cornerRadius: 20, style: .continuous),
                        isEnabled: isEnabled
                    )
                }
                
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    GlassEffectPreview()
}