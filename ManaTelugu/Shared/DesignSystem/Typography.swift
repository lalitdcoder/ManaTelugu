import SwiftUI

enum MTTypography {
    static func title(kidMode: Bool = false) -> Font {
        return .largeTitle
    }
    
    static func heading(kidMode: Bool = false) -> Font {
        return .title
    }
    
    static func body(kidMode: Bool = false) -> Font {
        return .body
    }
    
    static func caption(kidMode: Bool = false) -> Font {
        return .caption
    }
}