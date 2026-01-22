import SwiftUI

struct VowelsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var vowels: [Letter] = []
    
    // Traditional Telugu vowel order
    private let vowelOrder = [
        "అ","ఆ","ఇ","ఈ","ఉ","ఊ","ఋ","ౠ","ఎ","ఏ","ఐ","ఒ","ఓ","ఔ","అం","అః"
    ]
    
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient
                .ignoresSafeArea(.all, edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        ForEach(Array(vowels.enumerated()), id: \.element.id) { index, letter in
                            NavigationLink {
                                LetterDetailView(letters: vowels, initialIndex: index)
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
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Vowels (అచ్చులు)")
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
                session.gamificationService.awardXP(minutes * 2, type: .dailyGoal, description: "Time spent learning vowels")
            }
        }
    }
    
    private func load() {
        let all = session.dataRepository.letters
        let filtered = all.filter { vowelOrder.contains($0.character) }
        vowels = filtered.sorted { a, b in
            guard let ia = vowelOrder.firstIndex(of: a.character), let ib = vowelOrder.firstIndex(of: b.character) else { return false }
            return ia < ib
        }
    }
    
    private func quizCard(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .frame(height: 90)
    }
}