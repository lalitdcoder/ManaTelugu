import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingBadgeUnlock = false
    @State private var showingTreasureChest = false
    @State private var selectedTab = 0

    // Use the shared TabItem type (now only defined in EnhancedNavigation.swift)
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", view: AnyView(HomeView())),
        TabItem(title: "Alphabet", icon: "textformat.abc", view: AnyView(AlphabetHubView())),
        TabItem(title: "Lessons", icon: "book.fill", view: AnyView(LessonsHubView())),
        TabItem(title: "Stories", icon: "books.vertical.fill", view: AnyView(StorybookHubView())),
        TabItem(title: "Games", icon: "gamecontroller.fill", view: AnyView(GamesHubView())),
        TabItem(title: "More", icon: "ellipsis.circle.fill", view: AnyView(ProfessionalMoreView()))
    ]

    var body: some View {
        ZStack {
            // Professional gradient background
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

            // Main content with enhanced navigation
            EnhancedRootTabView()
                .environmentObject(session)
        }
        .onChange(of: session.gamificationService.newlyUnlockedBadges.isEmpty) {
            showingBadgeUnlock = !session.gamificationService.newlyUnlockedBadges.isEmpty
        }
        .onChange(of: session.gamificationService.treasureChestReward != nil) {
            showingTreasureChest = session.gamificationService.treasureChestReward != nil
        }
        .sheet(isPresented: $showingBadgeUnlock) {
            if let badge = session.gamificationService.newlyUnlockedBadges.first {
                BadgeUnlockedView(badge: badge) {
                    session.gamificationService.dismissNewlyUnlockedBadge()
                    showingBadgeUnlock = false
                }
            }
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(20)
        .sheet(isPresented: $showingTreasureChest) {
            if let reward = session.gamificationService.treasureChestReward {
                TreasureChestView(stickerReward: reward.sticker, xpReward: reward.xp) {
                    session.gamificationService.dismissTreasureChest()
                    showingTreasureChest = false
                }
            }
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(20)
    }
}

// MARK: - More View
struct MoreView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingProgress = false
    @State private var showingSettings = false
    @State private var showingHelp = false
    @State private var showingContact = false
    @State private var showingAbout = false
    @State private var showingParentalGate = false
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Professional gradient background
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

                // Enhanced scroll view with proper content spacing
                EnhancedScrollView(bottomPadding: 140) {
                    VStack(spacing: 32) {
                        // Refined Header Section
                        refinedHeaderSection

                        // Primary Options Section
                        primaryOptionsSection

                        // Secondary Options Section
                        secondaryOptionsSection

                        // Future-Proof Additional Section
                        additionalOptionsSection
                    }
                    .padding(.horizontal, 20)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                )
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
        .fullScreenCover(isPresented: $showingProgress) {
            ProgressDashboardView()
                .overlay(alignment: .topTrailing) {
                    Button("Done") {
                        showingProgress = false
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding()
                }
        }
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView()
                .overlay(alignment: .topTrailing) {
                    Button("Done") {
                        showingSettings = false
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding()
                }
        }
        .fullScreenCover(isPresented: $showingHelp) {
            HelpSupportView()
                .overlay(alignment: .topTrailing) {
                    Button("Done") {
                        showingHelp = false
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding()
                }
        }
        .sheet(isPresented: $showingParentalGate) {
            ParentalGateView(isUnlocked: .constant(false))
                .onDisappear {
                    // Check if gate was unlocked and show appropriate page
                    if showingContact {
                        showingContact = true
                        showingParentalGate = false
                    } else if showingAbout {
                        showingAbout = true
                        showingParentalGate = false
                    }
                }
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(20)
        .sheet(isPresented: $showingContact) {
            ContactUsView()
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(20)
        .sheet(isPresented: $showingAbout) {
            AboutUsView()
        }
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(20)
    }

    // MARK: - Enhanced Liquid Glass Header
    private var refinedHeaderSection: some View {
        VStack(spacing: 20) {
            LiquidGlassHeader(
                title: "More Options",
                subtitle: "Manage your learning experience",
                iconName: "ellipsis.circle.fill",
                iconColor: RefinedColors.warmYellow,
                layer: .content
            )

            // Quick Stats Preview
            quickStatsPreview
        }
    }

    // MARK: - Quick Stats Preview
    private var quickStatsPreview: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(session.gamificationService.gamificationState.totalXP)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Total XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()
                .frame(height: 30)

            VStack(spacing: 4) {
                Text("\(session.gamificationService.gamificationState.currentLevel.level)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()
                .frame(height: 30)

            VStack(spacing: 4) {
                Text("\(session.gamificationService.gamificationState.streakCount)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Day Streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .onAppear {
            // Ensure gamification state is properly initialized
            session.gamificationService.gamificationState.updateStreak()
        }
    }

    // MARK: - Primary Options Section with Enhanced Layout
    private var primaryOptionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "Primary",
                iconName: "star.fill",
                iconColor: RefinedColors.warmYellow
            )

            VStack(spacing: 16) {
                RefinedMoreOptionCard(
                    title: "Progress",
                    subtitle: "Track your learning journey and achievements",
                    icon: "chart.bar.fill",
                    accentColor: MTColors.funGreen,
                    action: { showingProgress = true }
                )

                RefinedMoreOptionCard(
                    title: "Settings",
                    subtitle: "App preferences and parent controls",
                    icon: "gearshape.fill",
                    accentColor: MTColors.funBlue,
                    action: { showingSettings = true }
                )
            }
        }
    }

    // MARK: - Secondary Options Section with Enhanced Layout
    private var secondaryOptionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "Support",
                iconName: "heart.fill",
                iconColor: MTColors.funPink
            )

            VStack(spacing: 16) {
                RefinedMoreOptionCard(
                    title: "Help & Support",
                    subtitle: "Get help and contact our support team",
                    icon: "questionmark.circle.fill",
                    accentColor: MTColors.funPink,
                    action: { showingHelp = true }
                )
            }
        }
    }

    // MARK: - Additional Options Section with Enhanced Layout
    private var additionalOptionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "About",
                iconName: "info.circle.fill",
                iconColor: RefinedColors.mediumGray
            )

            VStack(spacing: 16) {
                RefinedMoreOptionCard(
                    title: "About ManaTelugu",
                    subtitle: "Learn more about our mission and team",
                    icon: "info.circle.fill",
                    accentColor: RefinedColors.mediumGray,
                    action: { showingParentalGate = true }
                )

                RefinedMoreOptionCard(
                    title: "Contact Us",
                    subtitle: "Get in touch with our support team",
                    icon: "envelope.fill",
                    accentColor: RefinedColors.mediumGray,
                    action: { showingParentalGate = true }
                )

                RefinedMoreOptionCard(
                    title: "Privacy Policy",
                    subtitle: "How we protect your data and privacy",
                    icon: "hand.raised.fill",
                    accentColor: RefinedColors.mediumGray,
                    action: { showingParentalGate = true }
                )
            }
        }
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Refined More Option Card
struct RefinedMoreOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    let action: () -> Void

    @State private var isPressed = false
    @State private var rippleOffset = CGSize.zero
    @State private var rippleOpacity = 0.0

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()

            // Ripple animation
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
                rippleOffset = CGSize(width: 0, height: 0)
                rippleOpacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.3)) {
                    rippleOpacity = 0.0
                }
            }

            action()
        }) {
            UnifiedLiquidGlassCard(
                layer: .content,
                intensity: 0.18,
                cornerRadius: 24,
                padding: 0,
                isInteractive: false
            ) {
                ZStack {
                    // Card Background with Subtle Accent
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            accentColor.opacity(0.3),
                                            accentColor.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .background(
                            // Subtle inner glow
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            accentColor.opacity(0.05),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                        )

                    // Card Content
                    HStack(spacing: 20) {
                        // Icon with Enhanced Styling and Subtle Glow
                        ZStack {
                            // Outer glow
                            Circle()
                                .fill(accentColor.opacity(0.2))
                                .frame(width: MTSpacing.huge, height: MTSpacing.huge)
                                .blur(radius: 15)
                                .opacity(0.6)

                            // Main circle with gradient
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            accentColor.opacity(0.2),
                                            accentColor.opacity(0.1)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: MTSpacing.largeTouchTarget, height: MTSpacing.largeTouchTarget)

                            Image(systemName: icon)
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(accentColor)
                                .shadow(color: accentColor.opacity(0.3), radius: 2, x: 0, y: 1)
                        }

                        // Text Content
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title)
                                .font(EnhancedTypography.cardTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)

                            Text(subtitle)
                                .font(EnhancedTypography.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer()

                        // Chevron with Accent Color
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(accentColor.opacity(0.6))
                    }
                    .padding(24)

                    // Ripple Effect
                    if rippleOpacity > 0 {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        accentColor.opacity(0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 50
                                )
                            )
                            .frame(width: MTSpacing.huge + 20, height: MTSpacing.huge + 20)
                            .offset(rippleOffset)
                            .opacity(rippleOpacity)
                            .animation(.easeOut(duration: 0.6), value: rippleOpacity)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}


// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Liquid Glass Tab Bar
struct LiquidGlassTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            UnifiedLiquidGlassCard(
                layer: .navigation,
                intensity: 0.2,
                cornerRadius: 28,
                padding: 0,
                isInteractive: false
            ) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.clear)
            }
        )
        .shadow(
            color: Color.black.opacity(0.15),
            radius: 30,
            x: 0,
            y: 15
        )
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 10,
            x: 0,
            y: 5
        )
        .shadow(
            color: Color.black.opacity(0.04),
            radius: 6,
            x: 0,
            y: 3
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .scaleEffect(isVisible ? 1.0 : 0.9)
        .opacity(isVisible ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    // Professional selection circle
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.professionalBlue.opacity(0.2),
                                        Color.professionalBlue.opacity(0.08)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 44, height: 44)
                            .scaleEffect(1.05)
                    }

                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .professionalBlue : .textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }

                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .professionalBlue : .textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
