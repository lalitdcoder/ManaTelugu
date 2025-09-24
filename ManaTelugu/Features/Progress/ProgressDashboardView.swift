import SwiftUI

// MARK: - Professional Progress Dashboard View
// Clean, professional layout with proper progress tracking

struct ProfessionalProgressDashboardView: View {
    @EnvironmentObject var session: AppSession
    @State private var weeklyData: [ProgressDataPoint] = []
    
    struct ProgressDataPoint: Identifiable {
        let id = UUID()
        let day: String
        let minutes: Int
        let accuracy: Double
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    LazyVStack(spacing: ProfessionalSpacing.large.value) {
                        // Hero Header
                        ProfessionalCard(type: .hero) {
                            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                                ProfessionalText(
                                    "Your Progress",
                                    style: .heroTitle,
                                    color: .textPrimary
                                )
                                
                                ProfessionalText(
                                    "Track your learning journey and achievements",
                                    style: .bodyText,
                                    color: .textSecondary
                                )
                            }
                        }
                        .padding(.top, ProfessionalSpacing.extraLarge.value)
                        
                        // Stats Overview
                        statsOverviewSection
                        
                        // Weekly Progress Chart
                        weeklyProgressSection
                        
                        // Badges Section
                        badgesSection
                        
                        // Stickers Section
                        stickersSection
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 120)
                    }
                    .padding(.horizontal, ProfessionalSpacing.medium.value)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadWeeklyData()
        }
    }
    
    // MARK: - Stats Overview Section
    private var statsOverviewSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Overview",
                subtitle: "Your learning statistics"
            )
            
            HStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalStatCard(
                    icon: "star.fill",
                    value: "\(session.gamificationService.gamificationState.totalXP)",
                    label: "Total XP",
                    color: .professionalBlue
                )
                
                ProfessionalStatCard(
                    icon: "trophy.fill",
                    value: "\(session.gamificationService.gamificationState.currentLevel.level)",
                    label: "Level",
                    color: .professionalOrange
                )
                
                ProfessionalStatCard(
                    icon: "flame.fill",
                    value: "\(session.gamificationService.gamificationState.streakCount)",
                    label: "Streak",
                    color: .professionalGreen
                )
            }
        }
    }
    
    // MARK: - Weekly Progress Section
    private var weeklyProgressSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "This Week",
                subtitle: "Your daily learning progress"
            )
            
            ProfessionalCard(type: .primary) {
                VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                    ProfessionalText(
                        "Weekly Progress Chart",
                        style: .cardTitle,
                        color: .textPrimary
                    )
                    
                    // Placeholder for chart
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.professionalBlue.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            ProfessionalText(
                                "Chart would go here",
                                style: .bodyText,
                                color: .textSecondary,
                                alignment: .center
                            )
                        )
                }
            }
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Recent Badges",
                subtitle: "Your latest achievements"
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ProfessionalSpacing.medium.value) {
                    ForEach(session.gamificationService.gamificationState.badges.prefix(5)) { badge in
                        ProfessionalBadgeCard(badge: badge)
                    }
                }
                .padding(.horizontal, ProfessionalSpacing.medium.value)
            }
        }
    }
    
    // MARK: - Stickers Section
    private var stickersSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Stickers",
                subtitle: "Collect and use fun stickers"
            )
            
            ProfessionalCard(type: .primary) {
                VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                    ProfessionalText(
                        "Sticker Collection",
                        style: .cardTitle,
                        color: .textPrimary
                    )
                    
                    ProfessionalText(
                        "You have collected \(session.gamificationService.gamificationState.collectedStickerIDs.count) stickers!",
                        style: .bodyText,
                        color: .textSecondary
                    )
                }
            }
        }
    }
    
    // MARK: - Data Loading
    private func loadWeeklyData() {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let today = Date()
        
        weeklyData = (0..<7).map { i in
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let day = formatter.string(from: date)
            let minutes = i == 0 ? max(1, session.gamificationService.gamificationState.totalXP / 60) : max(0, (session.gamificationService.gamificationState.totalXP / 60) - i)
            return ProgressDataPoint(day: day, minutes: minutes, accuracy: 0.9)
        }.reversed()
    }
}

// MARK: - Professional Badge Card
struct ProfessionalBadgeCard: View {
    let badge: GamificationBadge
    
    var body: some View {
        ProfessionalCard(type: .compact, isInteractive: true) {
            VStack(spacing: ProfessionalSpacing.small.value) {
                Image(systemName: badge.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color(badge.color))
                
                ProfessionalText(
                    badge.name,
                    style: .caption,
                    color: .textPrimary,
                    alignment: .center
                )
            }
            .frame(width: 100)
        }
    }
}

// MARK: - Replace the original ProgressDashboardView
typealias ProgressDashboardView = ProfessionalProgressDashboardView
