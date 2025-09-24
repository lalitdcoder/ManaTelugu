import SwiftUI

struct EnhancedProgressBar: View {
    @EnvironmentObject var session: AppSession
    
    private var safeProgress: Double {
        let gamificationState = session.gamificationService.gamificationState
        let progress = gamificationState.progressToNextLevel
        
        // Validate progress value to prevent NaN or infinite values
        if progress.isNaN || progress.isInfinite {
            return 0.0
        }
        
        // Clamp progress between 0 and 1
        return max(0.0, min(1.0, progress))
    }

    var body: some View {
        VStack(spacing: 24) {
            let gamificationState = session.gamificationService.gamificationState
            let currentLevel = gamificationState.currentLevel
            let nextLevel = gamificationState.nextLevel

            // Header with level info and enhanced styling
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Level \(currentLevel.level): \(currentLevel.name)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(RefinedColors.charcoal)
                    Text(currentLevel.teluguName)
                        .font(EnhancedTypography.caption)
                        .foregroundColor(RefinedColors.mediumGray)
                }
                Spacer()
                
                // Enhanced star icon with liquid glass effect
                ZStack {
                    // Outer glow layers
                    Circle()
                        .fill(RefinedColors.warmYellow.opacity(0.4))
                        .frame(width: 80, height: 80)
                        .blur(radius: 20)
                    
                    Circle()
                        .fill(RefinedColors.warmYellow.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .blur(radius: 15)
                    
                    // Liquid glass background
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.8)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            RefinedColors.warmYellow.opacity(0.6),
                                            RefinedColors.warmYellow.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                    
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(RefinedColors.warmYellow)
                }
            }

            // Enhanced progress bar with liquid glass effect
            VStack(spacing: 16) {
                HStack {
                    Text("Progress to Next Level")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(RefinedColors.mediumGray)
                    
                    Spacer()
                    
                    Text("\(Int(safeProgress * 100))%")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(RefinedColors.charcoal)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track with enhanced liquid glass effect
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .opacity(0.5)
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.4),
                                                Color.white.opacity(0.1)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .frame(height: 24)

                        // Progress fill with enhanced gradient and glow
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        RefinedColors.warmYellow,
                                        RefinedColors.softGreen,
                                        RefinedColors.warmYellow
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(safeProgress))
                            .animation(.easeInOut(duration: 1.5), value: safeProgress)
                        
                        // Animated shimmer effect
                        if safeProgress > 0 {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            Color.white.opacity(0.6),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(safeProgress))
                                .offset(x: -geometry.size.width * CGFloat(safeProgress))
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false), value: safeProgress)
                        }
                    }
                }
                .frame(height: 24)
            }
            
            // XP text with enhanced styling
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(RefinedColors.warmYellow)
                    
                    Text("\(gamificationState.totalXP) XP")
                        .font(EnhancedTypography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(RefinedColors.charcoal)
                }
                
                Spacer()
                
                if let nextLvl = nextLevel {
                    Text("Next: \(nextLvl.xpRequired) XP")
                        .font(EnhancedTypography.caption)
                        .foregroundColor(RefinedColors.mediumGray)
                }
            }
        }
        .padding(20)
    }
}
