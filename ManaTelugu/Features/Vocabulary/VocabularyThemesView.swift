import SwiftUI

struct VocabularyThemesView: View {
    @EnvironmentObject var session: AppSession
    @State private var themes: [String] = []
    let allThemes = [
        "Numbers",
        "Colors", 
        "Animals",
        "Family",
        "Food",
        "School Objects",
        "Greetings",
        "Daily Actions",
        "Body Parts",
        "Weather"
    ]
    
    var body: some View {
        EnhancedScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vocabulary Quest")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(.primary)
                    Text("Explore different themes to expand your vocabulary")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Theme Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(themes, id: \.self) { theme in
                        NavigationLink {
                            VocabularyCardsView(theme: theme)
                        } label: {
                            ModernThemeCardView(theme: theme)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .softGradientBackground()
        .onAppear {
            themes = allThemes
        }
        .navigationTitle("Vocabulary")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Modern Theme Card
struct ModernThemeCardView: View {
    @EnvironmentObject var session: AppSession
    let theme: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                MTColors.funGreen.opacity(0.10)
                    .frame(width: 56, height: 56)
                    .cornerRadius(16)
                Image(systemName: iconForTheme(theme))
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(MTColors.funGreen)
            }
            Text(theme)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4)
    }
    
    func iconForTheme(_ theme: String) -> String {
        switch theme {
        case "Numbers": return "number"
        case "Colors": return "paintpalette.fill"
        case "Animals": return "pawprint.fill"
        case "Family": return "person.3.fill"
        case "Food": return "fork.knife"
        case "School Objects": return "backpack.fill"
        case "Greetings": return "hand.wave.fill"
        case "Daily Actions": return "figure.walk"
        case "Body Parts": return "figure.stand"
        case "Weather": return "cloud.sun.fill"
        default: return "books.vertical"
        }
    }
}
