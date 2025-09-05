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
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funGreen.opacity(0.10), MTColors.funPink.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Vocabulary Quest")
                            .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        Text("Explore different themes to expand your vocabulary")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                    .padding(.horizontal)
                    
                    // Beta Notice for Weather (subtle)
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        
                        Text("New weather vocabulary words added! 🌤️")
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.08))
                    )
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
        }
        .onAppear {
            themes = allThemes
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
    }
}

// MARK: - Modern Theme Card
struct ModernThemeCardView: View {
    @EnvironmentObject var session: AppSession
    let theme: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(MTColors.funGreen.opacity(0.10))
                    .frame(width: 56, height: 56)
                Image(systemName: iconForTheme(theme))
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(MTColors.funGreen)
            }
            Text(theme)
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .fontWeight(.semibold)
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funGreen.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
    // Modern icon for each theme
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
// Reuse NavBarIcon from HomeView