import SwiftUI

enum MTTypography {
    // Enhanced typography system with cultural warmth
    static func title(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 34, weight: .bold, design: .rounded) : .largeTitle.weight(.bold)
    }
    static func heading(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 22, weight: .semibold, design: .rounded) : .title2.weight(.semibold)
    }
    static func body(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 17, weight: .regular, design: .rounded) : .body.weight(.regular)
    }
    static func caption(kidMode: Bool = false) -> Font {
        return kidMode ? .system(size: 15, weight: .medium, design: .rounded) : .subheadline.weight(.medium)
    }
    
    // Telugu-specific typography for better readability
    static func teluguTitle() -> Font {
        return .system(size: 32, weight: .bold, design: .serif)
    }
    static func teluguHeading() -> Font {
        return .system(size: 24, weight: .semibold, design: .serif)
    }
    static func teluguBody() -> Font {
        return .system(size: 18, weight: .regular, design: .serif)
    }
    static func teluguCaption() -> Font {
        return .system(size: 16, weight: .medium, design: .serif)
    }
    
    // Motivational and encouraging text styles
    static func encouragement() -> Font {
        return .system(size: 16, weight: .medium, design: .rounded)
    }
    static func celebration() -> Font {
        return .system(size: 20, weight: .bold, design: .rounded)
    }
    static func progress() -> Font {
        return .system(size: 14, weight: .semibold, design: .monospaced)
    }
    
    // Additional Apple-style typography
    static func headline() -> Font {
        return .headline.weight(.semibold)
    }
    static func subheadline() -> Font {
        return .subheadline.weight(.medium)
    }
    static func footnote() -> Font {
        return .footnote.weight(.regular)
    }
    static func caption2() -> Font {
        return .caption2.weight(.medium)
    }
}