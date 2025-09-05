import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedGame: Int? = nil
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funGreen.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    Text("Game Zone")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .padding(.horizontal)
                    Text("Make learning fun with these interactive games")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                        .padding(.horizontal)
                    // Game Cards
                    VStack(spacing: 24) {
                        GameSectionCard(
                            title: "Vocabulary Match",
                            icon: "rectangle.stack.fill",
                            accent: MTColors.funBlue,
                            action: { selectedGame = 0 },
                            content: {
                                Text("Match Telugu words with their English meanings.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                        GameSectionCard(
                            title: "Sentence Builder",
                            icon: "text.bubble.fill",
                            accent: MTColors.funGreen,
                            action: { selectedGame = 1 },
                            content: {
                                Text("Build Telugu sentences by arranging words correctly.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                        GameSectionCard(
                            title: "Listening Challenge",
                            icon: "ear.fill",
                            accent: MTColors.funPink,
                            action: { selectedGame = 2 },
                            content: {
                                Text("Listen to Telugu words and choose the right meaning.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                        GameSectionCard(
                            title: "Sound Match",
                            icon: "speaker.wave.2.fill",
                            accent: MTColors.funYellow,
                            action: { selectedGame = 3 },
                            content: {
                                Text("Listen to the sound and pick the right letter or word.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                        GameSectionCard(
                            title: "Card Match",
                            icon: "arrow.left.arrow.right",
                            accent: MTColors.funBlue,
                            action: { selectedGame = 4 },
                            content: {
                                Text("Match Telugu words to their English meanings.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                        GameSectionCard(
                            title: "Trace Letters",
                            icon: "pencil.tip",
                            accent: MTColors.funGreen,
                            action: { selectedGame = 5 },
                            content: {
                                Text("Practice writing letters by tracing them.")
                                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                                    .foregroundColor(MTColors.text)
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            // NavigationLinks for each game
            NavigationLink(destination: VocabularyCardsView(theme: "Animals").environmentObject(session), tag: 0, selection: $selectedGame) { EmptyView() }.hidden()
            NavigationLink(destination: SentenceBuilderGameView().environmentObject(session), tag: 1, selection: $selectedGame) { EmptyView() }.hidden()
            NavigationLink(destination: ListeningChallengeGameView().environmentObject(session), tag: 2, selection: $selectedGame) { EmptyView() }.hidden()
            NavigationLink(destination: SoundMatchGameView().environmentObject(session), tag: 3, selection: $selectedGame) { EmptyView() }.hidden()
            NavigationLink(destination: CardMatchGameView().environmentObject(session), tag: 4, selection: $selectedGame) { EmptyView() }.hidden()
            NavigationLink(destination: TraceGameView().environmentObject(session), tag: 5, selection: $selectedGame) { EmptyView() }.hidden()
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarIcon(systemName: "house.fill", selected: false)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarIcon(systemName: "star.fill", selected: false)
            }
        }
    }
}

// MARK: - Game Section Card
struct GameSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let accent: Color
    let action: () -> Void
    let content: () -> Content
    @EnvironmentObject var session: AppSession
    @State private var isPressed = false
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { isPressed = false }
        }) {
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(accent.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(accent)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    content()
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundColor(MTColors.text.opacity(0.3))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: accent.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 4, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}
// Reuse NavBarIcon from HomeView