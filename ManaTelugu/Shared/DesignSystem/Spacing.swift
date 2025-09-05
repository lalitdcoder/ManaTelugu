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
    
    // Apple's specific spacing guidelines
    static let minimumTouchTarget: CGFloat = 44 // Apple's minimum touch target
    static let standardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 32
    static let cardSpacing: CGFloat = 12
    static let textSpacing: CGFloat = 8
}