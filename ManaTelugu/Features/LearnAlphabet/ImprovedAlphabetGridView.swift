import SwiftUI

struct ImprovedAlphabetGridView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var selectedCategory: AlphabetCategory = .vowels
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category Selector
                    categorySelector
                        .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        .padding(.bottom, ModernDesignSystem.Spacing.md)
                    
                    // Letters Grid
                    ScrollView {
                        BreathingRoomLayout {
                            // Progress Header
                            VisualHierarchy.primaryContent {
                                progressHeader
                            }
                            
                            // Letters Grid
                            lettersGrid
                        }
                    }
                }
            }
            .navigationTitle("Telugu Alphabet")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear { loadLetters() }
    }
    
    private var categorySelector: some View {
        HStack(spacing: ModernDesignSystem.Spacing.sm) {
            categoryButton(.vowels, "Vowels", "అ")
            categoryButton(.consonants, "Consonants", "క")
        }
        .padding(ModernDesignSystem.Spacing.tiny)
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(12)
    }
    
    private func categoryButton(_ category: AlphabetCategory, _ title: String, _ example: String) -> some View {
        Button(action: { selectedCategory = category }) {
            HStack(spacing: ModernDesignSystem.Spacing.sm) {
                Text(example)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, ModernDesignSystem.Spacing.md)
            .padding(.vertical, ModernDesignSystem.Spacing.sm)
            .background(selectedCategory == category ? ModernDesignSystem.Colors.teluguBlue : Color.clear)
            .foregroundColor(selectedCategory == category ? .white : ModernDesignSystem.Colors.primaryText)
            .cornerRadius(8)
        }
        .higAccessible(
            label: "\(title) category",
            hint: "Switch to \(title.lowercased()) view"
        )
    }
    
    private var progressHeader: some View {
        CleanCardLayout(
            title: selectedCategory.title,
            subtitle: "\(filteredLetters.count) letters to learn"
        ) {
            HStack {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    
                    Text("12 of \(filteredLetters.count)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(ModernDesignSystem.Colors.teluguGreen)
                }
                
                Spacer()
                
                CircularProgressView(progress: 0.6, color: ModernDesignSystem.Colors.teluguGreen)
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    private var lettersGrid: some View {
        ImprovedGrid(columns: 3, spacing: ModernDesignSystem.Spacing.md) {
            ForEach(filteredLetters, id: \.id) { letter in
                letterCard(letter)
            }
        }
    }
    
    private func letterCard(_ letter: Letter) -> some View {
        HIGAccessibleCard(
            label: "Telugu letter \(letter.character)",
            hint: "Double tap to learn about this letter",
            action: { learnLetter(letter) }
        ) {
            VStack(spacing: ModernDesignSystem.Spacing.md) {
                Text(letter.character)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(ModernDesignSystem.Colors.teluguBlue)
                
                VStack(spacing: ModernDesignSystem.Spacing.tiny) {
                    Text(letter.romanization)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    
                    AudioButton(
                        audioFile: letter.audioFileName ?? "default_audio",
                        word: letter.character,
                        size: .small
                    )
                }
            }
            .padding(ModernDesignSystem.Spacing.md)
            .background(ModernDesignSystem.Colors.cardBackground)
            .cornerRadius(16)
            .frame(minHeight: 120)
        }
    }
    
    private var filteredLetters: [Letter] {
        switch selectedCategory {
        case .vowels:
            return letters.filter { isVowel($0.character) }
        case .consonants:
            return letters.filter { !isVowel($0.character) }
        }
    }
    
    private func isVowel(_ glyph: String) -> Bool {
        let vowels = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return vowels.contains(glyph)
    }
    
    private func loadLetters() {
        // Load letters from data source
    }
    
    private func learnLetter(_ letter: Letter) {
        session.hapticsService.lightImpact()
        // Navigate to letter detail
    }
}

enum AlphabetCategory: CaseIterable {
    case vowels, consonants
    
    var title: String {
        switch self {
        case .vowels: return "Vowels (అచ్చులు)"
        case .consonants: return "Consonants (హల్లులు)"
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}
