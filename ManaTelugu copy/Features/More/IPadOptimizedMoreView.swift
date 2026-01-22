import SwiftUI

// MARK: - iPad-Optimized More View
/// Adapts More/Settings screen for iPad with:
/// - Sidebar navigation on iPad (split view)
/// - Multi-column grid layout for options
/// - Larger touch targets and better spacing
/// - Optimized for landscape orientation
struct IPadOptimizedMoreView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedSection: String = "profile"
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.9),
                    Color(red: 0.4, green: 0.2, blue: 0.8),
                    Color(red: 0.8, green: 0.3, blue: 0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all, edges: .all)
            
            if horizontalSizeClass == .regular {
                // iPad: Split view layout
                iPadSplitLayout
            } else {
                // iPhone: Standard scroll layout
                iPhoneLayout
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - iPad Split View Layout
    /// iPad-optimized split view layout with sidebar menu and section content
    /// Replaces List(selection:) with custom VStack for iOS 15+ compatibility
    private var iPadSplitLayout: some View {
        NavigationSplitView {
            // Sidebar: Menu Options (custom VStack instead of List for compatibility)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Account Section
                    sidebarSection(title: "Account") {
                        sidebarMenuItem(
                            label: "Profile Settings",
                            icon: "person.crop.circle",
                            isSelected: selectedSection == "profile"
                        ) { selectedSection = "profile" }
                        
                        sidebarMenuItem(
                            label: "Progress Dashboard",
                            icon: "chart.bar.fill",
                            isSelected: selectedSection == "progress"
                        ) { selectedSection = "progress" }
                    }
                    
                    // Learning Section
                    sidebarSection(title: "Learning") {
                        sidebarMenuItem(
                            label: "Achievements",
                            icon: "star.fill",
                            isSelected: selectedSection == "achievements"
                        ) { selectedSection = "achievements" }
                        
                        sidebarMenuItem(
                            label: "Statistics",
                            icon: "chart.line.uptrend.xyaxis",
                            isSelected: selectedSection == "statistics"
                        ) { selectedSection = "statistics" }
                    }
                    
                    // Support Section
                    sidebarSection(title: "Support") {
                        sidebarMenuItem(
                            label: "Help & FAQ",
                            icon: "questionmark.circle.fill",
                            isSelected: selectedSection == "help"
                        ) { selectedSection = "help" }
                        
                        sidebarMenuItem(
                            label: "Contact Us",
                            icon: "envelope.fill",
                            isSelected: selectedSection == "contact"
                        ) { selectedSection = "contact" }
                    }
                    
                    // About Section
                    sidebarSection(title: "About") {
                        sidebarMenuItem(
                            label: "About This App",
                            icon: "info.circle.fill",
                            isSelected: selectedSection == "about"
                        ) { selectedSection = "about" }
                        
                        sidebarMenuItem(
                            label: "Privacy Policy",
                            icon: "hand.raised.fill",
                            isSelected: selectedSection == "privacy"
                        ) { selectedSection = "privacy" }
                        
                        sidebarMenuItem(
                            label: "Terms of Service",
                            icon: "doc.text.fill",
                            isSelected: selectedSection == "terms"
                        ) { selectedSection = "terms" }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
            }
            .background(Color(.systemGray6))
            .navigationTitle("More Options")
        } detail: {
            // Detail: Section Content
            sectionContent(for: selectedSection)
                .navigationTitle(sectionTitle(for: selectedSection))
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // MARK: - Sidebar Helper Methods
    /// Creates a sidebar section with title and menu items
    /// - Parameters:
    ///   - title: Section title
    ///   - content: Menu items in this section
    @ViewBuilder
    private func sidebarSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            
            content()
        }
    }
    
    /// Creates a sidebar menu item button
    /// - Parameters:
    ///   - label: Button text
    ///   - icon: SF Symbol icon name
    ///   - isSelected: Whether this item is currently selected
    ///   - action: Closure to execute when tapped
    private func sidebarMenuItem(
        label: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 20)
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(label)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
    }
    
    // MARK: - iPhone Standard Layout
    private var iPhoneLayout: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("More Options")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Manage your profile, settings, and get support")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                    )
                    
                    // Account Section
                    sectionGroup(
                        title: "Account",
                        items: [
                            ("person.crop.circle", "Profile Settings"),
                            ("chart.bar.fill", "Progress Dashboard")
                        ]
                    )
                    
                    // Learning Section
                    sectionGroup(
                        title: "Learning",
                        items: [
                            ("star.fill", "Achievements"),
                            ("chart.line.uptrend.xyaxis", "Statistics")
                        ]
                    )
                    
                    // Support Section
                    sectionGroup(
                        title: "Support",
                        items: [
                            ("questionmark.circle.fill", "Help & FAQ"),
                            ("envelope.fill", "Contact Us")
                        ]
                    )
                    
                    // About Section
                    sectionGroup(
                        title: "About",
                        items: [
                            ("info.circle.fill", "About This App"),
                            ("hand.raised.fill", "Privacy Policy"),
                            ("doc.text.fill", "Terms of Service")
                        ]
                    )
                    
                    Color.clear.frame(height: 20)
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Section Group Helper
    private func sectionGroup(title: String, items: [(icon: String, label: String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(items, id: \.label) { item in
                    NavigationLink(destination: EmptyView()) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.15))
                                )
                            
                            Text(item.label)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
        )
    }
    
    // MARK: - Section Content View
    @ViewBuilder
    private func sectionContent(for section: String) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                switch section {
                case "profile":
                    profileContent
                case "progress":
                    progressContent
                case "achievements":
                    achievementsContent
                case "statistics":
                    statisticsContent
                case "help":
                    helpContent
                case "contact":
                    contactContent
                case "about":
                    aboutContent
                case "privacy":
                    privacyContent
                case "terms":
                    termsContent
                default:
                    EmptyView()
                }
                
                Color.clear.frame(height: 20)
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Content Sections
    private var profileContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Profile Settings")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                settingRow(label: "Name", value: session.userProfile.name)
                settingRow(label: "Email", value: "user@manatelugu.com")
                settingRow(label: "Learning Level", value: "Beginner")
                settingRow(label: "Preferred Language", value: "English")
            }
        }
    }
    
    private var progressContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Dashboard")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                progressMetric(label: "Lessons Completed", value: "\(session.progressTrackingService.completedLessonsCount)")
                progressMetric(label: "Total XP", value: "\(session.userProfile.totalXP)")
                progressMetric(label: "Current Streak", value: "\(session.userProfile.currentStreak) days")
                progressMetric(label: "Total Study Time", value: "24 hours")
            }
        }
    }
    
    private var achievementsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("You have earned \(session.gamificationService.gamificationState.badges.count) badges!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            // Badges Grid
            let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<6, id: \.self) { _ in
                    VStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.yellow)
                        
                        Text("Badge")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                }
            }
        }
    }
    
    private var statisticsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Statistics")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                statisticRow(label: "Letters Learned", value: "36/49", percentage: 0.73)
                statisticRow(label: "Words Learned", value: "124", percentage: 0.62)
                statisticRow(label: "Games Played", value: "45", percentage: 0.80)
                statisticRow(label: "Lessons Completed", value: "12/20", percentage: 0.60)
            }
        }
    }
    
    private var helpContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Help & FAQ")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                faqItem(question: "How do I reset my progress?", answer: "Go to Settings and select 'Reset Progress'")
                faqItem(question: "Can I sync across devices?", answer: "Yes, sign in with your account to sync")
                faqItem(question: "How do I unlock new lessons?", answer: "Complete previous lessons to unlock new ones")
            }
        }
    }
    
    private var contactContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Us")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                contactMethod(icon: "envelope.fill", label: "Email", value: "support@manatelugu.com")
                contactMethod(icon: "globe", label: "Website", value: "www.manatelugu.com")
                contactMethod(icon: "bubble.left.fill", label: "Support Chat", value: "Available 24/7")
            }
        }
    }
    
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Mana Telugu")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Mana Telugu is an interactive learning app designed to help you master the Telugu language through engaging lessons, games, and interactive exercises.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            VStack(spacing: 12) {
                aboutRow(label: "Version", value: "1.0.0")
                aboutRow(label: "Build", value: "2024.1")
                aboutRow(label: "Developer", value: "Mana Telugu Team")
            }
        }
    }
    
    private var privacyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Privacy Policy")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("We respect your privacy and are committed to protecting your personal data...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var termsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Terms of Service")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("By using Mana Telugu, you agree to these terms and conditions...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    // MARK: - Helper Views
    private func settingRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private func progressMetric(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private func statisticRow(label: String, value: String, percentage: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green)
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private func faqItem(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Text(answer)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private func contactMethod(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private func aboutRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Helper Methods
    private func sectionTitle(for section: String) -> String {
        switch section {
        case "profile":
            return "Profile Settings"
        case "progress":
            return "Progress Dashboard"
        case "achievements":
            return "Achievements"
        case "statistics":
            return "Statistics"
        case "help":
            return "Help & FAQ"
        case "contact":
            return "Contact Us"
        case "about":
            return "About This App"
        case "privacy":
            return "Privacy Policy"
        case "terms":
            return "Terms of Service"
        default:
            return "More Options"
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedMoreView()
        .environmentObject(AppSession())
}
