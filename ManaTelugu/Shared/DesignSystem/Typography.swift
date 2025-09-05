import SwiftUI

enum MTTypography {
    // Apple's semantic typography system
    static func title(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 34, weight: .bold, design: .rounded) : .largeTitle
    }
    static func heading(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 22, weight: .semibold, design: .rounded) : .title2
    }
    static func body(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 17, weight: .regular, design: .rounded) : .body
    }
    static func caption(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 15, weight: .medium, design: .rounded) : .subheadline
    }
    
    // Additional Apple-style typography
    static func headline() -> Font {
        return .headline
    }
    static func subheadline() -> Font {
        return .subheadline
    }
    static func footnote() -> Font {
        return .footnote
    }
    static func caption2() -> Font {
        return .caption2
    }
}