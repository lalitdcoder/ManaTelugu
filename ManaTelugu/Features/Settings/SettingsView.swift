import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingExportSheet = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                // App Preferences
                Section("App Preferences") {
                    Toggle("Kid Mode", isOn: $session.userProfile.kidMode)
                        .onChange(of: session.userProfile.kidMode) { _, newValue in
                            // Handle kid mode change
                        }
                    
                    Toggle("Sound Effects", isOn: .constant(true))
                    
                    Toggle("Haptic Feedback", isOn: .constant(true))
                }
                
                // Progress
                Section("Progress") {
                    Button(action: {
                        showingExportSheet = true
                    }) {
                        Text("Export Progress")
                            .foregroundColor(MTColors.primary)
                    }
                    
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        Text("Reset Progress")
                            .foregroundColor(.red)
                    }
                }
                
                // About
                Section("About") {
                    Button(action: {
                        // Parental gate would go here
                        if let url = URL(string: "mailto:support@manatelugu.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Contact Support")
                            .foregroundColor(MTColors.primary)
                    }
                    
                    Text("Version 1.0")
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
            }
        }
        .confirmationDialog("Reset Progress", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
            Button("Reset All Progress", role: .destructive) {
                resetProgress()
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to reset all your learning progress?")
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportProgressView()
        }
    }
    
    private func resetProgress() {
        // Reset all progress
        session.userProfile.streakDays = 0
        session.userProfile.totalXP = 0
        session.userProfile.lastOpened = nil
        session.hapticsService.success()
    }
}

struct ExportProgressView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: MTSpacing.large) {
                Text("Export Progress")
                    .font(MTTypography.title())
                    .foregroundColor(MTColors.text)
                
                Text("Your progress data will be exported as a JSON file that you can share or save.")
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Sample data preview
                ScrollView {
                    Text(sampleProgressData())
                        .font(.caption)
                        .foregroundColor(MTColors.text)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(MTColors.surfaceAlt)
                        .cornerRadius(8)
                }
                
                Button(action: exportProgress) {
                    Text("Export as JSON")
                        .font(MTTypography.body())
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(MTColors.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sampleProgressData() -> String {
        return """
        {
          "streakDays": 5,
          "totalXP": 1250,
          "lastOpened": "2025-08-28T10:30:00Z",
          "lettersMastered": 18,
          "wordsLearned": 42,
          "badgesEarned": 3
        }
        """
    }
    
    private func exportProgress() {
        // Create sample data
        _ = sampleProgressData()
        
        // In a real app, we would create a file and share it
        // For now, we'll just show an alert
        let alert = UIAlertController(title: "Progress Exported", message: "Your progress data has been exported successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Show alert (we would need to get the root view controller)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let root = window.rootViewController {
            root.present(alert, animated: true)
        }
    }
}
