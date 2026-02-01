import SwiftUI

struct AlphabetGridView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [Letter] = []
    @State private var searchText = ""

    // MARK: - Letter Categorization
    private var vowels: [Letter] {
        let vowelGlyphs = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        let base = letters.filter { vowelGlyphs.contains($0.character) }
        if searchText.isEmpty { return base }
        return base.filter {
            $0.character.localizedCaseInsensitiveContains(searchText)
                || $0.romanization.localizedCaseInsensitiveContains(searchText)
                || $0.meaning.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var consonants: [Letter] {
        let vowelGlyphs = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        let base = letters.filter { !vowelGlyphs.contains($0.character) }
        if searchText.isEmpty { return base }
        return base.filter {
            $0.character.localizedCaseInsensitiveContains(searchText)
                || $0.romanization.localizedCaseInsensitiveContains(searchText)
                || $0.meaning.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            EnhancedScrollView(bottomPadding: 140) {
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.tiny) {
                        (Text("Alphabet Adventure") as Text)
                            .font(ModernDesignSystem.Typography.title1)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        Text("Learn the Telugu script and sounds")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                        TextField("Search (e.g., 'ka' or 'క')", text: $searchText)
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                            .accessibilityLabel("Search letters")

                        if !searchText.isEmpty {
                            Button(action: {
                                HapticsManager.shared.selection()
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(ModernDesignSystem.Colors.surface)
                    .cornerRadius(ModernDesignSystem.CornerRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.lg)
                            .stroke(ModernDesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .shadow(
                        color: ModernDesignSystem.Colors.shadow.opacity(0.05), radius: 8, x: 0, y: 4
                    )

                    if !vowels.isEmpty {
                        // Vowels Section
                        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
                            HStack {
                                Text("Vowels (అచ్చులు)")
                                    .font(ModernDesignSystem.Typography.headline)
                                    .foregroundColor(ModernDesignSystem.Colors.funBlue)
                                Spacer()
                                Text("\(vowels.count) letters")
                                    .font(ModernDesignSystem.Typography.caption)
                                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.md)

                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(
                                        .flexible(), spacing: ModernDesignSystem.Spacing.md),
                                    count: 4), spacing: ModernDesignSystem.Spacing.md
                            ) {
                                ForEach(Array(vowels), id: \.id) { letter in
                                    let originalIndex =
                                        letters.firstIndex(where: { $0.id == letter.id }) ?? 0
                                    NavigationLink {
                                        LetterDetailView(
                                            letters: letters, initialIndex: originalIndex)
                                    } label: {
                                        ModernLetterCardView(letter: letter)
                                    }
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                // Haptic feedback
                                                HapticsManager.shared.impact(.medium)

                                                // Audio feedback
                                                session.audioService.play(
                                                    name: (letter.audioFileName?.isEmpty == false
                                                        ? letter.audioFileName!
                                                        : "default_audio.mp3"), rate: 1.0)
                                            }
                                    )
                                    .frame(
                                        minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                                        minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                                    )
                                    .accessibilityLabel("Telugu vowel \(letter.character)")
                                    .accessibilityHint("Double tap to learn more about this vowel")
                                    .accessibilityAddTraits(.isButton)
                                }
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        }
                    }

                    if !consonants.isEmpty {
                        // Consonants Section
                        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
                            HStack {
                                Text("Consonants (హల్లులు)")
                                    .font(ModernDesignSystem.Typography.headline)
                                    .foregroundColor(ModernDesignSystem.Colors.funGreen)
                                Spacer()
                                Text("\(consonants.count) letters")
                                    .font(ModernDesignSystem.Typography.caption)
                                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.md)

                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(
                                        .flexible(), spacing: ModernDesignSystem.Spacing.md),
                                    count: 4), spacing: ModernDesignSystem.Spacing.md
                            ) {
                                ForEach(consonants.indices, id: \.self) { index in
                                    let letter = consonants[index]
                                    let originalIndex =
                                        letters.firstIndex(where: { $0.id == letter.id }) ?? 0
                                    NavigationLink {
                                        LetterDetailView(
                                            letters: letters, initialIndex: originalIndex)
                                    } label: {
                                        ModernLetterCardView(letter: letter)
                                    }
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                // Haptic feedback
                                                HapticsManager.shared.impact(.medium)

                                                // Audio feedback
                                                session.audioService.play(
                                                    name: letter.audioFileName ?? "default_audio",
                                                    rate: 1.0)
                                            }
                                    )
                                    .frame(
                                        minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
                                        minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
                                    )
                                    .accessibilityLabel("Telugu consonant \(letter.character)")
                                    .accessibilityHint(
                                        "Double tap to learn more about this consonant"
                                    )
                                    .accessibilityAddTraits(.isButton)
                                }
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        }
                    }
                }
                .padding(.vertical, ModernDesignSystem.Spacing.lg)
            }
            // .searchable removed in favor of explicit search bar
        }
        .onAppear {
            letters = session.dataRepository.letters
            if letters.isEmpty {
                // Fallback test letters if data loading fails
                letters = [
                    Letter(
                        id: "test_a", character: "అ", romanization: "a", meaning: "a",
                        category: .vowel, audioFileName: "letter_a.mp3"),
                    Letter(
                        id: "test_aa", character: "ఆ", romanization: "aa", meaning: "aa",
                        category: .vowel, audioFileName: "letter_aa.mp3"),
                    Letter(
                        id: "test_i", character: "ఇ", romanization: "i", meaning: "i",
                        category: .vowel, audioFileName: "letter_i.mp3"),
                    Letter(
                        id: "test_ii", character: "ఈ", romanization: "ii", meaning: "ii",
                        category: .vowel, audioFileName: "letter_ii.mp3"),
                ]
            }
        }
        .navigationTitle("Alphabet Adventure")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
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
        let vowelGlyphs = [
            "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
        ]
        return vowelGlyphs.contains(letter.character)
    }

    private var cardColor: Color {
        isVowel ? ModernDesignSystem.Colors.funBlue : ModernDesignSystem.Colors.funGreen
    }

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.sm) {
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
                                        cardColor.opacity(0.1),
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
                .font(ModernDesignSystem.Typography.caption)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .frame(
            minWidth: ModernDesignSystem.Spacing.minimumTouchTarget,
            minHeight: ModernDesignSystem.Spacing.minimumTouchTarget
        )
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            cardColor.opacity(0.12),
                            cardColor.opacity(0.05),
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
            HapticsManager.shared.trigger(.medium)

            // Press animation
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }

            // Glow effect
            withAnimation(.easeInOut(duration: 0.3)) {
                isGlowing = true
            }

            // Audio feedback
            session.audioService.play(
                name: (letter.audioFileName?.isEmpty == false
                    ? letter.audioFileName! : "default_audio.mp3"), rate: 1.0)

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
