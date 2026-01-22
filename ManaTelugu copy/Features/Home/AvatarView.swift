import SwiftUI

struct AvatarView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        let avatarStage = session.gamificationService.gamificationState.currentAvatarStage
        
        VStack {
            Text(avatarStage.imageName)
                .font(.system(size: 60))
            
            Text(avatarStage.name)
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(session.gamificationService.gamificationState.totalXP) XP")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
