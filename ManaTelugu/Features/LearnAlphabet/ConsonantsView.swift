import SwiftUI

struct ConsonantsView: View {
    @EnvironmentObject var session: AppSession
    @State private var consonants: [Letter] = []
    
    // Traditional Telugu consonant order (grouped, simplified up to క్ష)
    private let consonantOrder = [
        "క","ఖ","గ","ఘ","ఙ",
        "చ","ఛ","జ","ఝ","ఞ",
        "ట","ఠ","డ","ఢ","ణ",
        "త","థ","ద","ధ","న",
        "ప","ఫ","బ","భ","మ",
        "య","ర","ల","వ",
        "శ","ష","స","హ",
        "ళ","క్ష","ఱ"
    ]
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            EnhancedScrollView(bottomPadding: 140) {
            VStack(spacing: MTSpacing.medium) {
                // Removed quiz CTA here as requested
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 4), spacing: MTSpacing.small) {
                    ForEach(Array(consonants.enumerated()), id: \.element.id) { index, letter in
                        NavigationLink {
                            LetterDetailView(letters: consonants, initialIndex: index)
                        } label: {
                            LetterCardView(letter: letter)
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
                await load()
            }
            session.sessionTimer.start()
        }
        .onDisappear {
            let minutes = session.sessionTimer.stop()
            if minutes > 0 {
                session.addLearningTime(minutes: minutes)
            }
        }
    }
    
    private func load() async {
        let all = await session.dataRepository.letters()
        let filtered = all.filter { consonantOrder.contains($0.glyph) }
        consonants = filtered.sorted { a, b in
            guard let ia = consonantOrder.firstIndex(of: a.glyph), let ib = consonantOrder.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
    }
    
    private func quizCard(title: String, subtitle: String, icon: String) -> some View {
        UnifiedLiquidGlassCard(
            layer: .content,
            intensity: 0.12,
            cornerRadius: 16,
            padding: 16,
            isInteractive: false
        ) {
            HStack(spacing: MTSpacing.medium) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(MTColors.primary)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    Text(subtitle)
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(MTColors.text.opacity(0.5))
            }
        }
        .frame(height: 90)
    }
}

// MARK: - Letter Card View
struct LetterCardView: View {
    let letter: Letter
    
    var body: some View {
        VStack(spacing: 8) {
            Text(letter.glyph)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(MTColors.text)
            
            Text(letter.transliteration)
                .font(MTTypography.caption())
                .foregroundColor(MTColors.text.opacity(0.7))
                .lineLimit(1)
        }
        .padding(8)
        .glassEffect(.subtle, shape: .rect(cornerRadius: 16))
        .frame(width: 80, height: 80)
        // Removed conflicting tap gesture - NavigationLink handles all interactions
    }
}


