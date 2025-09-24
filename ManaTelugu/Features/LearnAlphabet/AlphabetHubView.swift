import SwiftUI

// MARK: - Professional Alphabet Hub View
// Clean, professional layout with proper alphabet learning structure

struct ProfessionalAlphabetHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                if isLoading {
                    ProfessionalCard(type: .hero) {
                        VStack(spacing: ProfessionalSpacing.large.value) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.professionalBlue)
                            
                            ProfessionalText(
                                "Loading alphabet...",
                                style: .cardTitle,
                                color: .textPrimary,
                                alignment: .center
                            )
                        }
                        .padding(ProfessionalSpacing.extraLarge.value)
                    }
                    .padding(.horizontal, ProfessionalSpacing.large.value)
                } else {
                    ScrollView {
                        LazyVStack(spacing: ProfessionalSpacing.large.value) {
                            // Hero Header
                            heroHeaderSection
                                .padding(.top, ProfessionalSpacing.extraLarge.value)
                            
                            // Alphabet Stats
                            alphabetStatsSection
                            
                            // Learning Modes
                            learningModesSection
                            
                            // Quick Access Letters
                            quickAccessSection
                            
                            // Bottom padding for tab bar
                            Color.clear
                                .frame(height: 120)
                        }
                        .padding(.horizontal, ProfessionalSpacing.medium.value)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            Task {
                await loadLetters()
            }
        }
    }
    
    // MARK: - Hero Header Section
    private var heroHeaderSection: some View {
        ProfessionalCard(type: .hero) {
            VStack(alignment: .leading, spacing: ProfessionalSpacing.large.value) {
                ProfessionalText(
                    "Telugu Alphabet",
                    style: .heroTitle,
                    color: .textPrimary
                )
                
                ProfessionalText(
                    "Master the beautiful Telugu script with interactive learning",
                    style: .bodyText,
                    color: .textSecondary
                )
                
                HStack(spacing: ProfessionalSpacing.large.value) {
                    ProfessionalStatCard(
                        icon: "textformat.abc",
                        value: "\(vowels.count)",
                        label: "Vowels",
                        color: .professionalBlue
                    )
                    
                    ProfessionalStatCard(
                        icon: "textformat.abc",
                        value: "\(consonants.count)",
                        label: "Consonants",
                        color: .professionalGreen
                    )
                    
                    ProfessionalStatCard(
                        icon: "textformat.abc",
                        value: "\(letters.count)",
                        label: "Total",
                        color: .professionalOrange
                    )
                }
            }
        }
    }
    
    // MARK: - Alphabet Stats Section
    private var alphabetStatsSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Learning Progress",
                subtitle: "Track your alphabet mastery"
            )
            
            HStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalStatCard(
                    icon: "checkmark.circle.fill",
                    value: "12",
                    label: "Learned",
                    color: .professionalGreen
                )
                
                ProfessionalStatCard(
                    icon: "clock.fill",
                    value: "5m",
                    label: "Today",
                    color: .professionalBlue
                )
                
                ProfessionalStatCard(
                    icon: "star.fill",
                    value: "8",
                    label: "Streak",
                    color: .professionalOrange
                )
            }
        }
    }
    
    // MARK: - Learning Modes Section
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Learning Modes",
                subtitle: "Choose how to practice"
            )
            
            VStack(spacing: ProfessionalSpacing.medium.value) {
                ProfessionalLearningModeCard(
                    title: "Learn Vowels",
                    description: "Master the 16 basic vowel sounds",
                    icon: "textformat.abc",
                    color: .professionalBlue,
                    progress: 0.6
                )
                
                ProfessionalLearningModeCard(
                    title: "Learn Consonants",
                    description: "Practice the 36 consonant sounds",
                    icon: "textformat.abc",
                    color: .professionalGreen,
                    progress: 0.3
                )
                
                ProfessionalLearningModeCard(
                    title: "Practice Writing",
                    description: "Trace and write Telugu letters",
                    icon: "pencil.tip",
                    color: .professionalOrange,
                    progress: 0.8
                )
            }
        }
    }
    
    // MARK: - Quick Access Section
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
            ProfessionalSectionHeader(
                title: "Quick Access",
                subtitle: "Jump to specific letters"
            )
            
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: ProfessionalSpacing.medium.value) {
                    ForEach(Array(letters.prefix(16).enumerated()), id: \.element.id) { index, letter in
                        ProfessionalLetterCard(letter: letter, isLearned: index < 2)
                    }
                }
        }
    }
    
        // MARK: - Computed Properties
        private var vowels: [Letter] {
            // Mock vowel letters (first 4 letters)
            Array(letters.prefix(4))
        }
        
        private var consonants: [Letter] {
            // Mock consonant letters (remaining letters)
            Array(letters.dropFirst(4))
        }
    
    // MARK: - Data Loading
    private func loadLetters() async {
        // Simulate loading
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
            // Mock data for demonstration
            letters = [
                Letter(id: "te_letter_a", glyph: "అ", name: "a", transliteration: "a", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_aa", glyph: "ఆ", name: "aa", transliteration: "aa", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_i", glyph: "ఇ", name: "i", transliteration: "i", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_ii", glyph: "ఈ", name: "ii", transliteration: "ii", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_ka", glyph: "క", name: "ka", transliteration: "ka", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_kha", glyph: "ఖ", name: "kha", transliteration: "kha", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_ga", glyph: "గ", name: "ga", transliteration: "ga", audioFile: "", strokePathPoints: []),
                Letter(id: "te_letter_gha", glyph: "ఘ", name: "gha", transliteration: "gha", audioFile: "", strokePathPoints: [])
            ]
        
        await MainActor.run {
            isLoading = false
        }
    }
}

// MARK: - Professional Learning Mode Card
struct ProfessionalLearningModeCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let progress: Double
    
    var body: some View {
        ProfessionalCard(type: .interactive, isInteractive: true) {
            HStack(spacing: ProfessionalSpacing.medium.value) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: ProfessionalSpacing.small.value) {
                    ProfessionalText(
                        title,
                        style: .cardTitle,
                        color: .textPrimary
                    )
                    
                    ProfessionalText(
                        description,
                        style: .caption,
                        color: .textSecondary
                    )
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 4)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color)
                                .frame(width: geometry.size.width * progress, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

    // MARK: - Professional Letter Card
    struct ProfessionalLetterCard: View {
        let letter: Letter
        let isLearned: Bool
        
        var body: some View {
            ProfessionalCard(type: .compact, isInteractive: true) {
                VStack(spacing: ProfessionalSpacing.small.value) {
                    Text(letter.glyph)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(letter.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    if isLearned {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.professionalGreen)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

// MARK: - Letter Type Extension
extension Letter {
    enum LetterType {
        case vowel
        case consonant
    }
    
    var type: LetterType {
        // Determine if it's a vowel or consonant based on the letter
        let vowelGlyphs = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ", "ఏ", "ఋ", "ౠ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః"]
        return vowelGlyphs.contains(glyph) ? .vowel : .consonant
    }
    
    var isLearned: Bool {
        // Mock implementation - in real app this would come from user progress
        return false
    }
}

// MARK: - Replace the original AlphabetHubView
typealias AlphabetHubView = ProfessionalAlphabetHubView
