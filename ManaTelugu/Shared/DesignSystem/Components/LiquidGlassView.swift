import SwiftUI

// MARK: - Liquid Glass View (Legacy - Use glassEffect modifier instead)
struct LiquidGlassView<Content: View>: View {
    let content: Content
    let layer: LiquidGlassLayer
    let intensity: Double
    let cornerRadius: CGFloat
    let padding: CGFloat
    let isInteractive: Bool
    
    init(
        layer: LiquidGlassLayer = .content,
        intensity: Double = 0.15,
        cornerRadius: CGFloat = 16,
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
    
    private var glassConfig: GlassEffectConfig {
        switch layer {
        case .background:
            return GlassEffectConfig(
                glassType: .subtle,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .content:
            return GlassEffectConfig(
                glassType: .regular,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .navigation:
            return GlassEffectConfig(
                glassType: .regular,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .modal:
            return GlassEffectConfig(
                glassType: .prominent,
                shape: .rect(cornerRadius: cornerRadius)
            )
        }
    }
    
    var body: some View {
        content
            .padding(padding)
            .glassEffect(glassConfig)
    }
}

// MARK: - Unified Liquid Glass Card (Legacy - Use glassEffect modifier instead)
struct UnifiedLiquidGlassCard<Content: View>: View {
    let content: Content
    let layer: LiquidGlassLayer
    let intensity: Double
    let cornerRadius: CGFloat
    let padding: CGFloat
    let isInteractive: Bool
    
    init(
        layer: LiquidGlassLayer = .content,
        intensity: Double = 0.15,
        cornerRadius: CGFloat = 16,
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
    
    private var glassConfig: GlassEffectConfig {
        switch layer {
        case .background:
            return GlassEffectConfig(
                glassType: .subtle,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .content:
            return GlassEffectConfig(
                glassType: .regular,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .navigation:
            return GlassEffectConfig(
                glassType: .regular,
                shape: .rect(cornerRadius: cornerRadius)
            )
        case .modal:
            return GlassEffectConfig(
                glassType: .prominent,
                shape: .rect(cornerRadius: cornerRadius)
            )
        }
    }
    
    var body: some View {
        content
            .padding(padding)
            .glassEffect(glassConfig)
    }
}

// MARK: - Interactive Liquid Glass Button
struct InteractiveLiquidGlassButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    let isLoading: Bool
    let isEnabled: Bool
    
    init(
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            content
        }
        .disabled(!isEnabled || isLoading)
        .glassEffect(GlassEffectPreset.button)
    }
}

// MARK: - Liquid Glass Layer
enum LiquidGlassLayer {
    case background
    case content
    case navigation
    case modal
}

// MARK: - Liquid Glass Section Header
struct LiquidGlassSectionHeader: View {
    let title: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .glassEffect(GlassEffectPreset.card)
    }
}

// MARK: - Preview
struct LiquidGlassView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            LiquidGlassView(
                layer: .content,
                intensity: 0.2,
                cornerRadius: 20
            ) {
                VStack {
                    Text("Sample Content")
                        .font(.headline)
                    Text("This is a liquid glass view")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            UnifiedLiquidGlassCard(
                layer: .content,
                intensity: 0.15,
                cornerRadius: 16
            ) {
                VStack {
                    Text("Sample Card")
                        .font(.headline)
                    Text("This is a unified liquid glass card")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            InteractiveLiquidGlassButton(
                isLoading: false,
                isEnabled: true,
                action: { print("Button tapped") }
            ) {
                Text("Interactive Button")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}