import SwiftUI

struct AlphabetGridView: View {
    @EnvironmentObject var session: AppSession
    @State private var letters: [Letter] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MTSpacing.medium) {
                Text("Alphabet")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .padding(.horizontal)
                
                Text("Learn the Telugu script and sounds")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: MTSpacing.small), count: 4), spacing: MTSpacing.small) {
                    ForEach(letters) { letter in
                        NavigationLink {
                            LetterDetailView(letter: letter)
                        } label: {
                            LetterCardView(letter: letter)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            letters = session.dataRepository.letters()
        }
        .navigationTitle("Alphabet")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct LetterCardView: View {
    @EnvironmentObject var session: AppSession
    let letter: Letter
    
    var body: some View {
        VStack(spacing: MTSpacing.tiny) {
            Text(letter.glyph)
                .font(.title)
                .foregroundColor(MTColors.text)
            
            Text(letter.transliteration)
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text.opacity(0.7))
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
    }
}