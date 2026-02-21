import Foundation

// MARK: - String + Pronunciation Scoring
// Uses normalised Levenshtein edit distance to compare two Telugu strings.
// Returns a score from 0 (completely different) to 100 (exact match).

extension String {

    // MARK: - Public API

    /// Returns a 0–100 pronunciation score comparing `self` (transcript) to `target`.
    func pronunciationScore(comparedTo target: String) -> Int {
        let a = self.normalised()
        let b = target.normalised()

        guard !b.isEmpty else { return a.isEmpty ? 100 : 0 }
        guard !a.isEmpty else { return 0 }

        let distance = levenshteinDistance(from: a, to: b)
        let maxLen = max(a.count, b.count)
        let similarity = 1.0 - Double(distance) / Double(maxLen)

        // Clamp and convert to 0–100
        return Int((max(0.0, min(1.0, similarity)) * 100).rounded())
    }

    // MARK: - Helpers

    /// Strips diacritics, lowercases, trims whitespace for a fair comparison.
    private func normalised() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
    }

    /// Classic dynamic-programming Levenshtein distance (O(n·m) time, O(m) space).
    private func levenshteinDistance(from source: String, to target: String) -> Int {
        let s = Array(source)
        let t = Array(target)
        let m = s.count
        let n = t.count

        // Single-row rolling array
        var row = Array(0...n)

        for i in 1...m {
            var prev = row[0]
            row[0] = i
            for j in 1...n {
                let temp = row[j]
                if s[i - 1] == t[j - 1] {
                    row[j] = prev
                } else {
                    row[j] = 1 + min(prev, min(row[j], row[j - 1]))
                }
                prev = temp
            }
        }

        return row[n]
    }
}
