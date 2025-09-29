import SwiftUI

// MARK: - HIG Accessibility System
// Comprehensive accessibility support following Apple guidelines

struct HIGAccessibleButton<Content: View>: View {
    let label: String
    let hint: String
    let traits: AccessibilityTraits
    let action: () -> Void
    let content: Content
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        label: String,
        hint: String,
        traits: AccessibilityTraits = .isButton,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.hint = hint
        self.traits = traits
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            session.hapticsService.lightImpact()
            action()
        }) {
            content
        }
        .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
        .accessibilityLabel(label)
        .accessibilityHint(hint)
        .accessibilityAddTraits(traits)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct HIGAccessibleCard<Content: View>: View {
    let label: String
    let hint: String
    let value: String?
    let traits: AccessibilityTraits
    let action: (() -> Void)?
    let content: Content
    @State private var isPressed = false
    @EnvironmentObject var session: AppSession
    
    init(
        label: String,
        hint: String,
        value: String? = nil,
        traits: AccessibilityTraits = .isButton,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: {
                    session.hapticsService.lightImpact()
                    action()
                }) {
                    content
                }
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    isPressed = pressing
                }, perform: {})
            } else {
                content
            }
        }
        .frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityHint(hint)
        .accessibilityValue(value ?? "")
        .accessibilityAddTraits(traits)
    }
}

// MARK: - Dynamic Type Support
struct HIGDynamicText: View {
    let text: String
    let style: Font.TextStyle
    let weight: Font.Weight
    let design: Font.Design
    let color: Color
    let maxLines: Int?
    
    init(
        _ text: String,
        style: Font.TextStyle = .body,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        color: Color = MTColors.primaryText,
        maxLines: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.design = design
        self.color = color
        self.maxLines = maxLines
    }
    
    var body: some View {
        Text(text)
            .font(.system(style, design: design, weight: weight))
            .foregroundColor(color)
            .lineLimit(maxLines)
            .minimumScaleFactor(0.8)
            .allowsTightening(true)
    }
}

// MARK: - Focus Management
struct HIGFocusableView<Content: View>: View {
    let content: Content
    @FocusState private var isFocused: Bool
    @EnvironmentObject var session: AppSession
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { focused in
                if focused {
                    session.hapticsService.lightImpact()
                }
            }
    }
}

// MARK: - Accessibility Announcements
extension AppSession {
    func announceForAccessibility(_ message: String) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    
    func announceLayoutChange() {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
    }
    
    func announceScreenChange() {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }
}

// MARK: - Accessibility Testing Helper
struct AccessibilityTestingView: View {
    @State private var showingAccessibilityInfo = false
    
    var body: some View {
        #if DEBUG
        VStack {
            Button("Show Accessibility Info") {
                showingAccessibilityInfo.toggle()
            }
            .accessibilityLabel("Show accessibility information")
            .accessibilityHint("Displays current accessibility settings")
            
            if showingAccessibilityInfo {
                VStack(alignment: .leading, spacing: MTSpacing.small) {
                    Text("Accessibility Status:")
                        .font(.headline)
                    
                    Text("VoiceOver: \(UIAccessibility.isVoiceOverRunning ? "ON" : "OFF")")
                    Text("Switch Control: \(UIAccessibility.isSwitchControlRunning ? "ON" : "OFF")")
                    Text("Reduce Motion: \(UIAccessibility.isReduceMotionEnabled ? "ON" : "OFF")")
                    Text("Bold Text: \(UIAccessibility.isBoldTextEnabled ? "ON" : "OFF")")
                    Text("Reduce Transparency: \(UIAccessibility.isReduceTransparencyEnabled ? "ON" : "OFF")")
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        #endif
    }
}

// MARK: - Accessibility Modifiers
extension View {
    func higAccessible(
        label: String,
        hint: String,
        value: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityValue(value ?? "")
            .accessibilityAddTraits(traits)
    }
    
    func higTouchTarget() -> some View {
        self.frame(minWidth: MTSpacing.minimumTouchTarget, minHeight: MTSpacing.minimumTouchTarget)
    }
    
    func higButtonStyle() -> some View {
        self
            .higTouchTarget()
            .accessibilityAddTraits(.isButton)
    }
}
