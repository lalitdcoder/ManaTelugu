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
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 4), spacing: MTSpacing.small) {
                ForEach(consonants) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        LetterCardView(letter: letter)
                    }
                }
            }
            .padding()
        }
        .onAppear { 
            load()
            session.sessionTimer.start()
        }
        .onDisappear {
            let minutes = session.sessionTimer.stop()
            if minutes > 0 {
                session.addLearningTime(minutes: minutes)
            }
        }
        .navigationTitle("Consonants (హల్లులు)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func load() {
        let all = session.dataRepository.letters()
        let filtered = all.filter { consonantOrder.contains($0.glyph) }
        consonants = filtered.sorted { a, b in
            guard let ia = consonantOrder.firstIndex(of: a.glyph), let ib = consonantOrder.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
    }
}


