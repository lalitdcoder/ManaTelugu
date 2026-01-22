import SwiftUI

// MARK: - Enhanced Loading States System
struct LoadingStates {
    
    // MARK: - Skeleton Loading Card with Enhanced Animation
    struct SkeletonCard: View {
        let width: CGFloat?
        let height: CGFloat
        let cornerRadius: CGFloat
        
        init(width: CGFloat? = nil, height: CGFloat = 100, cornerRadius: CGFloat = 12) {
            self.width = width
            self.height = height
            self.cornerRadius = cornerRadius
        }
        
        var body: some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.clear)
                .frame(width: width, height: height)
                .glassEffect(GlassEffectPreset.shimmer)
        }
    }
    
    // MARK: - Enhanced Loading Spinner
    struct LoadingSpinner: View {
        let message: String?
        let size: CGFloat
        let color: Color
        
        init(message: String? = nil, size: CGFloat = 20, color: Color = .accentColor) {
            self.message = message
            self.size = size
            self.color = color
        }
        
        var body: some View {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(color.opacity(0.2), lineWidth: 3)
                        .frame(width: size, height: size)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [color, color.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: size, height: size)
                        .rotationEffect(.degrees(0))
                        .animation(
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: true
                        )
                        .onAppear {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                                // This will trigger the rotation animation
                            }
                        }
                }
                
                if let message = message {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
    }
    
    // MARK: - Liquid Glass Loading Overlay
    struct LiquidGlassLoadingOverlay: View {
        let message: String?
        let isPresented: Bool
        let accentColor: Color
        
        init(message: String? = nil, isPresented: Bool, accentColor: Color = .accentColor) {
            self.message = message
            self.isPresented = isPresented
            self.accentColor = accentColor
        }
        
        var body: some View {
            if isPresented {
                ZStack {
                    // Blurred background
                    ModernDesignSystem.Colors.shadow.opacity(0.3)
                        .ignoresSafeArea()
                        .blur(radius: 2)
                    
                    // Liquid glass container
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            ModernDesignSystem.Colors.surface.opacity(0.2),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: ModernDesignSystem.Colors.shadow.opacity(0.1), radius: 20, x: 0, y: 10)
                        .frame(width: 200, height: 120)
                        .overlay(
                            VStack(spacing: 16) {
                                LoadingSpinner(message: message, size: 30, color: accentColor)
                            }
                        )
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    // MARK: - Card Loading State
    struct CardLoadingState: View {
        let isVisible: Bool
        let accentColor: Color
        
        init(isVisible: Bool, accentColor: Color = .accentColor) {
            self.isVisible = isVisible
            self.accentColor = accentColor
        }
        
        var body: some View {
            if isVisible {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(accentColor.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(accentColor.opacity(0.3), lineWidth: 1)
                        )
                    
                    VStack(spacing: 12) {
                        LoadingSpinner(size: 24, color: accentColor)
                        
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(accentColor)
                    }
                }
                .frame(height: 80)
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
    // MARK: - Progress Loading Bar
    struct ProgressLoadingBar: View {
        let progress: Double
        let isVisible: Bool
        let accentColor: Color
        
        init(progress: Double, isVisible: Bool, accentColor: Color = .accentColor) {
            self.progress = progress
            self.isVisible = isVisible
            self.accentColor = accentColor
        }
        
        var body: some View {
            if isVisible {
                VStack(spacing: 8) {
                    HStack {
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundColor(accentColor)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ModernDesignSystem.Colors.textTertiary.opacity(0.2))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [accentColor, accentColor.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progress, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

// MARK: - Shimmer Effect
extension View {
    func shimmer() -> some View {
        self
            .redacted(reason: .placeholder)
    }
}

// MARK: - Loading Button
struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(ModernDesignSystem.Colors.textPrimary)
                } else {
                    Text(title)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? ModernDesignSystem.Colors.textTertiary : ModernDesignSystem.Colors.accent)
            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}
