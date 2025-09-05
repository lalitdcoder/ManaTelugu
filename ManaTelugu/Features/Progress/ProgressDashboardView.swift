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
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funGreen.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    Text("Progress")
                        .font(MTTypography.title())
                        .foregroundColor(MTColors.text)
                        .padding(.horizontal)
                    

                    
                    // Stats Overview
                    StatsOverview()
                        .padding(.horizontal)
                    
                    // Weekly Progress Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("This Week")
                            .font(MTTypography.heading())
                            .foregroundColor(MTColors.text)
                        ModernBarChart(weeklyData: weeklyData)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(16)
                    .shadow(color: MTColors.funBlue.opacity(0.08), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Badges Section
                    BadgesSection()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarIcon(systemName: "house.fill", selected: false)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarIcon(systemName: "star.fill", selected: false)
            }
        }
        .onAppear {
            loadWeeklyData()
        }
    }
    
    private func loadWeeklyData() {
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

// MARK: - Stats Overview
struct StatsOverview: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(title: "Total XP", value: "\(session.userProfile.totalXP)", icon: "star.fill", color: MTColors.funYellow)
            StatCard(title: "Streak", value: "\(session.userProfile.streakDays) days", icon: "flame.fill", color: MTColors.funPink)
            StatCard(title: "Lessons", value: "\(session.userProfile.lessonsCompleted)", icon: "book.fill", color: MTColors.funBlue)
            StatCard(title: "Letters", value: "\(session.userProfile.lettersMastered)", icon: "character.textbox", color: MTColors.funGreen)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(MTTypography.heading())
                    .foregroundColor(MTColors.text)
                Text(title)
                    .font(MTTypography.caption())
                    .foregroundColor(MTColors.text.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .shadow(color: color.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Badges Section
struct BadgesSection: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            DynamicBadgesGrid()
        }
    }
}

// MARK: - Badge View
struct BadgeView: View {
    let badge: Badge
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? MTColors.funYellow.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: isUnlocked ? "star.fill" : "lock.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(isUnlocked ? MTColors.funYellow : Color.gray)
            }
            
            Text(badge.name)
                .font(MTTypography.caption())
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Dynamic Badges Grid
struct DynamicBadgesGrid: View {
    @EnvironmentObject var session: AppSession
    @State private var badges: [Badge] = []
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
            ForEach(badges) { badge in
                BadgeView(
                    badge: badge,
                    isUnlocked: session.userProfile.unlockedBadges.contains(badge.id)
                )
            }
        }
        .onAppear {
            loadBadges()
        }
    }
    
    private func loadBadges() {
        if let url = Bundle.main.url(forResource: "badges", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let loadedBadges = try? JSONDecoder().decode([Badge].self, from: data) {
            badges = loadedBadges
        }
    }
}



// MARK: - Modern Bar Chart
struct ModernBarChart: View {
    let weeklyData: [ProgressDashboardView.ProgressDataPoint]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(weeklyData) { dataPoint in
                HStack {
                    Text(dataPoint.day)
                        .frame(width: 60, alignment: .leading)
                        .font(MTTypography.caption())
                        .foregroundColor(MTColors.text)
                    
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(gradient: Gradient(colors: [MTColors.funBlue, MTColors.funGreen]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(10, CGFloat(dataPoint.minutes) * 5), height: 18)
                    }
                    .frame(height: 18)
                    
                    Text("\(dataPoint.minutes) min")
                        .font(MTTypography.caption())
                        .foregroundColor(MTColors.text)
                        .frame(width: 50, alignment: .trailing)
                }
            }
        }
    }
}