import SwiftUI

struct DailyMissionsCard: View {
    let mission: DailyMission
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: mission.iconName)
                .font(.title)
                .foregroundColor(.accentColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(mission.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(mission.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ProgressView(value: Double(mission.progress), total: Double(mission.goal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                
                Text("\(mission.progress) / \(mission.goal)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(mission.xpReward)")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
