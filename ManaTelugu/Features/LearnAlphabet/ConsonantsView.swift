import SwiftUI

struct ConsonantsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var consonants: [Letter] = []

    // Traditional Telugu consonant order (grouped, simplified up to క్ష)
    private let consonantOrder = [
        "క", "ఖ", "గ", "ఘ", "ఙ",
        "చ", "ఛ", "జ", "ఝ", "ఞ",
        "ట", "ఠ", "డ", "ఢ", "ణ",
        "త", "థ", "ద", "ధ", "న",
        "ప", "ఫ", "బ", "భ", "మ",
        "య", "ర", "ల", "వ",
        "శ", "ష", "స", "హ",
        "ళ", "క్ష", "ఱ",
    ]

    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: ModernDesignSystem.Spacing.md) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4),
                        spacing: 16
                    ) {
                        ForEach(Array(consonants.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(letters: consonants, initialIndex: index)
                            } label: {
                                LetterCardView(letter: letter)
                            }
                            .buttonStyle(.plain)
                            .onTapGesture {
                                HapticsService.shared.buttonTap()
                            }
                        }
                    }
                }
                .padding(ModernDesignSystem.Spacing.md)
                .padding(.bottom, ModernDesignSystem.Spacing.xl)
            }
        }
        .navigationTitle("Consonants (హల్లులు)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
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
    }

    private func load() {
        let all = session.dataRepository.letters
        let filtered = all.filter { consonantOrder.contains($0.character) }
        consonants = filtered.sorted { a, b in
            guard let ia = consonantOrder.firstIndex(of: a.character),
                let ib = consonantOrder.firstIndex(of: b.character)
            else { return false }
            return ia < ib
        }
    }
}
