import Foundation
import CoreGraphics

enum MTSpacing {
    // Apple's recommended spacing system (8pt grid)
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
    static let xxLarge: CGFloat = 48
    
    // Accessibility and touch targets
    static let minimumTouchTarget: CGFloat = 44  // Apple's minimum touch target
    static let comfortableTouchTarget: CGFloat = 48  // More comfortable touch target
    static let largeTouchTarget: CGFloat = 56  // Large touch target for important actions
    
    // Additional Apple HIG compliant spacing
    static let micro: CGFloat = 2
    static let mini: CGFloat = 6
    static let regular: CGFloat = 12
    static let extraLarge: CGFloat = 40
    static let huge: CGFloat = 64
    
    // Touch target minimums (duplicate removed - already defined above)
    static let recommendedTouchTarget: CGFloat = 48
    
    // Apple's specific spacing guidelines
    static let standardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 32
    static let cardSpacing: CGFloat = 12
    static let textSpacing: CGFloat = 8
}