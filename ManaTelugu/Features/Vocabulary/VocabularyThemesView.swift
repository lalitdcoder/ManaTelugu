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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: MTSpacing.medium) {
                Text("Vocabulary")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .padding(.horizontal)
                
                Text("Explore different themes to expand your vocabulary")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 2), spacing: MTSpacing.small) {
                    ForEach(themes, id: \.self) { theme in
                        NavigationLink {
                            VocabularyCardsView(theme: theme)
                        } label: {
                            ThemeCardView(theme: theme)
                        }
                    }
                }
                .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            // For now, we'll show all themes
            themes = allThemes
        }
    }
}

struct ThemeCardView: View {
    @EnvironmentObject var session: AppSession
    let theme: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(MTColors.surfaceAlt)
            
            VStack(spacing: MTSpacing.small) {
                Image(systemName: "books.vertical")
                    .font(.title)
                    .foregroundColor(MTColors.secondary)
                
                Text(theme)
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(height: 120)
    }
}