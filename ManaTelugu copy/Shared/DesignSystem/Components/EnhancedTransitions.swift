import SwiftUI

// MARK: - Enhanced Transition System
struct EnhancedTransitions {
    
    // MARK: - Slide Transition
    struct SlideTransition: ViewModifier {
        let isActive: Bool
        let direction: SlideDirection
        
        enum SlideDirection {
            case left
            case right
            case up
            case down
        }
        
        func body(content: Content) -> some View {
            content
                .offset(offset)
                .opacity(isActive ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: isActive)
        }
        
        private var offset: CGSize {
            if isActive {
                return .zero
            } else {
                switch direction {
                case .left:
                    return CGSize(width: -UIScreen.main.bounds.width, height: 0)
                case .right:
                    return CGSize(width: UIScreen.main.bounds.width, height: 0)
                case .up:
                    return CGSize(width: 0, height: -UIScreen.main.bounds.height)
                case .down:
                    return CGSize(width: 0, height: UIScreen.main.bounds.height)
                }
            }
        }
    }
    
    // MARK: - Fade Transition
    struct FadeTransition: ViewModifier {
        let isActive: Bool
        let duration: Double
        
        init(isActive: Bool, duration: Double = 0.3) {
            self.isActive = isActive
            self.duration = duration
        }
        
        func body(content: Content) -> some View {
            content
                .opacity(isActive ? 1 : 0)
                .animation(.easeInOut(duration: duration), value: isActive)
        }
    }
    
    // MARK: - Scale Transition
    struct ScaleTransition: ViewModifier {
        let isActive: Bool
        let scale: CGFloat
        let duration: Double
        
        init(isActive: Bool, scale: CGFloat = 0.8, duration: Double = 0.3) {
            self.isActive = isActive
            self.scale = scale
            self.duration = duration
        }
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isActive ? 1 : scale)
                .opacity(isActive ? 1 : 0)
                .animation(.spring(response: duration, dampingFraction: 0.8), value: isActive)
        }
    }
    
    // MARK: - Blur Transition
    struct BlurTransition: ViewModifier {
        let isActive: Bool
        let blurRadius: CGFloat
        let duration: Double
        
        init(isActive: Bool, blurRadius: CGFloat = 10, duration: Double = 0.3) {
            self.isActive = isActive
            self.blurRadius = blurRadius
            self.duration = duration
        }
        
        func body(content: Content) -> some View {
            content
                .blur(radius: isActive ? 0 : blurRadius)
                .opacity(isActive ? 1 : 0)
                .animation(.easeInOut(duration: duration), value: isActive)
        }
    }
    
    // MARK: - Rotation Transition
    struct RotationTransition: ViewModifier {
        let isActive: Bool
        let angle: Double
        let duration: Double
        
        init(isActive: Bool, angle: Double = 180, duration: Double = 0.5) {
            self.isActive = isActive
            self.angle = angle
            self.duration = duration
        }
        
        func body(content: Content) -> some View {
            content
                .rotationEffect(.degrees(isActive ? 0 : angle))
                .opacity(isActive ? 1 : 0)
                .animation(.easeInOut(duration: duration), value: isActive)
        }
    }
    
    // MARK: - Liquid Transition
    struct LiquidTransition: ViewModifier {
        let isActive: Bool
        let duration: Double
        
        init(isActive: Bool, duration: Double = 0.6) {
            self.isActive = isActive
            self.duration = duration
        }
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isActive ? 1 : 0.3)
                .opacity(isActive ? 1 : 0)
                .blur(radius: isActive ? 0 : 20)
                .animation(.spring(response: duration, dampingFraction: 0.6), value: isActive)
        }
    }
}

// MARK: - View Extensions
extension View {
    
    // MARK: - Slide Transitions
    func slideTransition(isActive: Bool, direction: EnhancedTransitions.SlideTransition.SlideDirection = .right) -> some View {
        self.modifier(EnhancedTransitions.SlideTransition(isActive: isActive, direction: direction))
    }
    
    // MARK: - Fade Transitions
    func fadeTransition(isActive: Bool, duration: Double = 0.3) -> some View {
        self.modifier(EnhancedTransitions.FadeTransition(isActive: isActive, duration: duration))
    }
    
    // MARK: - Scale Transitions
    func scaleTransition(isActive: Bool, scale: CGFloat = 0.8, duration: Double = 0.3) -> some View {
        self.modifier(EnhancedTransitions.ScaleTransition(isActive: isActive, scale: scale, duration: duration))
    }
    
    // MARK: - Blur Transitions
    func blurTransition(isActive: Bool, blurRadius: CGFloat = 10, duration: Double = 0.3) -> some View {
        self.modifier(EnhancedTransitions.BlurTransition(isActive: isActive, blurRadius: blurRadius, duration: duration))
    }
    
    // MARK: - Rotation Transitions
    func rotationTransition(isActive: Bool, angle: Double = 180, duration: Double = 0.5) -> some View {
        self.modifier(EnhancedTransitions.RotationTransition(isActive: isActive, angle: angle, duration: duration))
    }
    
    // MARK: - Liquid Transitions
    func liquidTransition(isActive: Bool, duration: Double = 0.6) -> some View {
        self.modifier(EnhancedTransitions.LiquidTransition(isActive: isActive, duration: duration))
    }
}

// MARK: - Custom Transition Presets
extension AnyTransition {
    
    // MARK: - Slide Presets
    static var slideFromRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var slideFromLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }
    
    static var slideFromBottom: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
    
    static var slideFromTop: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    // MARK: - Scale Presets
    static var scaleIn: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
    
    static var scaleOut: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
    
    // MARK: - Blur Presets
    static var blurIn: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 1.0)),
            removal: .opacity.combined(with: .scale(scale: 0.9))
        )
    }
    
    static var blurOut: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.9)),
            removal: .opacity.combined(with: .scale(scale: 1.0))
        )
    }
    
    // MARK: - Liquid Presets
    static var liquidIn: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity).combined(with: .scale(scale: 1.0)),
            removal: .scale.combined(with: .opacity).combined(with: .scale(scale: 0.8))
        )
    }
    
    static var liquidOut: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity).combined(with: .scale(scale: 0.8)),
            removal: .scale.combined(with: .opacity).combined(with: .scale(scale: 1.0))
        )
    }
}

// MARK: - Navigation Transition Manager
class NavigationTransitionManager: ObservableObject {
    @Published var isTransitioning = false
    @Published var transitionDirection: EnhancedTransitions.SlideTransition.SlideDirection = .right
    
    func startTransition(direction: EnhancedTransitions.SlideTransition.SlideDirection = .right) {
        transitionDirection = direction
        isTransitioning = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isTransitioning = false
        }
    }
}

// MARK: - Enhanced Navigation View
struct EnhancedNavigationView<Content: View>: View {
    let content: Content
    @StateObject private var transitionManager = NavigationTransitionManager()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .slideTransition(
                    isActive: !transitionManager.isTransitioning,
                    direction: transitionManager.transitionDirection
                )
        }
    }
}

// MARK: - Transition Animation
struct TransitionAnimation: ViewModifier {
    let isActive: Bool
    let animation: Animation
    
    init(isActive: Bool, animation: Animation = .easeInOut(duration: 0.3)) {
        self.isActive = isActive
        self.animation = animation
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0)
            .scaleEffect(isActive ? 1 : 0.9)
            .animation(animation, value: isActive)
    }
}

extension View {
    func transitionAnimation(isActive: Bool, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.modifier(TransitionAnimation(isActive: isActive, animation: animation))
    }
}
