import SwiftUI

struct VowelsView: View {
    @EnvironmentObject var session: AppSession
    @State private var vowels: [Letter] = []
    
    // Traditional Telugu vowel order
    private let vowelOrder = [
        "అ","ఆ","ఇ","ఈ","ఉ","ఊ","ఋ","ౠ","ఎ","ఏ","ఐ","ఒ","ఓ","ఔ","అం","అః"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 4), spacing: MTSpacing.small) {
                    ForEach(vowels) { letter in
                        NavigationLink {
                            LetterDetailView(letter: letter)
                        } label: {
                            LetterCardView(letter: letter)
                        }
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
        .navigationTitle("Vowels (అచ్చులు)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func load() {
        let all = session.dataRepository.letters()
        let filtered = all.filter { vowelOrder.contains($0.glyph) }
        vowels = filtered.sorted { a, b in
            guard let ia = vowelOrder.firstIndex(of: a.glyph), let ib = vowelOrder.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
    }
}


