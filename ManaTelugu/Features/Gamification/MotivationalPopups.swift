import SwiftUI

// MARK: - Motivational Popup Manager
class MotivationalPopupManager: ObservableObject {
    @Published var showingXP = false
    @Published var showingBadge = false
    @Published var showingStreak = false
    @Published var showingLevelUp = false
    
    @Published var xpPopup: XPPopupData?
    @Published var badgePopup: BadgePopupData?
    @Published var streakPopup: StreakPopupData?
    @Published var levelUpPopup: LevelUpPopupData?
    
    func showXPGain(_ amount: Int, type: XPEventType, description: String) {
        xpPopup = XPPopupData(amount: amount, type: type, description: description)
        showingXP = true
    }
    
    func showBadgeEarned(_ badge: GamificationBadge) {
        badgePopup = BadgePopupData(badge: badge)
        showingBadge = true
    }
    
    func showStreakMilestone(_ milestone: StreakMilestone) {
        streakPopup = StreakPopupData(milestone: milestone)
        showingStreak = true
    }
    
    func showLevelUp(_ newLevel: XPLevel) {
        levelUpPopup = LevelUpPopupData(newLevel: newLevel)
        showingLevelUp = true
    }
}

// MARK: - Popup Data Models
struct XPPopupData {
    let amount: Int
    let type: XPEventType
    let description: String
}

struct BadgePopupData {
    let badge: GamificationBadge
}

struct StreakPopupData {
    let milestone: StreakMilestone
}

struct LevelUpPopupData {
    let newLevel: XPLevel
}

// MARK: - Motivational Popup View
struct MotivationalPopupView: View {
    @ObservedObject var manager: MotivationalPopupManager
    @State private var animate = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            // Background overlay
            if manager.showingXP || manager.showingBadge || manager.showingStreak || manager.showingLevelUp {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissAll()
                    }
            }
            
            // XP Popup
            if let xpData = manager.xpPopup, manager.showingXP {
                XPPopupView(data: xpData, isPresented: $manager.showingXP)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: animate)
            }
            
            // Badge Popup
            if let badgeData = manager.badgePopup, manager.showingBadge {
                BadgePopupView(data: badgeData, isPresented: $manager.showingBadge)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: animate)
            }
            
            // Streak Popup
            if let streakData = manager.streakPopup, manager.showingStreak {
                StreakPopupView(data: streakData, isPresented: $manager.showingStreak)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: animate)
            }
            
            // Level Up Popup
            if let levelUpData = manager.levelUpPopup, manager.showingLevelUp {
                LevelUpPopupView(data: levelUpData, isPresented: $manager.showingLevelUp)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: animate)
            }
            
            // Confetti Effect
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onChange(of: manager.showingXP) {
            if manager.showingXP { triggerAnimation() }
        }
        .onChange(of: manager.showingBadge) {
            if manager.showingBadge { triggerAnimation() }
        }
        .onChange(of: manager.showingStreak) {
            if manager.showingStreak { triggerAnimation() }
        }
        .onChange(of: manager.showingLevelUp) {
            if manager.showingLevelUp { triggerAnimation() }
        }
    }
    
    private func triggerAnimation() {
        animate = true
        showConfetti = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showConfetti = false
        }
    }
    
    private func dismissAll() {
        withAnimation(.easeInOut(duration: 0.3)) {
            manager.showingXP = false
            manager.showingBadge = false
            manager.showingStreak = false
            manager.showingLevelUp = false
            animate = false
        }
    }
}

// MARK: - XP Popup View
struct XPPopupView: View {
    let data: XPPopupData
    @Binding var isPresented: Bool
    @State private var animateNumber = false
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(data.type.color))
                    .frame(width: 80, height: 80)
                    .shadow(color: Color(data.type.color).opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: data.type.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateNumber ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6).repeatCount(2, autoreverses: true), value: animateNumber)
            
            // XP Amount
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(MTColors.funYellow)
                
                Text("+\(data.amount)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(MTColors.funYellow)
                    .scaleEffect(animateNumber ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateNumber)
            }
            
            // Description
            Text(data.description)
                .font(MTTypography.heading())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            // Action Button
            Button("Awesome!") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }
            .font(MTTypography.body())
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(MTColors.primary)
            )
            }
        }
        .padding(MTSpacing.xLarge)
        .background(
            LiquidGlassView(
                intensity: 0.15,
                cornerRadius: 24,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.clear)
            }
        )
        .padding(.horizontal, MTSpacing.large)
        .onAppear {
            animateNumber = true
        }
    }
}

// MARK: - Badge Popup View
struct BadgePopupView: View {
    let data: BadgePopupData
    @Binding var isPresented: Bool
    @State private var animateBadge = false
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.medium) {
            // Badge Icon
            ZStack {
                Circle()
                    .fill(Color(data.badge.color))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color(data.badge.color).opacity(0.3), radius: 12, x: 0, y: 6)
                
                Image(systemName: data.badge.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateBadge ? 1.1 : 1.0)
            .rotationEffect(.degrees(animateBadge ? 5 : 0))
            .animation(.spring(response: 0.4, dampingFraction: 0.6).repeatCount(3, autoreverses: true), value: animateBadge)
            
            // Badge Name
            Text(data.badge.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(data.badge.teluguName)
                .font(MTTypography.heading())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(data.badge.description)
                .font(MTTypography.body())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // XP Reward
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(MTColors.funYellow)
                
                Text("+\(data.badge.xpReward) XP")
                    .font(MTTypography.heading())
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.funYellow)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(MTColors.funYellow.opacity(0.1))
            )
            
            // Action Button
            Button("Collect Badge!") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }
            .font(MTTypography.body())
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(data.badge.color))
            )
            }
        }
        .padding(MTSpacing.xLarge)
        .background(
            LiquidGlassView(
                intensity: 0.15,
                cornerRadius: 24,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.clear)
            }
        )
        .padding(.horizontal, MTSpacing.large)
        .onAppear {
            animateBadge = true
        }
    }
}

// MARK: - Streak Popup View
struct StreakPopupView: View {
    let data: StreakPopupData
    @Binding var isPresented: Bool
    @State private var animateFlame = false
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.medium) {
            // Flame Icon
            ZStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 100, height: 100)
                    .shadow(color: .orange.opacity(0.3), radius: 12, x: 0, y: 6)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(animateFlame ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: animateFlame)
            }
            
            // Streak Info
            Text("\(data.milestone.days) Day Streak!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(data.milestone.teluguName)
                .font(MTTypography.heading())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(data.milestone.description)
                .font(MTTypography.body())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // XP Bonus
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(MTColors.funYellow)
                
                Text("+\(data.milestone.xpBonus) XP Bonus")
                    .font(MTTypography.heading())
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.funYellow)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(MTColors.funYellow.opacity(0.1))
            )
            
            // Action Button
            Button("Keep Going!") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }
            .font(MTTypography.body())
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.orange)
            )
            }
        }
        .padding(MTSpacing.xLarge)
        .background(
            LiquidGlassView(
                intensity: 0.15,
                cornerRadius: 24,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.clear)
            }
        )
        .padding(.horizontal, MTSpacing.large)
        .onAppear {
            animateFlame = true
        }
    }
}

// MARK: - Level Up Popup View
struct LevelUpPopupView: View {
    let data: LevelUpPopupData
    @Binding var isPresented: Bool
    @State private var animateLevel = false
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.medium) {
            // Level Icon
            ZStack {
                Circle()
                    .fill(Color(data.newLevel.color))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color(data.newLevel.color).opacity(0.3), radius: 12, x: 0, y: 6)
                
                Text("\(data.newLevel.level)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateLevel ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6).repeatCount(2, autoreverses: true), value: animateLevel)
            }
            
            // Level Up Text
            Text("Level Up!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(data.newLevel.teluguName)
                .font(MTTypography.heading())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(data.newLevel.description)
                .font(MTTypography.body())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Action Button
            Button("Amazing!") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }
            .font(MTTypography.body())
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(data.newLevel.color))
            )
            }
        }
        .padding(MTSpacing.xLarge)
        .background(
            LiquidGlassView(
                intensity: 0.15,
                cornerRadius: 24,
                padding: 0
            ) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.clear)
            }
        )
        .padding(.horizontal, MTSpacing.large)
        .onAppear {
            animateLevel = true
        }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(index: index, animate: $animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    @Binding var animate: Bool
    
    private let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(animate ? 360 : 0))
            .offset(
                x: animate ? CGFloat.random(in: -200...200) : 0,
                y: animate ? CGFloat.random(in: -300...300) : 0
            )
            .opacity(animate ? 0 : 1)
            .animation(
                .easeOut(duration: 2.0)
                .delay(Double(index) * 0.02),
                value: animate
            )
    }
}

#Preview {
    MotivationalPopupView(manager: MotivationalPopupManager())
}
