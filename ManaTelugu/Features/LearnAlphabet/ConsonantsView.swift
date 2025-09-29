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
            ElegantGradient()
                .ignoresSafeArea(.all, edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ElegantDesign.Spacing.md) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ElegantDesign.Spacing.sm), count: 4), spacing: ElegantDesign.Spacing.sm) {
                        ForEach(Array(consonants.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(letters: consonants, initialIndex: index)
                            } label: {
                                LetterCardView(letter: letter)
                            }
                        }
                    }
                }
                .padding(ElegantDesign.Spacing.md)
                .padding(.bottom, ElegantDesign.Spacing.xl)
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
                // TODO: Implement addLearningTime method in AppSession
                // session.addLearningTime(minutes: minutes)
            }
        }
    }
    
    private func load() async {
        let all = await session.dataRepository.letters
        let filtered = all.filter { consonantOrder.contains($0.character) }
        consonants = filtered.sorted { a, b in
            guard let ia = consonantOrder.firstIndex(of: a.character), let ib = consonantOrder.firstIndex(of: b.character) else { return false }
            return ia < ib
        }
    }
}

// MARK: - Letter Card View
struct LetterCardView: View {
    let letter: Letter
    
    var body: some View {
        VStack(spacing: ElegantDesign.Spacing.xs) {
            Text(letter.character)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(ElegantDesign.Colors.primary)
            
            Text(letter.romanization)
                .font(ElegantDesign.Typography.caption)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
                .lineLimit(1)
        }
        .padding(ElegantDesign.Spacing.sm)
        .frame(width: 80, height: 80)
        .elegantCard()
    }
}

