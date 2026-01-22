import Foundation

extension String {
    /// Returns a localized version of the string using the main bundle.
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    /// For accessibility: Localizes and returns the string for VoiceOver or hints.
    func localizedAccessibility() -> String {
        NSLocalizedString(self, tableName: "Accessibility", comment: "")
    }
}
