import SwiftUI

struct VowelsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var vowels: [Letter] = []

    // Traditional Telugu Vowel Order
    private let vowelOrder = [
        "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ",
        "ఋ", "ౠ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ",
        "అం", "అః",
    ]

    var body: some View {
        ZStack {
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: ManaTheme.Spacing.md) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Vowels • అచ్చులు")
                            .font(ManaTheme.Typography.title2)
                            .foregroundColor(ManaTheme.Colors.label)

                        Text("Tap any vowel to explore pronunciation and writing strokes")
                            .font(ManaTheme.Typography.subheadline)
                            .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    }
                    .padding(.horizontal, ManaTheme.Spacing.xs)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 4),
                        spacing: 14
                    ) {
                        ForEach(Array(vowels.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(letters: vowels, initialIndex: index)
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
        .navigationTitle("Vowels")
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
        let filtered = all.filter { vowelOrder.contains($0.character) }
        vowels = filtered.sorted { a, b in
            guard let ia = vowelOrder.firstIndex(of: a.character),
                let ib = vowelOrder.firstIndex(of: b.character)
            else { return false }
            return ia < ib
        }
    }
}
