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
        .navigationTitle("Consonants (హల్లులు)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func load() async {
        let all = await session.dataRepository.letters()
        let filtered = all.filter { consonantOrder.contains($0.glyph) }
        consonants = filtered.sorted { a, b in
            guard let ia = consonantOrder.firstIndex(of: a.glyph), let ib = consonantOrder.firstIndex(of: b.glyph) else { return false }
            return ia < ib
        }
    }
}

// MARK: - Letter Card View
struct LetterCardView: View {
    let letter: Letter
    @State private var isPressed = false
    
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
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.95))
                .shadow(color: MTColors.funBlue.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}


