import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingExportSheet = false
    @State private var showingResetConfirmation = false
    @State private var isParentalGateUnlocked = false
    
    // Settings state
    @State private var soundEffectsEnabled = true
    @State private var hapticFeedbackEnabled = true
    @State private var darkModeEnabled = false
    @State private var showingExportSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Settings Sections
                        audioSection
                        appSection
                        dataSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text("Customize your learning experience")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .elegantCard()
    }
    
    private var audioSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Audio & Feedback")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            settingToggle("Sound Effects", $soundEffectsEnabled, "speaker.wave.2.fill")
            settingToggle("Haptic Feedback", $hapticFeedbackEnabled, "iphone.radiowaves.left.and.right")
        }
        .elegantCard()
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Appearance")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            settingToggle("Dark Mode", $darkModeEnabled, "moon.fill")
        }
        .elegantCard()
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Data Management")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Button(action: { showingExportSheet = true }) {
                settingButton("Export Progress", "square.and.arrow.up", ElegantDesign.Colors.primary)
            }
            
            Button(action: { showingResetConfirmation = true }) {
                settingButton("Reset Progress", "trash.fill", .red)
            }
        }
        .elegantCard()
    }
    
    private func settingToggle(_ title: String, _ binding: Binding<Bool>, _ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ElegantDesign.Colors.primary)
                .frame(width: 24)
            
            Text(title)
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: binding)
                .tint(ElegantDesign.Colors.primary)
        }
        .padding(.vertical, ElegantDesign.Spacing.xs)
    }
    
    private func settingButton(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ElegantDesign.Colors.textTertiary)
        }
        .padding(.vertical, ElegantDesign.Spacing.xs)
    }
}
