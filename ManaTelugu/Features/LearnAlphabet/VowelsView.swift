import SwiftUI

struct VowelsView: View {
    @EnvironmentObject var session: AppSession
    @State private var vowels: [Letter] = []
    
    // Traditional Telugu vowel order
    private let vowelOrder = [
        "అ","ఆ","ఇ","ఈ","ఉ","ఊ","ఋ","ౠ","ఎ","ఏ","ఐ","ఒ","ఓ","ఔ","అం","అః"
    ]
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            EnhancedScrollView(bottomPadding: 140) {
            VStack(spacing: MTSpacing.medium) {
                // Removed top quiz CTA for a cleaner learning flow
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 4), spacing: MTSpacing.small) {
                    ForEach(Array(vowels.enumerated()), id: \.element.id) { index, letter in
                        NavigationLink {
                            LetterDetailView(letters: vowels, initialIndex: index)
                        } label: {
                            LetterCardView(letter: letter)
                        }
                    }
                }
            }
            .padding()
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
        let filtered = all.filter { vowelOrder.contains($0.glyph) }
        vowels = filtered.sorted { a, b in
            guard let ia = vowelOrder.firstIndex(of: a.glyph), let ib = vowelOrder.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
    }
    
    private func quizCard(title: String, subtitle: String, icon: String) -> some View {
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
        .padding(16)
        .glassEffect(.regular, shape: .rect(cornerRadius: 16))
        .frame(height: 90)
    }
}


