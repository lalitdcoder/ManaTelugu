# Apple HIG Maintenance Guide for Mana Telugu

## 🎯 Quick Reference Checklist

### Before Adding Any Interactive Element
- [ ] Minimum 44pt touch target (use `MTSpacing.minimumTouchTarget`)
- [ ] Accessibility label and hint
- [ ] Proper accessibility traits
- [ ] Haptic feedback on interaction
- [ ] Proper button states (pressed, disabled)

### Before Adding Any Spacing
- [ ] Use `MTSpacing` constants instead of hardcoded values
- [ ] Follow 8pt grid system
- [ ] Use semantic spacing names

### Before Adding Any Typography
- [ ] Use `MTTypography` system
- [ ] Consider kid mode support
- [ ] Use appropriate font weights
- [ ] Ensure proper contrast

## 🔧 Code Templates

### Interactive Button Template
```swift
Button(action: {
    session.hapticsService.lightImpact()
    // Action here
}) {
    // Button content
}
.frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
.accessibilityLabel("Descriptive label")
.accessibilityHint("Action description")
.accessibilityAddTraits(.isButton)
.scaleEffect(isPressed ? 0.98 : 1.0)
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
```

### Card Component Template
```swift
UnifiedLiquidGlassCard(
    layer: .content,
    intensity: 0.15,
    cornerRadius: 16,
    padding: MTSpacing.medium,
    isInteractive: true
) {
    // Card content
}
```

### Navigation Template
```swift
.navigationTitle("Title")
.navigationBarTitleDisplayMode(.large)
.toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
        // Toolbar content
    }
}
```

## 📏 Spacing Guidelines

### Use These Constants
```swift
MTSpacing.micro      // 2pt - Fine details
MTSpacing.tiny       // 4pt - Small gaps
MTSpacing.small      // 8pt - Standard small spacing
MTSpacing.medium     // 16pt - Standard spacing
MTSpacing.large      // 24pt - Section spacing
MTSpacing.xLarge     // 32pt - Large section spacing
MTSpacing.xxLarge    // 48pt - Major section spacing
```

### Touch Target Guidelines
```swift
MTSpacing.minimumTouchTarget    // 44pt - Apple minimum
MTSpacing.recommendedTouchTarget // 48pt - Recommended
```

## 🎨 Design System Usage

### Colors
```swift
// Primary colors
MTColors.primary        // System blue
MTColors.secondary      // System green
MTColors.success        // System green
MTColors.warning        // System orange
MTColors.error          // System red

// Surface colors
MTColors.surface        // System background
MTColors.surfaceAlt     // Secondary system background
MTColors.background     // System grouped background

// Text colors
MTColors.primaryText    // Primary label
MTColors.secondaryText  // Secondary label
MTColors.tertiaryText   // Tertiary label
```

### Typography
```swift
// Use with kid mode support
.font(MTTypography.title(kidMode: session.userProfile.kidMode))
.font(MTTypography.heading(kidMode: session.userProfile.kidMode))
.font(MTTypography.body(kidMode: session.userProfile.kidMode))
.font(MTTypography.caption(kidMode: session.userProfile.kidMode))
```

## ♿ Accessibility Best Practices

### Labels
```swift
// Good: Descriptive and specific
.accessibilityLabel("Play audio for \(word.telugu)")

// Bad: Generic or unclear
.accessibilityLabel("Button")
```

### Hints
```swift
// Good: Clear action description
.accessibilityHint("Double tap to hear pronunciation")

// Bad: Vague or missing
.accessibilityHint("Tap")
```

### Traits
```swift
// Common traits
.accessibilityAddTraits(.isButton)        // For buttons
.accessibilityAddTraits(.isHeader)        // For headers
.accessibilityAddTraits(.isSelected)      // For selected items
.accessibilityAddTraits(.isImage)         // For images
```

## 🎭 Animation Guidelines

### Button Press
```swift
.scaleEffect(isPressed ? 0.98 : 1.0)
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
```

### State Changes
```swift
.animation(.easeInOut(duration: 0.2), value: state)
```

### Haptic Feedback
```swift
// Light interaction
session.hapticsService.lightImpact()

// Success
session.hapticsService.success()

// Warning
session.hapticsService.warning()
```

## 🧪 Testing Checklist

### Before Committing
- [ ] All interactive elements have 44pt+ touch targets
- [ ] VoiceOver can navigate all elements
- [ ] All buttons have proper accessibility labels
- [ ] Spacing uses MTSpacing constants
- [ ] Typography uses MTTypography system
- [ ] Colors use MTColors system
- [ ] Animations are smooth and purposeful

### Device Testing
- [ ] Test on actual device (not just simulator)
- [ ] Test with VoiceOver enabled
- [ ] Test with Dynamic Type at largest size
- [ ] Test in both light and dark mode
- [ ] Test with reduced motion enabled

## 🚨 Common Mistakes to Avoid

### ❌ Don't Do This
```swift
// Hardcoded spacing
.padding(.horizontal, 20)

// Missing touch targets
Button(action: { }) { }
    .frame(width: 30, height: 30)

// Missing accessibility
Button(action: { }) { }

// Hardcoded colors
.foregroundColor(.blue)

// Hardcoded fonts
.font(.system(size: 16))
```

### ✅ Do This Instead
```swift
// Semantic spacing
.padding(.horizontal, MTSpacing.large)

// Proper touch targets
Button(action: { }) { }
    .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)

// Full accessibility
Button(action: { }) { }
    .accessibilityLabel("Descriptive label")
    .accessibilityHint("Action description")
    .accessibilityAddTraits(.isButton)

// Semantic colors
.foregroundColor(MTColors.primary)

// Typography system
.font(MTTypography.body(kidMode: session.userProfile.kidMode))
```

## 📚 Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Accessibility](https://developer.apple.com/documentation/swiftui/accessibility)
- [Apple Design Tips](https://developer.apple.com/design/tips/)
- [VoiceOver Testing Guide](https://developer.apple.com/accessibility/voiceover/)

## 🔄 Regular Maintenance

### Weekly
- Review new code for HIG compliance
- Test accessibility features
- Check spacing consistency

### Monthly
- Full accessibility audit
- Review animation performance
- Update design system if needed

### Before Release
- Complete device testing
- VoiceOver navigation test
- Performance testing
- User feedback review

This guide ensures your Mana Telugu app maintains the highest standards of Apple HIG compliance and provides an excellent user experience for all users.
