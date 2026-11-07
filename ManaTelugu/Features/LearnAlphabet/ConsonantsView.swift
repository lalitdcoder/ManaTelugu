import SwiftUI

struct ConsonantsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var consonants: [Letter] = []

    // Traditional Telugu consonant order
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
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: ManaTheme.Spacing.md) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Consonants • హల్లులు")
                            .font(ManaTheme.Typography.title2)
                            .foregroundColor(ManaTheme.Colors.label)

                        Text("Tap any letter to hear pronunciation and practice tracing")
                            .font(ManaTheme.Typography.subheadline)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                    .padding(.horizontal, ManaTheme.Spacing.xs)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 4),
                        spacing: 14
                    ) {
                        ForEach(Array(consonants.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(letters: consonants, initialIndex: index)
                            } label: {
                                LetterCardView(letter: letter)
                            }
                            .buttonStyle(NativeCardButtonStyle())
                        }
                    }
                }
                .padding(ManaTheme.Spacing.screenMarginLarge)
                .padding(.bottom, 60)
            }
        }
        .navigationTitle("Consonants")
        .navigationBarTitleDisplayMode(.inline)
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
