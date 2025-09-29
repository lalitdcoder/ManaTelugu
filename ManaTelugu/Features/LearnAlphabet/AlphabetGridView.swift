import SwiftUI

struct AlphabetGridView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    
    // MARK: - Letter Categorization
    private var vowels: [Letter] {
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return letters.filter { vowelGlyphs.contains($0.character) }
    }
    
    private var consonants: [Letter] {
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return letters.filter { !vowelGlyphs.contains($0.character) }
    }
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            EnhancedScrollView(bottomPadding: 140) {
                VStack(alignment: .leading, spacing: MTSpacing.xLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                        (Text("Alphabet Adventure") as Text)
                            .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.primaryText)
                        Text("Learn the Telugu script and sounds")
                            .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.secondaryText)
                    }
                    .padding(.horizontal, MTSpacing.medium)
                    
                    // Vowels Section
                    VStack(alignment: .leading, spacing: MTSpacing.medium) {
                        HStack {
                            Text("Vowels (అచ్చులు)")
                                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.funBlue)
                            Spacer()
                            Text("\(vowels.count) letters")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.secondaryText)
                        }
                        .padding(.horizontal, MTSpacing.medium)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.medium), count: 4), spacing: MTSpacing.medium) {
                            ForEach(Array(vowels), id: \.id) { letter in
                                let originalIndex = letters.firstIndex(where: { $0.id == letter.id }) ?? 0
                                NavigationLink {
                                    LetterDetailView(letters: letters, initialIndex: originalIndex)
                                } label: {
                                    ModernLetterCardView(letter: letter)
                                }
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            // Haptic feedback
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                            impactFeedback.impactOccurred()
                                            
                                            // Audio feedback
                                            session.audioService.play(name: letter.audioFileName ?? "default_audio", rate: 1.0)
                                        }
                                )
                            .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
                            .accessibilityLabel("Telugu vowel \(letter.character)")
                            .accessibilityHint("Double tap to learn more about this vowel")
                            .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding(.horizontal, MTSpacing.medium)
                    }
                    
                    // Consonants Section
                    VStack(alignment: .leading, spacing: MTSpacing.medium) {
                        HStack {
                            Text("Consonants (హల్లులు)")
                                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.funGreen)
                            Spacer()
                            Text("\(consonants.count) letters")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.secondaryText)
                        }
                        .padding(.horizontal, MTSpacing.medium)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.medium), count: 4), spacing: MTSpacing.medium) {
                            ForEach(consonants.indices, id: \.self) { index in
                                let letter = consonants[index]
                                let originalIndex = letters.firstIndex(where: { $0.id == letter.id }) ?? 0
                                NavigationLink {
                                    LetterDetailView(letters: letters, initialIndex: originalIndex)
                                } label: {
                                    ModernLetterCardView(letter: letter)
                                }
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            // Haptic feedback
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                            impactFeedback.impactOccurred()
                                            
                                            // Audio feedback
                                            session.audioService.play(name: letter.audioFileName ?? "default_audio", rate: 1.0)
                                        }
                                )
                            .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
                            .accessibilityLabel("Telugu consonant \(letter.character)")
                            .accessibilityHint("Double tap to learn more about this consonant")
                            .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding(.horizontal, MTSpacing.medium)
                    }
                }
                .padding(.vertical, MTSpacing.large)
            }
        }
        .onAppear {
            Task {
                letters = await session.dataRepository.letters
                if letters.isEmpty {
                    // Fallback test letters if data loading fails
                    letters = [
                        Letter(id: "test_a", character: "అ", romanization: "a", meaning: "a", category: .vowel, audioFileName: "letter_a.mp3"),
                        Letter(id: "test_aa", character: "ఆ", romanization: "aa", meaning: "aa", category: .vowel, audioFileName: "letter_aa.mp3"),
                        Letter(id: "test_i", character: "ఇ", romanization: "i", meaning: "i", category: .vowel, audioFileName: "letter_i.mp3"),
                        Letter(id: "test_ii", character: "ఈ", romanization: "ii", meaning: "ii", category: .vowel, audioFileName: "letter_ii.mp3")
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
    @State private var isGlowing = false
    
    // MARK: - Letter Type Detection
    private var isVowel: Bool {
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return vowelGlyphs.contains(letter.character)
    }
    
    private var cardColor: Color {
        isVowel ? MTColors.funBlue : MTColors.funGreen
    }
    
    var body: some View {
        VStack(spacing: MTSpacing.small) {
            ZStack {
                // Enhanced Liquid Glass Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
                    .frame(width: 70, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        cardColor.opacity(0.4),
                                        cardColor.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                // Letter Glyph with enhanced styling
                Text(letter.character)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(cardColor)
            }
            
            // Transliteration with better styling
            (Text(letter.romanization) as Text)
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
                .multilineTextAlignment(.center)
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                cardColor.opacity(0.12),
                                cardColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .glassEffect(.regular, shape: .rect(cornerRadius: 24))
            )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isPressed)
        .onTapGesture {
            // Enhanced haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Press animation
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            // Glow effect
            withAnimation(.easeInOut(duration: 0.3)) {
                isGlowing = true
            }
            
            // Audio feedback
            session.audioService.play(name: letter.audioFileName ?? "default_audio", rate: 1.0)
            
            // Reset states
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isGlowing = false
                }
            }
        }
    }
}
// Reuse NavBarIcon from HomeView