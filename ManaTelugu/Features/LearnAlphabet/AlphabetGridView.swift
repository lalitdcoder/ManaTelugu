import SwiftUI

struct AlphabetGridView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funYellow.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Alphabet Adventure")
                            .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text)
                        Text("Learn the Telugu script and sounds")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                    .padding(.horizontal)
                    // Letter Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        ForEach(letters) { letter in
                            NavigationLink {
                                LetterDetailView(letter: letter)
                            } label: {
                                ModernLetterCardView(letter: letter)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            Task {
                letters = await session.dataRepository.letters()
                print("DEBUG: Loaded \(letters.count) letters")
                if letters.isEmpty {
                    print("DEBUG: No letters loaded - using fallback test letters")
                    // Fallback test letters if data loading fails
                    letters = [
                        Letter(id: "test_a", glyph: "అ", name: "a", transliteration: "a", audioFile: "letter_a.mp3", strokePathPoints: []),
                        Letter(id: "test_aa", glyph: "ఆ", name: "aa", transliteration: "aa", audioFile: "letter_aa.mp3", strokePathPoints: []),
                        Letter(id: "test_i", glyph: "ఇ", name: "i", transliteration: "i", audioFile: "letter_i.mp3", strokePathPoints: []),
                        Letter(id: "test_ii", glyph: "ఈ", name: "ii", transliteration: "ii", audioFile: "letter_ii.mp3", strokePathPoints: [])
                    ]
                }
            }
        }
        .navigationTitle("Alphabet Adventure")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Modern Letter Card
struct ModernLetterCardView: View {
    @EnvironmentObject var session: AppSession
    let letter: Letter
    @State private var isPressed = false
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(MTColors.funBlue.opacity(0.10))
                    .frame(width: 56, height: 56)
                Text(letter.glyph)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(MTColors.funBlue)
            }
            Text(letter.transliteration)
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funBlue.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)

    }
}
// Reuse NavBarIcon from HomeView