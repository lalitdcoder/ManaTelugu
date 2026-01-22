import SwiftUI

struct EnhancedProgressView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab = 0
    @State private var showingBadgeDetail: GamificationBadge? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Use standard segmented control
                Picker("Progress View", selection: $selectedTab) {
                    Text("Overview").tag(0)
                    Text("Badges").tag(1)
                    Text("Achievements").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppleHIGDesign.Spacing.md)
                .padding(.top, AppleHIGDesign.Spacing.sm)

                TabView(selection: $selectedTab) {
                    progressOverview
                        .tag(0)

                        // Removed badge showcase section
                        .tag(1)

                    achievementsView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(AppleHIGDesign.Colors.systemBackground)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            // Removed badge detail sheet
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: {
                    HapticsService.shared.navigationTap()
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tabTitle(for: index))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedTab == index ? .white : .secondary)

                        if selectedTab == index {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white)
                                .frame(width: 30, height: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.clear)
                                .frame(width: 30, height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? Color.blue : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground).opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Overview"
        case 1: return "Badges"
        case 2: return "Achievements"
        default: return ""
        }
    }

    private var progressOverview: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Hearts Display
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(session.hearts)")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.red.opacity(0.1)))
                }
                .padding(.top, 8)

                statsGrid
                weeklyProgressChart
                recentActivity
                LeaderboardCard(leaderboard: session.leaderboardService.leaderboard)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
            ], spacing: 12
        ) {
            StatCard(
                title: "Letters Learned",
                value: "\(session.learnedLetters)",
                total: "\(session.totalLetters)",
                icon: "textformat.abc",
                color: .blue,
                progress: session.totalLetters > 0
                    ? Double(session.learnedLetters) / Double(session.totalLetters) : 0
            )

            StatCard(
                title: "Words Mastered",
                value: "\(session.masteredWords)",
                total: "\(session.dataRepository.words.count)",
                icon: "book.fill",
                color: .green,
                progress: session.dataRepository.words.count > 0
                    ? Double(session.masteredWords) / Double(session.dataRepository.words.count) : 0
            )

            StatCard(
                title: "Current Streak",
                value: "\(session.currentStreak)",
                total: nil,
                icon: "flame.fill",
                color: .orange,
                progress: nil
            )

            StatCard(
                title: "Total XP",
                value: "\(session.gamificationService.gamificationState.totalXP)",
                total: nil,
                icon: "star.fill",
                color: .purple,
                progress: nil
            )
        }
    }

    private var weeklyProgressChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week's XP")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(calculateWeeklyXP(), id: \.day) { data in
                    VStack(spacing: 8) {
                        GeometryReader { geometry in
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.opacity(0.8))
                                    // Scale height based on max XP, min height 4
                                    .frame(
                                        height: max(
                                            4,
                                            CGFloat(data.xp) / CGFloat(max(1, maxWeeklyXP()))
                                                * geometry.size.height))
                            }
                        }
                        .frame(height: 100)

                        Text(data.day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            if session.gamificationService.gamificationState.xpHistory.isEmpty {
                Text("No recent activity")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 12) {
                    ForEach(
                        session.gamificationService.gamificationState.xpHistory.suffix(3).reversed()
                    ) { event in
                        ActivityRow(
                            icon: event.type.icon,
                            title: event.description,
                            time: event.timestamp.formatted(date: .omitted, time: .shortened),
                            color: Color(event.type.color)
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // Helper to calculate weekly XP
    private func calculateWeeklyXP() -> [(day: String, xp: Int)] {
        let calendar = Calendar.current
        let today = Date()
        let last7Days = (0..<7).map { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)!
        }.reversed()

        return last7Days.map { date in
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            let dailyXP = session.gamificationService.gamificationState.xpHistory
                .filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
                .reduce(0) { $0 + $1.amount }

            return (day: dayName, xp: dailyXP)
        }
    }

    private func maxWeeklyXP() -> Int {
        calculateWeeklyXP().map { $0.xp }.max() ?? 100  // Default max for scale
    }

    private var badgeShowcase: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Badge Collection")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Earn badges by completing lessons and games")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                earnedBadgesSection
                lockedBadgesSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }

    private var earnedBadgesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Earned Badges")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                Text("3/6")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                ], spacing: 12
            ) {
                ForEach(earnedBadges) { badge in
                    BadgeCard(badge: badge, isEarned: true) {
                        showingBadgeDetail = badge
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var lockedBadgesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Locked Badges")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                ], spacing: 12
            ) {
                ForEach(lockedBadges) { badge in
                    BadgeCard(badge: badge, isEarned: false) {
                        showingBadgeDetail = badge
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var achievementsView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                milestonesSection
                streaksSection
                recordsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }

    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Milestones")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                MilestoneRow(
                    title: "First Letter Learned",
                    description: "Completed your first Telugu letter",
                    isCompleted: true,
                    date: "5 days ago"
                )

                MilestoneRow(
                    title: "10 Letters Mastered",
                    description: "Learn 10 Telugu letters",
                    isCompleted: true,
                    date: "3 days ago"
                )

                MilestoneRow(
                    title: "25 Letters Mastered",
                    description: "Learn 25 Telugu letters",
                    isCompleted: false,
                    date: nil
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var streaksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streaks")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            HStack(spacing: 16) {
                StreakCard(
                    title: "Current Streak",
                    value: "5 days",
                    icon: "flame.fill",
                    color: .orange
                )

                StreakCard(
                    title: "Best Streak",
                    value: "12 days",
                    icon: "trophy.fill",
                    color: .yellow
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private var recordsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Records")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                RecordRow(title: "Fastest Game Completion", value: "45 seconds")
                RecordRow(title: "Most XP in One Day", value: "350 XP")
                RecordRow(title: "Perfect Game Scores", value: "8 games")
                RecordRow(title: "Total Study Time", value: "12h 30m")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    private let weeklyData = [
        (day: "Mon", minutes: 25),
        (day: "Tue", minutes: 40),
        (day: "Wed", minutes: 15),
        (day: "Thu", minutes: 35),
        (day: "Fri", minutes: 50),
        (day: "Sat", minutes: 30),
        (day: "Sun", minutes: 20),
    ]

    private var earnedBadges: [GamificationBadge] {
        session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }
    }

    private var lockedBadges: [GamificationBadge] {
        session.gamificationService.gamificationState.badges.filter { !$0.isUnlocked }
    }
}

// Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let total: String?
    let icon: String
    let color: Color
    let progress: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)

                Spacer()

                if let progress = progress {
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    if let total = total {
                        Text("/\(total)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let progress = progress {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: color))
                        .scaleEffect(y: 0.5)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct ActivityRow: View {
    let icon: String
    let title: String
    let time: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)

                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct BadgeCard: View {
    let badge: GamificationBadge
    let isEarned: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticsService.shared.buttonTap()
            action()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isEarned ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 60, height: 60)

                    Text(badge.emoji)
                        .font(.system(size: 30))
                        .grayscale(isEarned ? 0 : 1)
                        .opacity(isEarned ? 1 : 0.5)
                }

                Text(badge.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isEarned ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(
            minimumDuration: 0, maximumDistance: .infinity,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

struct MilestoneRow: View {
    let title: String
    let description: String
    let isCompleted: Bool
    let date: String?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isCompleted ? .green : .gray)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let date = date {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }

            Spacer()
        }
    }
}

struct StreakCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct RecordRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct BadgeDetailSheet: View {
    let badge: GamificationBadge
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(badge.emoji)
                        .font(.system(size: 80))

                    Text(badge.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(badge.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    if badge.isUnlocked {
                        Text("Earned!")
                            .font(.body)
                            .foregroundColor(.green)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How to earn:")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)

                            Text(requirementDescription(badge.requirement))
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .navigationTitle("Badge Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        HapticsService.shared.navigationTap()
                        dismiss()
                    }
                }
            }
        }
    }

    private func requirementDescription(_ requirement: BadgeRequirement) -> String {
        switch requirement {
        case .wordsLearned(let count):
            return "Learn \(count) words"
        case .streakDays(let days):
            return "Maintain a \(days)-day streak"
        case .quizzesCompleted(let count):
            return "Complete \(count) quizzes"
        case .perfectQuizzes(let count):
            return "Get perfect scores on \(count) quizzes"
        case .xpEarned(let xp):
            return "Earn \(xp) XP points"
        case .levelReached(let level):
            return "Reach level \(level)"
        case .daysActive(let days):
            return "Be active for \(days) days"
        case .lettersLearned(let count):
            return "Learn \(count) letters"
        case .storiesCompleted(let count):
            return "Read \(count) stories"
        case .combo(let requirements):
            return requirements.map { requirementDescription($0) }.joined(separator: " and ")
        }
    }
}
