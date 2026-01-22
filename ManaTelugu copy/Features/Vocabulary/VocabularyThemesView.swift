import SwiftUI

struct VocabularyThemesView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var themes: [String] = []
    
    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            EnhancedScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vocabulary Quest")
                        .font(ModernDesignSystem.Typography.title1)
                        .foregroundColor(.primary)
                    Text("Explore different themes to expand your vocabulary")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, -20)
                
                // Theme Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(themes, id: \.self) { theme in
                        NavigationLink {
                            VocabularyCardsView(theme: theme)
                        } label: {
                            ModernThemeCardView(theme: theme)
                        }
                        .buttonStyle(HapticButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .softGradientBackground()
        .onAppear {
            DebugLogger.log("VocabularyThemesView appeared")
            // Load themes dynamically from actual data
            let allThemes = Set(session.dataRepository.words.map { $0.theme })
            themes = Array(allThemes).sorted()
            DebugLogger.log("Available vocabulary themes: \(themes)")
        }
        .navigationTitle("Vocabulary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
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
                ModernDesignSystem.Colors.funGreen.opacity(0.10)
                    .frame(width: 56, height: 56)
                    .cornerRadius(16)
                Image(systemName: iconForTheme(theme))
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(ModernDesignSystem.Colors.funGreen)
            }
            Text(theme)
                .font(ModernDesignSystem.Typography.body)
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
