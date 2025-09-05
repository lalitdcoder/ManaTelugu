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
            ZStack {
                // Apple-style background with subtle gradient
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Header - Apple-style with proper spacing
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Practice")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .accessibilityAddTraits(.isHeader)
                            Text("Sharpen your Telugu skills with targeted practice")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .accessibilityElement(children: .combine)
                        
                        // Games Section - Apple-style section header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                Text("Interactive Games")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                PracticeSectionCard(
                                    title: "Vocabulary Match",
                                    icon: "rectangle.stack.fill",
                                    accent: MTColors.funBlue,
                                    action: { },
                                    content: {
                                        Text("Match Telugu words with their English meanings.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(VocabularyCardsView(theme: "Animals").environmentObject(session))
                                )
                                
                                PracticeSectionCard(
                                    title: "Sentence Builder",
                                    icon: "text.bubble.fill",
                                    accent: MTColors.funGreen,
                                    action: { },
                                    content: {
                                        Text("Build Telugu sentences by arranging words correctly.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(SentenceBuilderGameView().environmentObject(session))
                                )
                                
                                PracticeSectionCard(
                                    title: "Listening Challenge",
                                    icon: "ear.fill",
                                    accent: MTColors.funPink,
                                    action: { },
                                    content: {
                                        Text("Listen to Telugu words and choose the right meaning.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(ListeningChallengeGameView().environmentObject(session))
                                )
                                
                                PracticeSectionCard(
                                    title: "Sound Match",
                                    icon: "speaker.wave.2.fill",
                                    accent: MTColors.funYellow,
                                    action: { },
                                    content: {
                                        Text("Listen to the sound and pick the right letter or word.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(SoundMatchGameView().environmentObject(session))
                                )
                                
                                PracticeSectionCard(
                                    title: "Card Match",
                                    icon: "arrow.left.arrow.right",
                                    accent: MTColors.funBlue,
                                    action: { },
                                    content: {
                                        Text("Memory match game with Telugu letters.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(CardMatchGameView().environmentObject(session))
                                )
                                
                                PracticeSectionCard(
                                    title: "Trace Letters",
                                    icon: "pencil.tip",
                                    accent: MTColors.funGreen,
                                    action: { },
                                    content: {
                                        Text("Practice writing letters by tracing them.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    },
                                    destination: AnyView(TraceGameView().environmentObject(session))
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Quizzes Section - Apple-style section header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                Text("Knowledge Quizzes")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                            PracticeSectionCard(
                                title: "Vowels Quiz",
                                icon: "textformat",
                                accent: MTColors.funYellow,
                                action: { },
                                content: {
                                    Text("Test your knowledge of Telugu vowels: అ ఆ ఇ ఈ...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                },
                                destination: AnyView(LettersQuizView(scope: .vowels).environmentObject(session))
                            )
                            
                            PracticeSectionCard(
                                title: "Consonants Quiz",
                                icon: "textformat.abc",
                                accent: MTColors.funBlue,
                                action: { },
                                content: {
                                    Text("Challenge yourself with consonants: క నుండి క్ష వరకు")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                },
                                destination: AnyView(LettersQuizView(scope: .consonants).environmentObject(session))
                            )
                            
                            PracticeSectionCard(
                                title: "Complete Letters Quiz",
                                icon: "square.grid.2x2",
                                accent: MTColors.funGreen,
                                action: { },
                                content: {
                                    Text("Mixed practice with all Telugu letters.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                },
                                destination: AnyView(LettersQuizView(scope: .all).environmentObject(session))
                            )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            Task {
                await loadPracticeItems()
            }
        }
        .tabItem {
            Image(systemName: "book")
            Text("Practice")
        }
    }
    
    private func loadPracticeItems() async {
        // Load a mix of letters and words for practice
        let letters = await session.dataRepository.letters().prefix(5)
        let words = await session.dataRepository.words().prefix(5)
        
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

// MARK: - Practice Section Card
struct PracticeSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let accent: Color
    let action: () -> Void
    let content: () -> Content
    let destination: AnyView
    @EnvironmentObject var session: AppSession
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                // Apple-style icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(accent)
                        .accessibilityHidden(true) // Icon is decorative
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    content()
                }
                
                Spacer()
                
                // Apple-style chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(.tertiaryLabel))
                    .accessibilityHidden(true) // Decorative indicator
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to start this practice activity")
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
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
