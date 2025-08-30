import SwiftUI
import Charts

struct ProgressDashboardView: View {
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
            ScrollView {
            VStack(alignment: .leading, spacing: MTSpacing.large) {
                Text("Progress")
                    .font(MTTypography.title())
                    .foregroundColor(MTColors.text)
                    .padding(.horizontal)
                
                // Stats Overview
                StatsOverview()
                    .padding(.horizontal)
                
                // Weekly Progress Chart
                VStack(alignment: .leading, spacing: MTSpacing.small) {
                    Text("This Week")
                        .font(MTTypography.heading())
                        .foregroundColor(MTColors.text)
                    
                    // Simple bar chart representation (text-based since we don't have Chart framework fully set up)
                    ForEach(weeklyData) { dataPoint in
                        HStack {
                            Text(dataPoint.day)
                                .frame(width: 60, alignment: .leading)
                                .font(MTTypography.caption())
                                .foregroundColor(MTColors.text)
                            
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(MTColors.primary)
                                    .frame(width: CGFloat(dataPoint.minutes) * 5, height: 20)
                            }
                            .frame(height: 20)
                            
                            Text("\(dataPoint.minutes) min")
                                .font(MTTypography.caption())
                                .foregroundColor(MTColors.text)
                                .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
                .padding()
                .background(MTColors.surfaceAlt)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Badges Section
                BadgesSection()
                    .padding(.horizontal)
            }
            .padding(.vertical)
            }
        }
        .onAppear {
            loadWeeklyData()
        }
    }
    
    private func loadWeeklyData() {
        // Simple local estimate: 1 minute per 60 interactions (rough)
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let today = Date()
        weeklyData = (0..<7).map { i in
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let day = formatter.string(from: date)
            let minutes = i == 0 ? max(1, session.userProfile.totalXP / 60) : max(0, (session.userProfile.totalXP / 60) - i)
            return ProgressDataPoint(day: day, minutes: minutes, accuracy: 0.9)
        }.reversed()
    }
}

struct StatsOverview: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        VStack(spacing: MTSpacing.medium) {
            HStack(spacing: MTSpacing.large) {
                StatCard(title: "Streak", value: "\(session.userProfile.streakDays)", icon: "flame")
                StatCard(title: "Total XP", value: "\(session.userProfile.totalXP)", icon: "star")
            }
            
            HStack(spacing: MTSpacing.large) {
                StatCard(title: "Letters", value: "12/50", icon: "textformat.abc.dottedunderline")
                StatCard(title: "Words", value: "30/200", icon: "books.vertical")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: MTSpacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(MTColors.primary)
            
            Text(value)
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            Text(title)
                .font(MTTypography.caption())
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
    }
}

struct BadgesSection: View {
    @EnvironmentObject var session: AppSession
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Badges")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            Text("Earn badges by completing milestones")
                .font(MTTypography.caption())
                .foregroundColor(MTColors.text.opacity(0.7))
            
            DynamicBadgesGrid()
        }
    }
}

struct BadgeView: View {
    let name: String
    let isEarned: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isEarned ? MTColors.primary : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                if isEarned {
                    Image(systemName: "rosette")
                        .font(.title2)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            
            Text(name)
                .font(MTTypography.caption())
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.center)
        }
    }
}

struct DynamicBadgesGrid: View {
    @EnvironmentObject var session: AppSession
    @State private var badges: [Badge] = []
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: MTSpacing.medium) {
            ForEach(badges) { badge in
                let earned = isBadgeEarned(badge)
                BadgeView(name: badge.name, isEarned: earned)
            }
        }
        .onAppear { loadBadges() }
    }
    
    private func loadBadges() {
        badges = session.dataRepository.badges()
    }
    
    private func isBadgeEarned(_ badge: Badge) -> Bool {
        switch badge.criteria {
        case .streak(let days):
            return session.userProfile.streakDays >= days
        case .lettersMastered(let count):
            // Placeholder; wire to real mastery store later
            return count <= 10
        case .lessonsCompleted(let count):
            // Placeholder; no lessons yet
            return count <= 0
        case .wordsMastered(_):
            // Placeholder; not tracked yet
            return false
        }
    }
}