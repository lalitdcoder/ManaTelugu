# Quick Reference Guide - New Gamification Components

## 🎨 Glass Card Component

### Basic Usage
```swift
// As a modifier
VStack {
    Text("Hello")
}
.glassCard()

// With custom parameters
VStack {
    Text("Hello")
}
.glassCard(
    cornerRadius: 20,
    padding: 12,
    shadowRadius: 8,
    borderOpacity: 0.3
)

// As a standalone component
GlassCardView {
    VStack {
        Text("Content")
    }
}
```

---

## 🎯 Gamification ViewModel

### Initialization
```swift
// In your view
@StateObject private var viewModel = GamificationViewModel(
    gamificationService: session.gamificationService
)
```

### Observing Properties
```swift
// All properties are @Published, so they update UI automatically
Text("Level \(viewModel.userLevel)")
Text("\(viewModel.currentXP) XP")
AnimatedProgressBar(progress: viewModel.xpProgress)
```

### Awarding XP
```swift
// Award XP for an action
viewModel.awardXP(amount: 50, type: .wordLearned, description: "Learned 'నమస్కారం'")

// Award XP for quiz completion
viewModel.awardXP(amount: 100, type: .quizCompleted)
```

### Managing Hearts
```swift
// Deduct a heart
viewModel.deductHeart()

// Restore hearts
viewModel.restoreHearts()

// Display hearts
Text("Hearts: \(viewModel.hearts)/\(viewModel.maxHearts)")
```

---

## 🎬 Animation Components

### Scale Button Style
```swift
Button("Tap Me") {
    // Action
}
.scaleButtonStyle()

// Custom scale amount
Button("Tap Me") {
    // Action
}
.scaleButtonStyle(scaleAmount: 0.90)
```

### Animated Progress Bar
```swift
AnimatedProgressBar(
    progress: 0.65,  // 0.0 to 1.0
    height: 20
)

// With custom gradient
AnimatedProgressBar(
    progress: viewModel.xpProgress,
    height: 18,
    gradient: LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )
)
```

### XP Popup
```swift
// Show XP popup
if showXPPopup {
    VStack {
        XPPopUp(amount: 50)
            .padding(.top, 100)
        Spacer()
    }
}

// With custom color
XPPopUp(amount: 100, color: .green)
```

### Confetti View
```swift
// Basic confetti
if showConfetti {
    ConfettiView()
        .ignoresSafeArea()
        .allowsHitTesting(false)
}

// Custom duration and intensity
ConfettiView(duration: 5.0, intensity: 2.0)
```

### Shimmer Effect
```swift
// Add shimmer to any view
Text("✨ Rare Item")
    .shimmer()

// Custom shimmer
Image(systemName: "star.fill")
    .shimmer(duration: 3.0, opacity: 0.8)
```

---

## 🏆 Badge Components

### Glass Badge Card
```swift
GlassBadgeCard(badge: badge)
    .scaleButtonStyle()
    .onTapGesture {
        // Handle tap
    }
```

### Badge Icon
```swift
GlassBadgeIcon(badge: badge)
```

### Rarity Badge
```swift
RarityBadge(rarity: .legendary)
```

### Filter Chip
```swift
FilterChip(
    title: "Rare",
    isSelected: selectedRarity == .rare,
    color: .yellow,
    action: { selectedRarity = .rare }
)
```

---

## 🎴 Sticker Components

### Glass Sticker Card
```swift
GlassStickerCard(
    sticker: sticker,
    isUnlocked: true,
    isRare: true  // Shows shimmer if true
)
```

### Sticker Progress Header
```swift
StickerProgressHeader(
    collectedCount: 15,
    totalCount: 50
)
```

---

## 📊 Dashboard Components

### Hearts Display
```swift
HeartsDisplayView(
    hearts: viewModel.hearts,
    maxHearts: viewModel.maxHearts
)
```

### Level Progress Card
```swift
GlassLevelProgressCard(viewModel: viewModel)
```

### Streak Card
```swift
GlassStreakCard(streakCount: viewModel.streakCount)
```

### Recent Badges Card
```swift
GlassRecentBadgesCard(
    badges: viewModel.recentBadges,
    onViewAll: { showingBadgeGallery = true }
)
```

### Badge Progress Card
```swift
GlassBadgeProgressCard(
    unlockedCount: viewModel.unlockedBadges.count,
    totalCount: viewModel.allBadges.count,
    percentage: viewModel.badgeCompletionPercentage
)
```

### Quick Actions Card
```swift
GlassQuickActionsCard(
    onBadgesAction: { showBadges = true },
    onXPHistoryAction: { showHistory = true }
)
```

---

## 🎉 Celebration Components

### Badge Unlock Celebration
```swift
.sheet(isPresented: $viewModel.showBadgeUnlockAnimation) {
    if let badge = viewModel.newlyUnlockedBadge {
        BadgeUnlockCelebrationView(badge: badge) {
            viewModel.dismissBadgeUnlock()
        }
    }
}
```

---

## 🎨 Design System Quick Reference

### Colors
```swift
ModernDesignSystem.Colors.funBlue
ModernDesignSystem.Colors.funGreen
ModernDesignSystem.Colors.funPink
ModernDesignSystem.Colors.funYellow
ModernDesignSystem.Colors.primary
ModernDesignSystem.Colors.secondary
```

### Typography
```swift
.font(ModernDesignSystem.Typography.title2)
.font(ModernDesignSystem.Typography.headline)
.font(ModernDesignSystem.Typography.body)
.font(ModernDesignSystem.Typography.caption)
```

### Spacing
```swift
.padding(ModernDesignSystem.Spacing.xs)   // 4pt
.padding(ModernDesignSystem.Spacing.sm)   // 8pt
.padding(ModernDesignSystem.Spacing.md)   // 16pt
.padding(ModernDesignSystem.Spacing.lg)   // 24pt
.padding(ModernDesignSystem.Spacing.xl)   // 32pt
```

---

## 🔧 Common Patterns

### Creating a Glass Card with Content
```swift
VStack(spacing: 16) {
    HStack {
        Image(systemName: "star.fill")
            .foregroundColor(.yellow)
        Text("Title")
            .font(.headline)
        Spacer()
    }
    
    Text("Description")
        .font(.body)
        .foregroundColor(.secondary)
}
.glassCard()
```

### Adding Button with Animation
```swift
Button(action: {
    HapticsManager.shared.impact(.light)
    // Your action
}) {
    HStack {
        Image(systemName: "star.fill")
        Text("Tap Me")
    }
    .padding()
    .glassCard()
}
.scaleButtonStyle()
```

### Showing Celebration
```swift
@State private var showCelebration = false

// Trigger celebration
withAnimation {
    showCelebration = true
}

// In your view
if showCelebration {
    ConfettiView()
        .ignoresSafeArea()
        .allowsHitTesting(false)
}

// Auto-dismiss after 3 seconds
.onAppear {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        showCelebration = false
    }
}
```

### Conditional Shimmer
```swift
Image(systemName: "star.fill")
    .modifier(isRare ? ShimmerEffect() : EmptyModifier())

// Or using conditional
if isRare {
    Image(systemName: "star.fill")
        .shimmer()
} else {
    Image(systemName: "star.fill")
}
```

---

## 🎯 Best Practices

### 1. Always Use ViewModel for Logic
```swift
// ❌ Bad - Logic in view
Button("Award XP") {
    session.gamificationService.awardXP(50, type: .wordLearned)
}

// ✅ Good - Logic in ViewModel
Button("Award XP") {
    viewModel.awardXP(amount: 50, type: .wordLearned)
}
```

### 2. Use Glass Cards Consistently
```swift
// ❌ Bad - Mixing styles
VStack {
    Text("Content")
}
.background(Color.gray)
.cornerRadius(12)

// ✅ Good - Consistent glass design
VStack {
    Text("Content")
}
.glassCard()
```

### 3. Add Haptics to Interactions
```swift
Button("Tap") {
    HapticsManager.shared.impact(.light)  // ✅ Tactile feedback
    // Action
}
.scaleButtonStyle()  // ✅ Visual feedback
```

### 4. Use Proper Animation Timing
```swift
// ✅ Good - Spring animations for natural feel
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)

// ❌ Bad - Linear animations feel robotic
.animation(.linear(duration: 0.3), value: isPressed)
```

---

## 🐛 Troubleshooting

### Glass Card Not Showing Blur
**Issue**: Glass card appears solid
**Solution**: Ensure you're using `.ultraThinMaterial` and the view has content behind it

### Animations Not Smooth
**Issue**: Choppy animations
**Solution**: Use spring animations with proper damping (0.6-0.7)

### ViewModel Not Updating UI
**Issue**: UI doesn't update when data changes
**Solution**: Ensure you're using `@ObservedObject` or `@StateObject` for the ViewModel

### Confetti Not Appearing
**Issue**: Confetti view doesn't show
**Solution**: Make sure it's above other content in the ZStack and has `.ignoresSafeArea()`

---

## 📚 Additional Resources

- **Full Documentation**: See `GAMIFICATION_REFACTORING.md`
- **Component Files**:
  - `GlassCardView.swift`
  - `GamificationViewModel.swift`
  - `AnimationComponents.swift`
  - `RefactoredGamificationDashboardView.swift`
  - `RefactoredBadgeGalleryView.swift`
  - `RefactoredStickerAlbumView.swift`

---

**Happy Coding! 🚀**
