import SwiftUI

// MARK: - Enhanced Navigation System
struct EnhancedNavigation {
    
    // MARK: - Safe Area Container
    struct SafeAreaContainer<Content: View>: View {
        let content: Content
        let bottomPadding: CGFloat
        
        init(bottomPadding: CGFloat = 120, @ViewBuilder content: () -> Content) {
            self.bottomPadding = bottomPadding
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                content
                    .safeAreaInset(edge: .bottom) {
                        Color.clear
                            .frame(height: bottomPadding)
                    }
            }
        }
    }
    
    // MARK: - Enhanced Tab Bar
    struct EnhancedTabBar: View {
        @Binding var selectedTab: Int
        let tabs: [TabItem]
        @State private var isVisible = false
        @State private var tabAnimations: [Bool] = []
        
        init(selectedTab: Binding<Int>, tabs: [TabItem]) {
            self._selectedTab = selectedTab
            self.tabs = tabs
            self._tabAnimations = State(initialValue: Array(repeating: false, count: tabs.count))
        }
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    EnhancedTabBarButton(
                        tab: tabs[index],
                        isSelected: selectedTab == index,
                        isAnimating: tabAnimations[index],
                        action: {
                            handleTabSelection(index)
                        }
                    )
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                // Advanced glassmorphism with floating effect
                ZStack {
                    RoundedRectangle(cornerRadius: getCornerRadiusForDevice(), style: .continuous)
                        .fill(.regularMaterial)
                        .blur(radius: 20)
                    
                    RoundedRectangle(cornerRadius: getCornerRadiusForDevice(), style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    RefinedColors.glassWhite,
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: getCornerRadiusForDevice(), style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    RefinedColors.glassHighlight,
                                    RefinedColors.glassBorder
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: getBorderWidthForDevice()
                        )
                }
            )
            .shadow(
                color: RefinedColors.glassShadow,
                radius: 30,
                x: 0,
                y: 15
            )
            .shadow(
                color: RefinedColors.glassShadow.opacity(0.5),
                radius: 60,
                x: 0,
                y: 30
            )
            .shadow(
                color: Color.black.opacity(0.05),
                radius: 10,
                x: 0,
                y: 5
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
        
        private func handleTabSelection(_ index: Int) {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
            
            // Animation for selected tab
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                tabAnimations[index] = true
                selectedTab = index
            }
            
            // Reset animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.2)) {
                    tabAnimations[index] = false
                }
            }
        }
        
        private func getCornerRadiusForDevice() -> CGFloat {
            // Cross-platform consistency: larger radius for iPad/macOS
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 32
            }
            #endif
            return 28
        }
        
        private func getBorderWidthForDevice() -> CGFloat {
            // Cross-platform consistency: thicker border for larger devices
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 1.5
            }
            #endif
            return 1.0
        }
    }
    
    
    // MARK: - Enhanced Tab Bar Button
    struct EnhancedTabBarButton: View {
        let tab: TabItem
        let isSelected: Bool
        let isAnimating: Bool
        let action: () -> Void
        
        @State private var isPressed = false
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    ZStack {
                        // Selection background with enhanced glow
                        if isSelected {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            MTColors.funBlue.opacity(0.3),
                                            MTColors.funBlue.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .shadow(
                                    color: MTColors.funBlue.opacity(0.3),
                                    radius: isAnimating ? 15 : 8,
                                    x: 0,
                                    y: 0
                                )
                        }
                        
                        // Icon with enhanced styling
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isSelected ? MTColors.funBlue : .primary)
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    // Label with enhanced typography
                    Text(tab.title)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isSelected ? MTColors.funBlue : .secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
            .onLongPressGesture(minimumDuration: 0) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
            } onPressingChanged: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }
        }
    }
    
    // MARK: - Floating Action Button
    struct FloatingActionButton: View {
        let icon: String
        let color: Color
        let action: () -> Void
        
        @State private var isPressed = false
        @State private var isVisible = false
        
        init(icon: String, color: Color = .accentColor, action: @escaping () -> Void) {
            self.icon = icon
            self.color = color
            self.action = action
        }
        
        var body: some View {
            Button(action: {
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.prepare()
                impactFeedback.impactOccurred()
                
                action()
            }) {
                ZStack {
                    // Background with enhanced shadow
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(
                            color: color.opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                        .shadow(
                            color: color.opacity(0.2),
                            radius: 20,
                            x: 0,
                            y: 10
                        )
                    
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
            .onLongPressGesture(minimumDuration: 0) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
            } onPressingChanged: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }
        }
    }
}

// MARK: - Enhanced Root Tab View
struct EnhancedRootTabView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingBadgeUnlock = false
    @State private var showingTreasureChest = false
    @State private var selectedTab = 0
    
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", view: AnyView(HomeView())),
        TabItem(title: "Lessons", icon: "book.fill", view: AnyView(LessonsHubView())),
        TabItem(title: "Stories", icon: "books.vertical.fill", view: AnyView(StorybookHubView())),
        TabItem(title: "Games", icon: "gamecontroller.fill", view: AnyView(GamesHubView())),
        TabItem(title: "More", icon: "ellipsis.circle.fill", view: AnyView(ProfessionalMoreView()))
    ]
    
    var body: some View {
        ZStack {
            // Main content with proper safe area handling
            EnhancedNavigation.SafeAreaContainer(bottomPadding: 120) {
                tabs[selectedTab].view
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Enhanced Tab Bar
            VStack {
                Spacer()
                EnhancedNavigation.EnhancedTabBar(selectedTab: $selectedTab, tabs: tabs)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .ignoresSafeArea(.all, edges: .top)
        .toolbarBackground(.regularMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
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
        .sheet(isPresented: $showingTreasureChest) {
            if let reward = session.gamificationService.treasureChestReward {
                TreasureChestView(stickerReward: reward.sticker, xpReward: reward.xp) {
                    session.gamificationService.dismissTreasureChest()
                    showingTreasureChest = false
                }
            }
        }
    }
}

// MARK: - Enhanced Scroll View
struct EnhancedScrollView<Content: View>: View {
    let content: Content
    let bottomPadding: CGFloat
    
    init(bottomPadding: CGFloat = 120, @ViewBuilder content: () -> Content) {
        self.bottomPadding = bottomPadding
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                content
                
                // Bottom spacer to prevent content overlap
                Color.clear
                    .frame(height: bottomPadding)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(
            // Subtle gradient overlay for scroll edge effect
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.02)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Tab Item
struct TabItem {
    let title: String
    let icon: String
    let view: AnyView
}
