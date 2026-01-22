import SwiftUI

// MARK: - Navigation Extensions for Learning Modes
extension SimpleImprovedHomeView {
    func navigateToLearningMode(_ mode: String) {
        // This will be handled by NavigationLink in the updated cards
    }
}

// MARK: - Soft Gradient Background
struct SoftGradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.4, blue: 0.8).opacity(0.08), // teluguBlue
                        Color(red: 0.9, green: 0.6, blue: 0.1).opacity(0.04), // teluguSaffron  
                        Color(red: 0.1, green: 0.6, blue: 0.3).opacity(0.03)  // teluguGreen
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension View {
    func applySoftGradient() -> some View {
        self.modifier(SoftGradientBackground())
    }
}
