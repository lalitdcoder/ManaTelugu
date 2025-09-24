import SwiftUI

struct AboutUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [RefinedColors.background, RefinedColors.secondaryBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                EnhancedScrollView {
                    VStack(spacing: 24) {
                        // Header
                        LiquidGlassHeader(
                            title: "About ManaTelugu",
                            subtitle: "Making Telugu learning fun and accessible",
                            iconName: "heart.fill",
                            iconColor: RefinedColors.softGreen,
                            layer: .content
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Mission Section
                        VStack(alignment: .leading, spacing: 16) {
                            LiquidGlassSectionHeader(
                                title: "Our Mission",
                                iconName: "target",
                                iconColor: RefinedColors.warmYellow
                            )
                            
                            Text("At ManaTelugu, we believe that learning Telugu should be fun, engaging, and accessible to everyone. Our mission is to preserve and promote the beautiful Telugu language through innovative technology and interactive learning experiences.")
                                .font(EnhancedTypography.bodyText)
                                .foregroundColor(RefinedColors.charcoal)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 20)
                        
                        // Features Section
                        VStack(alignment: .leading, spacing: 16) {
                            LiquidGlassSectionHeader(
                                title: "What We Offer",
                                iconName: "star.fill",
                                iconColor: MTColors.funPurple
                            )
                            
                            VStack(spacing: 12) {
                                FeatureRow(
                                    icon: "graduationcap.fill",
                                    title: "Interactive Lessons",
                                    description: "Step-by-step learning with gamified content"
                                )
                                
                                FeatureRow(
                                    icon: "book.fill",
                                    title: "Cultural Stories",
                                    description: "Traditional Telugu stories with modern presentation"
                                )
                                
                                FeatureRow(
                                    icon: "gamecontroller.fill",
                                    title: "Educational Games",
                                    description: "Fun games that reinforce learning"
                                )
                                
                                FeatureRow(
                                    icon: "chart.bar.fill",
                                    title: "Progress Tracking",
                                    description: "Monitor your learning journey with detailed analytics"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Team Section
                        VStack(alignment: .leading, spacing: 16) {
                            LiquidGlassSectionHeader(
                                title: "Our Team",
                                iconName: "person.3.fill",
                                iconColor: MTColors.funBlue
                            )
                            
                            Text("We're a passionate team of educators, developers, and Telugu language enthusiasts working together to create the best possible learning experience.")
                                .font(EnhancedTypography.bodyText)
                                .foregroundColor(RefinedColors.charcoal)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 20)
                        
                        // App Info Section
                        VStack(alignment: .leading, spacing: 16) {
                            LiquidGlassSectionHeader(
                                title: "App Information",
                                iconName: "info.circle.fill",
                                iconColor: RefinedColors.mediumGray
                            )
                            
                            VStack(spacing: 12) {
                                InfoRow(title: "Version", value: "1.0.0")
                                InfoRow(title: "Build", value: "2024.1")
                                InfoRow(title: "Platform", value: "iOS 16.0+")
                                InfoRow(title: "Language", value: "English / తెలుగు")
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Footer
                        VStack(spacing: 12) {
                            Text("Made with ❤️ for Telugu learners worldwide")
                                .font(EnhancedTypography.caption)
                                .foregroundColor(RefinedColors.mediumGray)
                                .multilineTextAlignment(.center)
                            
                            Text("© 2024 ManaTelugu. All rights reserved.")
                                .font(.caption2)
                                .foregroundColor(RefinedColors.mediumGray.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 140) // Prevent overlap with tab bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(RefinedColors.warmYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EnhancedTypography.cardTitle)
                    .foregroundColor(RefinedColors.charcoal)
                
                Text(description)
                    .font(EnhancedTypography.caption)
                    .foregroundColor(RefinedColors.mediumGray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            UnifiedLiquidGlassCard(
                layer: .content,
                intensity: 0.1,
                cornerRadius: 12,
                padding: 0,
                isInteractive: false
            ) {
                Color.clear
            }
        )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(EnhancedTypography.caption)
                .foregroundColor(RefinedColors.mediumGray)
            
            Spacer()
            
            Text(value)
                .font(EnhancedTypography.bodyText)
                .foregroundColor(RefinedColors.charcoal)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

#Preview {
    AboutUsView()
}
