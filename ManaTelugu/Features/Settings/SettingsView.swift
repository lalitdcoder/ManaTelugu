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
                // Global animated background - ensure it covers entire screen
                LinearGradient(
                    colors: [RefinedColors.background, RefinedColors.secondaryBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                EnhancedScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Enhanced Header
                        UnifiedLiquidGlassCard(
                            layer: .content,
                            intensity: 0.25,
                            cornerRadius: 28,
                            padding: 24,
                            isInteractive: false
                        ) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    PulsingIcon(iconName: "gearshape.fill", color: RefinedColors.warmYellow, size: 24)
                                    Text("Settings")
                                        .font(EnhancedTypography.welcomeTitle)
                                        .foregroundColor(RefinedColors.charcoal)
                                    Spacer()
                                }
                                
                                Text("Customize your learning experience")
                                    .font(EnhancedTypography.bodyText)
                                    .foregroundColor(RefinedColors.mediumGray)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // App Preferences Section
                        UnifiedLiquidGlassCard(
                            layer: .content,
                            intensity: 0.15,
                            cornerRadius: 24,
                            padding: 0,
                            isInteractive: false
                        ) {
                            EnhancedSettingsSection(
                                title: "App Preferences",
                                icon: "gearshape.fill",
                                accent: RefinedColors.warmYellow
                            ) {
                                VStack(spacing: 16) {
                                    LiquidGlassToggle(
                                        title: "Sound Effects", 
                                        isOn: $soundEffectsEnabled
                                    )
                                    LiquidGlassToggle(
                                        title: "Haptic Feedback", 
                                        isOn: $hapticFeedbackEnabled
                                    )
                                    LiquidGlassToggle(
                                        title: "Dark Mode", 
                                        isOn: $darkModeEnabled
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Parent Mode Section
                        UnifiedLiquidGlassCard(
                            layer: .content,
                            intensity: 0.15,
                            cornerRadius: 24,
                            padding: 0,
                            isInteractive: false
                        ) {
                            EnhancedSettingsSection(
                                title: "Parent Mode",
                                icon: "person.2.fill",
                                accent: RefinedColors.softGreen
                            ) {
                                NavigationLink(destination: ParentalGateView(isUnlocked: $isParentalGateUnlocked)) {
                                    HStack {
                                        Text("Access Parent Dashboard")
                                            .font(EnhancedTypography.cardTitle)
                                            .foregroundColor(RefinedColors.charcoal)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(RefinedColors.mediumGray)
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Progress Section
                        UnifiedLiquidGlassCard(
                            layer: .content,
                            intensity: 0.15,
                            cornerRadius: 24,
                            padding: 0,
                            isInteractive: false
                        ) {
                            EnhancedSettingsSection(
                                title: "Progress",
                                icon: "chart.bar.fill",
                                accent: RefinedColors.softGreen
                            ) {
                                VStack(spacing: 12) {
                                    LiquidGlassButton(
                                        title: "Export Progress"
                                    ) {
                                        showingExportSheet = true
                                    }
                                    LiquidGlassButton(
                                        title: "Reset Progress"
                                    ) {
                                        showingResetConfirmation = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // About Section
                        UnifiedLiquidGlassCard(
                            layer: .content,
                            intensity: 0.15,
                            cornerRadius: 24,
                            padding: 0,
                            isInteractive: false
                        ) {
                            EnhancedSettingsSection(
                                title: "About",
                                icon: "info.circle.fill",
                                accent: RefinedColors.mediumGray
                            ) {
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Version")
                                            .font(EnhancedTypography.bodyText)
                                            .foregroundColor(RefinedColors.charcoal)
                                        Spacer()
                                        Text("1.0.0")
                                            .font(EnhancedTypography.bodyText)
                                            .foregroundColor(RefinedColors.mediumGray)
                                    }
                                    
                                    HStack {
                                        Text("Build")
                                            .font(EnhancedTypography.bodyText)
                                            .foregroundColor(RefinedColors.charcoal)
                                        Spacer()
                                        Text("2024.1")
                                            .font(EnhancedTypography.bodyText)
                                            .foregroundColor(RefinedColors.mediumGray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Bottom padding to prevent overlap
                        Spacer(minLength: 120)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationDestination(isPresented: $isParentalGateUnlocked) {
                ParentDashboardView()
            }
            .navigationTitle("Settings")
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .overlay(
                GlobalAlert(
                    title: "Reset Progress",
                    message: "Are you sure you want to reset all your learning progress? This action cannot be undone.",
                    primaryButton: GlobalAlert.AlertButton(
                        title: "Reset All Progress",
                        style: .destructive,
                        action: { resetProgress() }
                    ),
                    secondaryButton: GlobalAlert.AlertButton(
                        title: "Cancel",
                        style: .secondary,
                        action: { }
                    ),
                    isPresented: $showingResetConfirmation
                )
            )
            .sheet(isPresented: $showingExportSheet) {
                ExportProgressView()
            }
        }
    }
    
    private func resetProgress() {
        // Reset the gamification state
        session.gamificationService.gamificationState = GamificationState()
        session.hapticsService.success()
        
        // Show success feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Could add a success alert here
        }
    }
    
    private func toggleSoundEffects() {
        if hapticFeedbackEnabled {
            session.hapticsService.lightImpact()
        }
        // In a real app, you'd save this to UserDefaults
        print("Sound Effects: \(soundEffectsEnabled ? "Enabled" : "Disabled")")
    }
    
    private func toggleHapticFeedback() {
        if hapticFeedbackEnabled {
            session.hapticsService.lightImpact()
        }
        // In a real app, you'd save this to UserDefaults
        print("Haptic Feedback: \(hapticFeedbackEnabled ? "Enabled" : "Disabled")")
    }
    
    private func toggleDarkMode() {
        if hapticFeedbackEnabled {
            session.hapticsService.lightImpact()
        }
        // In a real app, you'd save this to UserDefaults and apply theme
        print("Dark Mode: \(darkModeEnabled ? "Enabled" : "Disabled")")
    }
}

// MARK: - Progress Export Data
struct ProgressExportData: Codable {
    let exportDate: String
    let totalXP: Int
    let currentLevel: Int
    let levelName: String
    let levelTeluguName: String
    let progressToNextLevel: Double
    let streakCount: Int
    let badgesUnlocked: Int
    let storiesCompleted: Int
    let lessonsCompleted: Int
    let wordsLearned: Int
    let appVersion: String
}

// MARK: - Enhanced Settings Section
struct EnhancedSettingsSection: View {
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
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(accent)
                Text(title)
                    .font(EnhancedTypography.sectionTitle)
                    .foregroundColor(RefinedColors.charcoal)
                Spacer()
            }
            
            content
        }
        .padding(24)
    }
}

// MARK: - Enhanced Toggle
struct EnhancedToggle: View {
    let label: String
    @Binding var isOn: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(EnhancedTypography.cardTitle)
                .foregroundColor(RefinedColors.charcoal)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(RefinedColors.softGreen)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .onChange(of: isOn) {
                    // Trigger action when toggle changes
                    action()
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.1)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isPressed = false
                        }
                    }
                }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Enhanced Settings Button
struct EnhancedSettingsButton: View {
    let label: String
    let icon: String
    let action: () -> Void
    var isDestructive: Bool = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
            
            // Press animation
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            
            // Execute action
            action()
            
            // Reset animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isDestructive ? .red : RefinedColors.softGreen)
                
                Text(label)
                    .font(EnhancedTypography.cardTitle)
                    .foregroundColor(isDestructive ? .red : RefinedColors.charcoal)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(RefinedColors.mediumGray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDestructive ? Color.red.opacity(0.1) : Color.white.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Export Progress View
struct ExportProgressView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationView {
            ZStack {
                // Global animated background - ensure it covers entire screen
                LinearGradient(
                    colors: [RefinedColors.background, RefinedColors.secondaryBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 32) {
                    // Header
                    UnifiedLiquidGlassCard(
                        layer: .content,
                        intensity: 0.25,
                        cornerRadius: 28,
                        padding: 32,
                        isInteractive: false
                    ) {
                        VStack(spacing: 20) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(RefinedColors.softGreen)
                            
                            Text("Export Progress")
                                .font(EnhancedTypography.welcomeTitle)
                                .foregroundColor(RefinedColors.charcoal)
                            
                            Text("Your learning progress data will be exported as a JSON file that you can save or share.")
                                .font(EnhancedTypography.bodyText)
                                .foregroundColor(RefinedColors.mediumGray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Export Button
                    GlobalInteractiveButton(
                        title: "Export Data"
                    ) {
                        exportProgress()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Export Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(EnhancedTypography.cardTitle)
                    .foregroundColor(RefinedColors.charcoal)
                }
            }
        }
    }
    
    private func exportProgress() {
        // Haptic feedback
        session.hapticsService.success()
        
        // Create progress data
        let progressData = createProgressData()
        
        // Convert to JSON
        if let jsonData = try? JSONEncoder().encode(progressData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            // In a real app, you'd use UIActivityViewController to share the file
            // For now, we'll just print it and show success
            print("Exported Progress Data:")
            print(jsonString)
            
            // Show success feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Could show a success alert here
                print("✅ Progress exported successfully!")
            }
        }
    }
    
    private func createProgressData() -> ProgressExportData {
        let gamificationState = session.gamificationService.gamificationState
        
        // Calculate actual completion counts
        let storiesCompleted = session.storyService.stories.filter { $0.isCompleted }.count
        let lessonsCompleted = session.lessonsRepository.levels.flatMap { $0.lessons }.filter { session.lessonsRepository.isLessonCompleted($0.id) }.count
        let wordsLearned = gamificationState.xpHistory.filter { $0.type == .wordLearned }.count
        
        return ProgressExportData(
            exportDate: ISO8601DateFormatter().string(from: Date()),
            totalXP: gamificationState.totalXP,
            currentLevel: gamificationState.currentLevel.level,
            levelName: gamificationState.currentLevel.name,
            levelTeluguName: gamificationState.currentLevel.teluguName,
            progressToNextLevel: gamificationState.progressToNextLevel,
            streakCount: gamificationState.streakCount,
            badgesUnlocked: gamificationState.badges.count,
            storiesCompleted: storiesCompleted,
            lessonsCompleted: lessonsCompleted,
            wordsLearned: wordsLearned,
            appVersion: "1.0.0"
        )
    }
}
