import SwiftUI

struct LiquidGlassHomeView: View {
    @State private var currentStreak = 7
    @State private var userName = "Learner"
    @State private var nextLesson = "Telugu Greetings"
    @State private var weeklyGoal = 5
    @State private var completedThisWeek = 3
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LGDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LGDesign.Spacing.lg) {
                        // Header Section
                        headerSection
                        

                        
                        // Goals Card
                        goalsCard
                        
                        // Bottom padding for tab bar
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, LGDesign.Spacing.md)
                    .padding(.top, LGDesign.Spacing.sm)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: LGDesign.Spacing.xs) {
                Text("Hello, \(userName)")
                    .font(LGDesign.Typography.title)
                    .foregroundColor(LGDesign.Colors.text)
                
                Text("Ready to learn Telugu?")
                    .font(LGDesign.Typography.body)
                    .foregroundColor(LGDesign.Colors.secondaryText)
            }
            
            Spacer()
            
            // Streak Badge
            HStack(spacing: LGDesign.Spacing.xs) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(currentStreak)")
                    .font(LGDesign.Typography.headline)
                    .foregroundColor(LGDesign.Colors.text)
            }
            .padding(.horizontal, LGDesign.Spacing.md)
            .padding(.vertical, LGDesign.Spacing.sm)
            .background(.regularMaterial, in: Capsule())
        }
    }
    

    
    // MARK: - Goals Card
    private var goalsCard: some View {
        LiquidGlassCard(padding: LGDesign.Spacing.lg) {
            VStack(alignment: .leading, spacing: LGDesign.Spacing.md) {
                HStack {
                    Text("Your Goals")
                        .font(LGDesign.Typography.title2)
                        .foregroundColor(LGDesign.Colors.text)
                    
                    Spacer()
                    
                    Text("\(completedThisWeek)/\(weeklyGoal)")
                        .font(LGDesign.Typography.headline)
                        .foregroundColor(LGDesign.Colors.accent)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LGDesign.Colors.primary)
                            .frame(width: geometry.size.width * (Double(completedThisWeek) / Double(weeklyGoal)), height: 8)
                    }
                }
                .frame(height: 8)
                
                Text("Keep going! \(weeklyGoal - completedThisWeek) lessons left this week")
                    .font(LGDesign.Typography.caption)
                    .foregroundColor(LGDesign.Colors.secondaryText)
            }
        }
    }
}

// MARK: - Tab Bar
struct LiquidGlassTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LiquidGlassHomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            Text("Learn Screen")
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("Learn")
                }
                .tag(1)
            
            Text("Practice Screen")
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                    Text("Practice")
                }
                .tag(2)
            
            Text("Profile Screen")
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(LGDesign.Colors.accent)
    }
}

#Preview {
    LiquidGlassTabView()
}
