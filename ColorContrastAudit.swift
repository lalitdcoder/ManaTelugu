import SwiftUI
import UIKit

extension UIColor {
    /// Returns the WCAG contrast ratio with another color.
    func contrastRatio(with other: UIColor) -> CGFloat {
        func luminance(_ c: UIColor) -> CGFloat {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
            c.getRed(&r, green: &g, blue: &b, alpha: &a)
            func channel(_ x: CGFloat) -> CGFloat {
                (x <= 0.03928) ? (x / 12.92) : pow((x + 0.055) / 1.055, 2.4)
            }
            return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
        }
        let l1 = luminance(self) + 0.05
        let l2 = luminance(other) + 0.05
        return max(l1, l2) / min(l1, l2)
    }
}

extension Color {
    /// Returns the WCAG contrast ratio with another Color.
    func contrastRatio(with other: Color) -> CGFloat {
        UIColor(self).contrastRatio(with: UIColor(other))
    }
}

// Call this at launch or attach to a test
func auditDesignSystemContrast() {
    let background = ModernDesignSystem.Colors.surface
    let textColors = [
        ("Primary", ModernDesignSystem.Colors.textPrimary),
        ("Secondary", ModernDesignSystem.Colors.textSecondary),
        ("Tertiary", ModernDesignSystem.Colors.textTertiary)
    ]
    for (name, textColor) in textColors {
        let ratio = textColor.contrastRatio(with: background)
        print("Contrast for \(name): \(ratio)")
        assert(ratio >= 4.5, "Contrast for \(name) is too low (\(ratio)). Should be at least 4.5:1")
    }
}
