import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: MTSpacing.large) {
                    // Header with greeting and stats
                    HeaderView()
                        .padding(.horizontal)
                    
                    // Continue Learning Section
                    ContinueLearningSection()
                        .padding(.horizontal)
                    
                    // Alphabet Section
                    AlphabetSection()
                        .padding(.horizontal)
                    
                    // Vocabulary Themes
                    VocabularyThemesSection()
                        .padding(.horizontal)
                    
                    // Daily Goal Section
                    DailyGoalSection()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: MTSpacing.small) {
                Text("Hello there!")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                
                Text("Ready to learn some Telugu today?")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
            }
            
            Spacer()
            
            // Streak and XP chips
            VStack(spacing: MTSpacing.small) {
                HStack(spacing: 4) {
                    Image(systemName: "flame")
                        .foregroundColor(.orange)
                    Text("\(session.userProfile.streakDays)")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                }
                .padding(.horizontal, MTSpacing.small)
                .padding(.vertical, 4)
                .background(MTColors.surfaceAlt)
                .cornerRadius(8)
                
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                    Text("\(session.userProfile.totalXP)")
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .fontWeight(.bold)
                }
                .padding(.horizontal, MTSpacing.small)
                .padding(.vertical, 4)
                .background(MTColors.surfaceAlt)
                .cornerRadius(8)
            }
        }
    }
}

struct ContinueLearningSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Continue Learning")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            // Placeholder for continue learning card
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surfaceAlt)
                    .frame(height: 120)
                
                VStack {
                    Text("No ongoing lessons")
                        .font(MTTypography.body())
                        .foregroundColor(MTColors.text)
                    
                    Text("Start a new lesson to begin")
                        .font(MTTypography.caption())
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
            }
        }
    }
}

struct AlphabetSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Alphabet")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            NavigationLink {
                AlphabetGridView()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(MTColors.primary.opacity(0.1))
                        .frame(height: 80)
                    
                    HStack {
                        Image(systemName: "textformat.abc.dottedunderline")
                            .font(.title)
                            .foregroundColor(MTColors.primary)
                        
                        Text("Learn Telugu letters")
                            .font(MTTypography.body())
                            .foregroundColor(MTColors.text)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(MTColors.text.opacity(0.5))
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct VocabularyThemesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Vocabulary")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            NavigationLink {
                VocabularyThemesView()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(MTColors.secondary.opacity(0.1))
                        .frame(height: 80)
                    
                    HStack {
                        Image(systemName: "books.vertical")
                            .font(.title)
                            .foregroundColor(MTColors.secondary)
                        
                        Text("Explore vocabulary themes")
                            .font(MTTypography.body())
                            .foregroundColor(MTColors.text)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(MTColors.text.opacity(0.5))
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct DailyGoalSection: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        let progress = session.getDailyProgress()
        
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text("Daily Goal")
                .font(MTTypography.heading())
                .foregroundColor(MTColors.text)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surfaceAlt)
                    .frame(height: 100)
                
                VStack(spacing: MTSpacing.small) {
                    Text("\(progress.current)/\(progress.goal) minutes")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(MTColors.surface)
                                .frame(height: 10)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .fill(progress.current >= progress.goal ? MTColors.success : MTColors.primary)
                                .frame(width: geometry.size.width * progress.percentage, height: 10)
                        }
                    }
                    .frame(height: 10)
                    
                    Text(progress.current >= progress.goal ? 
                         "🎉 Daily goal completed!" : 
                         "Complete \(progress.goal) minutes to maintain your streak")
                        .font(MTTypography.caption())
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                .padding(.horizontal)
            }
        }
    }
}