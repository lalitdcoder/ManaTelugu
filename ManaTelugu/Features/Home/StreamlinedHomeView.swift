import SwiftUI

struct StreamlinedHomeView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedLearningMode: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Welcome Section
                        welcomeSection
                            .padding(.top, 20)
                        
                        // Progress Overview
                        progressOverview
                        
                        // Learning Paths
                        learningPaths
                        
                        // Continue Learning
                        continueSection
                        
                        // Recent Achievements
                        recentAchievements
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Mana Telugu")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Continue your Telugu learning journey")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Avatar or streak indicator
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                    }
                    
                    Text("5 day streak")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var progressOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                ProgressCard(
                    title: "Letters",
                    current: 24,
                    total: 36,
                    color: .blue,
                    icon: "textformat.abc"
                )
                
                ProgressCard(
                    title: "XP Today",
                    current: 150,
                    total: 200,
                    color: .purple,
                    icon: "star.fill"
                )
            }
            
            // Overall progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overall Progress")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("67%")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: 0.67)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 1.5)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var learningPaths: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Paths")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                LearningPathCard(
                    title: "Telugu Alphabet",
                    description: "Master all 36 Telugu letters",
                    progress: 0.67,
                    icon: "textformat.abc",
                    color: .blue
                ) {
                    // Navigate to alphabet learning
                }
                
                LearningPathCard(
                    title: "Practice Games",
                    description: "Fun games to reinforce learning",
                    progress: 0.45,
                    icon: "gamecontroller.fill",
                    color: .green
                ) {
                    // Navigate to games
                }
                
                LearningPathCard(
                    title: "Story Reading",
                    description: "Read Telugu stories and tales",
                    progress: 0.23,
                    icon: "book.fill",
                    color: .orange
                ) {
                    // Navigate to stories
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var continueSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Continue Learning")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            ContinueLearningCard(mode: HorizontalLearningCards.LearningMode(title: "Vowels", description: "Learn Telugu vowels", iconName: "textformat", color: .blue, progress: 0.75))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var recentAchievements: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink("View All") {
                    // Navigate to full achievements
                }
                .font(.body)
                .foregroundColor(.blue)
            }
            
            HStack(spacing: 12) {
                ForEach(recentBadges, id: \.name) { badge in
                    RecentBadgeView(badge: badge)
                }
                
                if recentBadges.count < 3 {
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private let recentBadges = [
        (name: "Quick Learner", emoji: "⚡", color: Color.yellow),
        (name: "Game Master", emoji: "🎮", color: Color.green),
        (name: "First Steps", emoji: "👶", color: Color.blue)
    ]
}

struct ProgressCard: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    let icon: String
    
    var progress: Double {
        Double(current) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(current)/\(total)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                    .scaleEffect(y: 0.8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05))
        )
    }
}

struct LearningPathCard: View {
    let title: String
    let description: String
    let progress: Double
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: color))
                            .scaleEffect(y: 0.6)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(color)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.05))
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// ContinueLearningCard is defined in MissingComponents.swift

struct RecentBadgeView: View {
    let badge: (name: String, emoji: String, color: Color)
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(badge.emoji)
                    .font(.system(size: 24))
            }
            
            Text(badge.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
