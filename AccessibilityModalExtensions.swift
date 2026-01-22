import SwiftUI

extension View {
    /// Sets accessibility focus and announces a screen change for modals/sheets.
    func accessibleModal(focusState: AccessibilityFocusState<Bool>.Binding) -> some View {
        self
            .accessibilityFocused(focusState)
            .onAppear {
                focusState.wrappedValue = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIAccessibility.post(notification: .screenChanged, argument: nil)
                }
            }
    }
}
