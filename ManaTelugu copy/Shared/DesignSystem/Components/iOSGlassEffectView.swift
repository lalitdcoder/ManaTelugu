import UIKit
import SwiftUI

// MARK: - iOS Native Glass Effect Implementation
// This provides true iOS glassmorphism using UIKit and UIVisualEffectView

// MARK: - iOS Glass Effect Types
enum iOSGlassEffectType {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    case prominent
    case subtle
    
    var blurStyle: UIBlurEffect.Style {
        switch self {
        case .ultraThin:
            return .systemUltraThinMaterial
        case .thin:
            return .systemThinMaterial
        case .regular:
            return .systemMaterial
        case .thick:
            return .systemThickMaterial
        case .ultraThick:
            return .systemThickMaterial
        case .prominent:
            return .systemMaterial
        case .subtle:
            return .systemUltraThinMaterial
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .ultraThin:
            return 0.1
        case .thin:
            return 0.15
        case .regular:
            return 0.2
        case .thick:
            return 0.3
        case .ultraThick:
            return 0.4
        case .prominent:
            return 0.25
        case .subtle:
            return 0.05
        }
    }
}

// MARK: - iOS Glass Effect View
class iOSGlassEffectView: UIView {
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView?
    private var highlightLayer: CALayer?
    private var shimmerLayer: CAGradientLayer?
    
    var glassType: iOSGlassEffectType = .regular {
        didSet {
            updateGlassEffect()
        }
    }
    
    var cornerRadius: CGFloat = 16 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var enableShimmer: Bool = false {
        didSet {
            if enableShimmer {
                setupShimmerEffect()
            } else {
                removeShimmerEffect()
            }
        }
    }
    
    var enableVibrancy: Bool = false {
        didSet {
            if enableVibrancy {
                setupVibrancyEffect()
            } else {
                removeVibrancyEffect()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGlassEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlassEffect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGlassEffect()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGlassForCurrentTrait()
    }
    
    private func setupGlassEffect() {
        // Create blur effect
        let blurEffect = UIBlurEffect(style: glassType.blurStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false
        insertSubview(blurView, at: 0)
        
        // Glass styling
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Glass border
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        // Glass background
        backgroundColor = UIColor.white.withAlphaComponent(glassType.opacity)
        
        // Glass shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.1
        
        // Glass highlight
        setupHighlightEffect()
        
        // Update for current device
        updateGlassForCurrentTrait()
    }
    
    private func setupHighlightEffect() {
        highlightLayer = CALayer()
        highlightLayer?.backgroundColor = UIColor.white.withAlphaComponent(0.4).cgColor
        highlightLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        layer.addSublayer(highlightLayer!)
    }
    
    private func setupVibrancyEffect() {
        guard vibrancyView == nil else { return }
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: glassType.blurStyle), style: .fill)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView?.frame = bounds
        vibrancyView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyView?.isUserInteractionEnabled = false
        
        blurView.contentView.addSubview(vibrancyView!)
    }
    
    private func removeVibrancyEffect() {
        vibrancyView?.removeFromSuperview()
        vibrancyView = nil
    }
    
    private func setupShimmerEffect() {
        guard shimmerLayer == nil else { return }
        
        shimmerLayer = CAGradientLayer()
        shimmerLayer?.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        shimmerLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        shimmerLayer?.frame = bounds
        shimmerLayer?.cornerRadius = cornerRadius
        
        layer.addSublayer(shimmerLayer!)
        
        // Animate shimmer
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 2.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shimmerLayer?.add(animation, forKey: "shimmer")
    }
    
    private func removeShimmerEffect() {
        shimmerLayer?.removeFromSuperlayer()
        shimmerLayer = nil
    }
    
    private func updateGlassEffect() {
        let blurEffect = UIBlurEffect(style: glassType.blurStyle)
        blurView.effect = blurEffect
        backgroundColor = UIColor.white.withAlphaComponent(glassType.opacity)
        
        if enableVibrancy {
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
            vibrancyView?.effect = vibrancyEffect
        }
    }
    
    private func updateGlassForCurrentTrait() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        // Adjust for iPad
        if isIPad {
            layer.cornerRadius = cornerRadius * 1.5
            layer.shadowRadius = 32
            layer.borderWidth = 1.0
        } else {
            layer.cornerRadius = cornerRadius
            layer.shadowRadius = 20
            layer.borderWidth = 0.5
        }
        
        // Adjust for dark mode
        if isDarkMode {
            layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
            layer.shadowOpacity = 0.2
        } else {
            layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            layer.shadowOpacity = 0.1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update highlight layer
        highlightLayer?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1)
        
        // Update shimmer layer
        shimmerLayer?.frame = bounds
    }
}

// MARK: - iOS Glass Button
class iOSGlassButton: UIButton {
    private var glassView: iOSGlassEffectView!
    
    var glassType: iOSGlassEffectType = .regular {
        didSet {
            glassView.glassType = glassType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGlassButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlassButton()
    }
    
    private func setupGlassButton() {
        // Create glass background
        glassView = iOSGlassEffectView()
        glassView.glassType = glassType
        glassView.isUserInteractionEnabled = false
        insertSubview(glassView, at: 0)
        
        // Button styling
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
        // Add press animations
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Haptic feedback
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.8
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    @objc private func buttonTapped() {
        // Success haptic feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}

// MARK: - iOS Haptic Manager
class iOSHapticManager {
    static let shared = iOSHapticManager()
    
    private init() {}
    
    func lightImpact() {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
    }
    
    func mediumImpact() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
    
    func heavyImpact() {
        let feedback = UIImpactFeedbackGenerator(style: .heavy)
        feedback.impactOccurred()
    }
    
    func success() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
    
    func warning() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.warning)
    }
    
    func error() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.error)
    }
    
    func selectionChanged() {
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
    }
}

// MARK: - SwiftUI Integration
struct iOSGlassEffect: UIViewRepresentable {
    let glassType: iOSGlassEffectType
    let cornerRadius: CGFloat
    let enableShimmer: Bool
    let enableVibrancy: Bool
    
    init(
        glassType: iOSGlassEffectType = .regular,
        cornerRadius: CGFloat = 16,
        enableShimmer: Bool = false,
        enableVibrancy: Bool = false
    ) {
        self.glassType = glassType
        self.cornerRadius = cornerRadius
        self.enableShimmer = enableShimmer
        self.enableVibrancy = enableVibrancy
    }
    
    func makeUIView(context: Context) -> iOSGlassEffectView {
        let view = iOSGlassEffectView()
        view.glassType = glassType
        view.cornerRadius = cornerRadius
        view.enableShimmer = enableShimmer
        view.enableVibrancy = enableVibrancy
        return view
    }
    
    func updateUIView(_ uiView: iOSGlassEffectView, context: Context) {
        uiView.glassType = glassType
        uiView.cornerRadius = cornerRadius
        uiView.enableShimmer = enableShimmer
        uiView.enableVibrancy = enableVibrancy
    }
}

// MARK: - SwiftUI Glass Button
struct iOSGlassButtonView: UIViewRepresentable {
    let title: String
    let glassType: iOSGlassEffectType
    let action: () -> Void
    
    func makeUIView(context: Context) -> iOSGlassButton {
        let button = iOSGlassButton()
        button.setTitle(title, for: .normal)
        button.glassType = glassType
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: iOSGlassButton, context: Context) {
        uiView.setTitle(title, for: .normal)
        uiView.glassType = glassType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}
