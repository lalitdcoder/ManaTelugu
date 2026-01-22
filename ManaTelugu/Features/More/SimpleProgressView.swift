import SwiftUI

struct SimpleProgressView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
                
            ScrollView {
                VStack(spacing: 20) {
                    // XP Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Experience Points")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("\(session.gamificationService.gamificationState.totalXP)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.professionalBlue)
                            
                            Text("XP")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .professionalBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Streak Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Learning Streak")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("\(session.gamificationService.gamificationState.streakCount)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.professionalOrange)
                            
                            Text("days")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .professionalOrange.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Badges Count
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Badges Earned")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("\(session.gamificationService.gamificationState.badges.filter { $0.isUnlocked }.count)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.professionalGreen)
                            
                            Text("badges")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .professionalGreen.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding()
            }
        }
        .navigationTitle("Progress Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }
}
