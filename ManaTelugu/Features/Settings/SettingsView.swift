import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingExportSheet = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
        ZStack {
            // Gentle pastel background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.97, green: 0.98, blue: 1.0), MTColors.funBlue.opacity(0.10), MTColors.funGreen.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    Text("Settings")
                        .font(MTTypography.title())
                        .foregroundColor(MTColors.text)
                        .padding(.horizontal)
                    
                    // App Preferences Section
                    SettingsSection(title: "App Preferences", icon: "gearshape.fill", accent: MTColors.funBlue) {
                        ModernToggle(label: "Sound Effects", isOn: .constant(true))
                        ModernToggle(label: "Haptic Feedback", isOn: .constant(true))
                    }
                    
                    // Progress Section
                    SettingsSection(title: "Progress", icon: "chart.bar.fill", accent: MTColors.funGreen) {
                        SettingsButton(label: "Export Progress", action: { showingExportSheet = true })
                        SettingsButton(label: "Reset Progress", action: { showingResetConfirmation = true }, isDestructive: true)
                    }
                    
                    // About Section
                    SettingsSection(title: "About", icon: "info.circle.fill", accent: MTColors.funPink) {
                        HStack {
                            Text("Version 1.0")
                                .font(MTTypography.body())
                                .foregroundColor(MTColors.text.opacity(0.7))
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)
            }
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
        .confirmationDialog("Reset Progress", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
            Button("Reset All Progress", role: .destructive) { resetProgress() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to reset all your learning progress?")
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportProgressView()
        }
    }
    
    private func resetProgress() {
        session.userProfile.streakDays = 0
        session.userProfile.totalXP = 0
        session.userProfile.lastOpened = nil
        session.hapticsService.success()
    }
}

// MARK: - Settings Section
struct SettingsSection: View {
    let title: String
    let icon: String
    let accent: Color
    let content: AnyView
    
    init<Content: View>(title: String, icon: String, accent: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.accent = accent
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(accent)
                Text(title)
                    .font(MTTypography.heading())
                    .foregroundColor(MTColors.text)
            }
            VStack(spacing: 8) {
                content
            }
            .padding()
            .background(Color.white.opacity(0.95))
            .cornerRadius(16)
            .shadow(color: accent.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

// MARK: - Modern Toggle
struct ModernToggle: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
                .font(MTTypography.body())
                .foregroundColor(MTColors.text)
        }
        .tint(MTColors.funGreen)
    }
}

// MARK: - Settings Button
struct SettingsButton: View {
    let label: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(MTTypography.body())
                    .foregroundColor(isDestructive ? .red : MTColors.funBlue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray.opacity(0.4))
            }
        }
    }
}

// MARK: - Export Progress View
struct ExportProgressView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(MTColors.funBlue)
                
                Text("Export Progress")
                    .font(MTTypography.title())
                    .foregroundColor(MTColors.text)
                
                Text("Your learning progress data will be exported as a JSON file that you can save or share.")
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Export Data") {
                    exportProgress()
                }
                .buttonStyle(.borderedProminent)
                .tint(MTColors.funBlue)
                .controlSize(.large)
                
                Spacer()
            }
            .padding()
            .navigationTitle("")
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
    
    private func exportProgress() {
        // Simple export functionality - in a real app, you'd implement actual file export
        session.hapticsService.success()
        // For now, just show success feedback
    }
}
