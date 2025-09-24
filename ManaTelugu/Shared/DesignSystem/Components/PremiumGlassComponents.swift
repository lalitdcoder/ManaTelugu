import UIKit
import SwiftUI

// MARK: - Premium Glass Components
// High-quality, professional glass effects for the entire app

// MARK: - Premium Glass Card
class PremiumGlassCard: UIView {
    private var backgroundBlur: UIVisualEffectView!
    private var contentVibrancy: UIVisualEffectView!
    private var highlightGradient: CAGradientLayer!
    private var shadowLayer: CALayer!
    
    var glassType: PremiumGlassType = .card {
        didSet {
            updateGlassAppearance()
        }
    }
    
    var isInteractive: Bool = false {
        didSet {
            setupInteraction()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPremiumGlass()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPremiumGlass()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPremiumGlass()
    }
    
    private func setupPremiumGlass() {
        // Multi-layer blur for depth
        let blurEffect = UIBlurEffect(style: glassType.blurStyle)
        backgroundBlur = UIVisualEffectView(effect: blurEffect)
        backgroundBlur.frame = bounds
        backgroundBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundBlur.isUserInteractionEnabled = false
        insertSubview(backgroundBlur, at: 0)
        
        // Content vibrancy for text
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        contentVibrancy = UIVisualEffectView(effect: vibrancyEffect)
        contentVibrancy.frame = bounds
        contentVibrancy.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentVibrancy.isUserInteractionEnabled = false
        backgroundBlur.contentView.addSubview(contentVibrancy)
        
        // Professional glass styling
        layer.cornerRadius = glassType.cornerRadius
        layer.cornerCurve = .continuous
        layer.borderWidth = glassType.borderWidth
        layer.borderColor = UIColor.white.withAlphaComponent(glassType.borderOpacity).cgColor
        
        // High-quality shadows
        setupShadowLayer()
        
        // Glass highlight for premium feel
        setupHighlightGradient()
        
        // Update for current trait
        updateForCurrentTrait()
    }
    
    private func setupShadowLayer() {
        shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: glassType.shadowOffset)
        shadowLayer.shadowRadius = glassType.shadowRadius
        shadowLayer.shadowOpacity = glassType.shadowOpacity
        shadowLayer.cornerRadius = glassType.cornerRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    private func setupHighlightGradient() {
        highlightGradient = CAGradientLayer()
        highlightGradient.colors = [
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        highlightGradient.startPoint = CGPoint(x: 0, y: 0)
        highlightGradient.endPoint = CGPoint(x: 1, y: 1)
        highlightGradient.cornerRadius = glassType.cornerRadius
        layer.addSublayer(highlightGradient)
    }
    
    private func setupInteraction() {
        if isInteractive {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        }
    }
    
    @objc private func cardTapped() {
        // Professional press animation
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            self.alpha = 0.9
            self.shadowLayer.shadowOpacity = self.glassType.shadowOpacity * 0.6
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.transform = .identity
                self.alpha = 1.0
                self.shadowLayer.shadowOpacity = self.glassType.shadowOpacity
            }
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func updateGlassAppearance() {
        let blurEffect = UIBlurEffect(style: glassType.blurStyle)
        backgroundBlur.effect = blurEffect
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        contentVibrancy.effect = vibrancyEffect
        
        layer.cornerRadius = glassType.cornerRadius
        layer.borderWidth = glassType.borderWidth
        layer.borderColor = UIColor.white.withAlphaComponent(glassType.borderOpacity).cgColor
        
        shadowLayer.shadowOffset = CGSize(width: 0, height: glassType.shadowOffset)
        shadowLayer.shadowRadius = glassType.shadowRadius
        shadowLayer.shadowOpacity = glassType.shadowOpacity
        shadowLayer.cornerRadius = glassType.cornerRadius
        
        highlightGradient.cornerRadius = glassType.cornerRadius
    }
    
    private func updateForCurrentTrait() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        // Adjust for dark mode
        if isDarkMode {
            layer.borderColor = UIColor.white.withAlphaComponent(glassType.borderOpacity * 0.5).cgColor
            shadowLayer.shadowOpacity = glassType.shadowOpacity * 1.5
        } else {
            layer.borderColor = UIColor.white.withAlphaComponent(glassType.borderOpacity).cgColor
            shadowLayer.shadowOpacity = glassType.shadowOpacity
        }
        
        // Adjust for iPad
        if isIPad {
            layer.cornerRadius = glassType.cornerRadius * 1.2
            shadowLayer.cornerRadius = glassType.cornerRadius * 1.2
            highlightGradient.cornerRadius = glassType.cornerRadius * 1.2
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateForCurrentTrait()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update highlight gradient frame
        highlightGradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 3)
        
        // Update shadow layer frame
        shadowLayer.frame = bounds
    }
}

// MARK: - Premium Glass Button
class PremiumGlassButton: UIButton {
    private var glassCard: PremiumGlassCard!
    
    var premiumButtonType: PremiumButtonType = .primary {
        didSet {
            updateButtonAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPremiumButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPremiumButton()
    }
    
    private func setupPremiumButton() {
        // Create glass background
        glassCard = PremiumGlassCard()
        glassCard.glassType = .button
        glassCard.isInteractive = true
        glassCard.isUserInteractionEnabled = false
        insertSubview(glassCard, at: 0)
        
        // Button styling
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel?.textAlignment = .center
        
        // Add press animations
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        updateButtonAppearance()
    }
    
    private func updateButtonAppearance() {
        switch premiumButtonType {
        case .primary:
            glassCard.glassType = .button
            setTitleColor(.white, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .secondary:
            glassCard.glassType = .subtle
            setTitleColor(.label, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        case .tertiary:
            glassCard.glassType = .ultraThin
            setTitleColor(.secondaryLabel, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        glassCard.frame = bounds
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.85
        }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

// MARK: - Premium Glass Types
enum PremiumGlassType {
    case card
    case button
    case modal
    case navigation
    case floating
    case subtle
    case ultraThin
    
    var blurStyle: UIBlurEffect.Style {
        switch self {
        case .card:
            return .systemMaterial
        case .button:
            return .systemThinMaterial
        case .modal:
            return .systemThickMaterial
        case .navigation:
            return .systemUltraThinMaterial
        case .floating:
            return .systemMaterial
        case .subtle:
            return .systemUltraThinMaterial
        case .ultraThin:
            return .systemUltraThinMaterial
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .card:
            return 18
        case .button:
            return 12
        case .modal:
            return 24
        case .navigation:
            return 0
        case .floating:
            return 20
        case .subtle:
            return 12
        case .ultraThin:
            return 8
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .card:
            return 0.8
        case .button:
            return 0.5
        case .modal:
            return 1.0
        case .navigation:
            return 0
        case .floating:
            return 0.6
        case .subtle:
            return 0.3
        case .ultraThin:
            return 0.2
        }
    }
    
    var borderOpacity: CGFloat {
        switch self {
        case .card:
            return 0.25
        case .button:
            return 0.2
        case .modal:
            return 0.3
        case .navigation:
            return 0
        case .floating:
            return 0.22
        case .subtle:
            return 0.15
        case .ultraThin:
            return 0.1
        }
    }
    
    var shadowOffset: CGFloat {
        switch self {
        case .card:
            return 6
        case .button:
            return 4
        case .modal:
            return 12
        case .navigation:
            return 0
        case .floating:
            return 8
        case .subtle:
            return 2
        case .ultraThin:
            return 1
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .card:
            return 16
        case .button:
            return 8
        case .modal:
            return 24
        case .navigation:
            return 0
        case .floating:
            return 20
        case .subtle:
            return 6
        case .ultraThin:
            return 3
        }
    }
    
    var shadowOpacity: Float {
        switch self {
        case .card:
            return 0.12
        case .button:
            return 0.08
        case .modal:
            return 0.18
        case .navigation:
            return 0
        case .floating:
            return 0.15
        case .subtle:
            return 0.05
        case .ultraThin:
            return 0.03
        }
    }
}

enum PremiumButtonType {
    case primary
    case secondary
    case tertiary
}

// MARK: - SwiftUI Integration
struct PremiumGlassCardView: UIViewRepresentable {
    let glassType: PremiumGlassType
    let isInteractive: Bool
    let content: () -> AnyView
    
    init(glassType: PremiumGlassType = .card, isInteractive: Bool = false, @ViewBuilder content: @escaping () -> AnyView) {
        self.glassType = glassType
        self.isInteractive = isInteractive
        self.content = content
    }
    
    func makeUIView(context: Context) -> PremiumGlassCard {
        let card = PremiumGlassCard()
        card.glassType = glassType
        card.isInteractive = isInteractive
        return card
    }
    
    func updateUIView(_ uiView: PremiumGlassCard, context: Context) {
        uiView.glassType = glassType
        uiView.isInteractive = isInteractive
    }
}

struct PremiumGlassButtonView: UIViewRepresentable {
    let title: String
    let buttonType: PremiumButtonType
    let action: () -> Void
    
    func makeUIView(context: Context) -> PremiumGlassButton {
        let button = PremiumGlassButton()
        button.setTitle(title, for: .normal)
        button.premiumButtonType = buttonType
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PremiumGlassButton, context: Context) {
        uiView.setTitle(title, for: .normal)
        uiView.premiumButtonType = buttonType
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
