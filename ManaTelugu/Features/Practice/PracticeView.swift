import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var session: AppSession
    @State private var practiceItems: [PracticeItem] = []
    
    struct PracticeItem: Identifiable {
        let id = UUID()
        let telugu: String
        let transliteration: String
        let english: String
        let audioFile: String
        var difficulty: Difficulty = .unknown
    }
    
    enum Difficulty {
        case easy, medium, hard, unknown
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: MTSpacing.large) {
                    Text("Practice")
                        .font(MTTypography.title())
                        .foregroundColor(MTColors.text)
                        .padding(.horizontal)
                    
                    // Quick games hub
                    VStack(spacing: MTSpacing.medium) {
                        NavigationLink {
                            SoundMatchGameView()
                        } label: { hubCard(title: "Sound Match", subtitle: "Match letters to sounds", icon: "waveform") }
                        NavigationLink {
                            CardMatchGameView()
                        } label: { hubCard(title: "Card Match", subtitle: "Memory match game", icon: "rectangle.on.rectangle") }
                        NavigationLink {
                            TraceGameView()
                        } label: { hubCard(title: "Tracing Practice", subtitle: "Trace Telugu letters", icon: "pencil.tip") }
                    }
                    .padding(.horizontal)
                    
                    // Quizzes section
                    VStack(alignment: .leading, spacing: MTSpacing.small) {
                        Text("Quizzes")
                            .font(MTTypography.heading())
                            .foregroundColor(MTColors.text)
                        
                        VStack(spacing: MTSpacing.medium) {
                            NavigationLink { LettersQuizView(scope: .vowels) } label: { hubCard(title: "Vowels Quiz", subtitle: "అ ఆ ఇ ఈ ...", icon: "textformat") }
                            NavigationLink { LettersQuizView(scope: .consonants) } label: { hubCard(title: "Consonants Quiz", subtitle: "క నుండి క్ష వరకు", icon: "textformat.abc") }
                            NavigationLink { LettersQuizView(scope: .all) } label: { hubCard(title: "All Letters Quiz", subtitle: "Mixed practice", icon: "square.grid.2x2") }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Placeholder for Speaking (to be developed)
                    VStack(alignment: .leading, spacing: MTSpacing.small) {
                        Text("Speaking (coming soon)")
                            .font(MTTypography.heading())
                            .foregroundColor(MTColors.text)
                        hubCard(title: "Pronunciation Drills", subtitle: "Record and compare pronunciation", icon: "mic")
                            .padding(.horizontal)
                            .opacity(0.6)
                    }
                    
                    Spacer(minLength: MTSpacing.large)
                }
                .padding(.vertical)
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadPracticeItems()
        }
        .tabItem {
            Image(systemName: "book")
            Text("Practice")
        }
    }
    
    private func loadPracticeItems() {
        // Load a mix of letters and words for practice
        let letters = session.dataRepository.letters().prefix(5)
        let words = session.dataRepository.words().prefix(5)
        
        var items: [PracticeItem] = []
        
        for letter in letters {
            items.append(PracticeItem(
                telugu: letter.glyph,
                transliteration: letter.transliteration,
                english: letter.name,
                audioFile: letter.audioFile
            ))
        }
        
        for word in words {
            items.append(PracticeItem(
                telugu: word.telugu,
                transliteration: word.transliteration,
                english: word.english,
                audioFile: word.audioFile
            ))
        }
        
        practiceItems = items
    }
}

private func hubCard(title: String, subtitle: String, icon: String) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 14)
            .fill(MTColors.surfaceAlt)
            .frame(height: 80)
        HStack(spacing: MTSpacing.medium) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(MTColors.primary)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(MTTypography.heading())
                    .foregroundColor(MTColors.text)
                Text(subtitle)
                    .font(MTTypography.caption())
                    .foregroundColor(MTColors.text.opacity(0.7))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(MTColors.text.opacity(0.5))
        }
        .padding(.horizontal)
    }
}

struct PracticeItemView: View {
    @EnvironmentObject var session: AppSession
    let item: PracticeView.PracticeItem
    @State private var showingOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.small) {
            Text(item.telugu)
                .font(.title)
                .foregroundColor(MTColors.text)
            
            Text(item.transliteration)
                .font(MTTypography.body())
                .foregroundColor(MTColors.text.opacity(0.8))
            
            if showingOptions {
                Text(item.english)
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text)
                    .padding(.bottom, MTSpacing.small)
                
                HStack {
                    Button(action: {
                        // Mark as hard
                        session.hapticsService.warning()
                    }) {
                        Text("Hard")
                            .font(MTTypography.caption())
                            .padding(.horizontal, MTSpacing.large)
                            .padding(.vertical, MTSpacing.small)
                            .background(MTColors.warning)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Mark as medium
                        session.hapticsService.lightImpact()
                    }) {
                        Text("Okay")
                            .font(MTTypography.caption())
                            .padding(.horizontal, MTSpacing.large)
                            .padding(.vertical, MTSpacing.small)
                            .background(MTColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Mark as easy
                        session.hapticsService.success()
                    }) {
                        Text("Easy")
                            .font(MTTypography.caption())
                            .padding(.horizontal, MTSpacing.large)
                            .padding(.vertical, MTSpacing.small)
                            .background(MTColors.success)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .padding()
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
        .onTapGesture {
            withAnimation {
                showingOptions.toggle()
            }
        }
    }
}