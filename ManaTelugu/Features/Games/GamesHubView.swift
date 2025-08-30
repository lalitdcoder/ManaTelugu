import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MTSpacing.large) {
                Text("Games")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .padding(.horizontal)
                
                Text("Make learning fun with these interactive games")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .padding(.horizontal)
                
                // Sound Match Game
                NavigationLink {
                    SoundMatchGameView()
                } label: {
                    GameCardView(
                        title: "Sound Match",
                        description: "Listen to the sound and pick the right letter or word",
                        icon: "speaker.wave.2.fill",
                        color: MTColors.primary
                    )
                }
                
                // Card Match Game
                NavigationLink {
                    CardMatchGameView()
                } label: {
                    GameCardView(
                        title: "Card Match",
                        description: "Match Telugu words to their English meanings",
                        icon: "arrow.left.arrow.right",
                        color: MTColors.secondary
                    )
                }
                
                // Trace Game
                NavigationLink {
                    TraceGameView()
                } label: {
                    GameCardView(
                        title: "Trace Letters",
                        description: "Practice writing letters by tracing them",
                        icon: "pencil.tip",
                        color: MTColors.success
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct GameCardView: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(MTColors.surfaceAlt)
            
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: MTSpacing.small) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(MTColors.text)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(MTColors.text.opacity(0.5))
            }
            .padding()
        }
    }
}