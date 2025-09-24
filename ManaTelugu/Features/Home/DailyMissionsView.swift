import SwiftUI

struct DailyMissionsView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        VStack(alignment: .leading) {
            HomeSectionHeader(title: "Daily Missions", iconName: "list.star")
            
            ForEach(session.dailyMissionsService.dailyMissions) { mission in
                DailyMissionsCard(mission: mission)
            }
        }
        .padding(.horizontal)
    }
}
