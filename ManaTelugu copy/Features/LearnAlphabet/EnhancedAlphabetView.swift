import SwiftUI

// MARK: - Enhanced Alphabet Learning View
struct EnhancedAlphabetView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedLetter: Letter?
    @State private var selectedCategory: LetterCategory = .all
    @State private var showingStrokeOrder = false
    @State private var searchText = ""

    enum LetterCategory: String, CaseIterable {
        case all = "All"
        case vowels = "Vowels"
        case consonants = "Consonants"
        case compounds = "Compounds"

        var icon: String {
            switch self {
            case .all: return "textformat"
            case .vowels: return "a.circle.fill"
            case .consonants: return "textformat.abc"
            case .compounds: return "number.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .all: return AppleHIGDesign.Colors.label
            case .vowels: return AppleHIGDesign.Colors.vowelColor
            case .consonants: return AppleHIGDesign.Colors.consonantColor
            case .compounds: return AppleHIGDesign.Colors.numberColor
            }
        }
    }

    var filteredLetters: [Letter] {
        let categoryFiltered =
            selectedCategory == .all
            ? session.teluguLetters
            : session.teluguLetters.filter {
                $0.category.rawValue == selectedCategory.rawValue.lowercased()
            }

        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter {
                $0.character.contains(searchText)
                    || $0.romanization.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            if horizontalSizeClass == .regular {
                // iPad: Split view layout
                iPadLayout
            } else {
                // iPhone: Single view layout
                iPhoneLayout
            }
        }
        .searchable(text: $searchText, prompt: "Search letters...")
        .navigationTitle("Learn Alphabet")
        .sheet(isPresented: $showingStrokeOrder) {
            if let letter = selectedLetter {
                Text("Stroke order for \(letter.character)")
                    .navigationTitle("Stroke Order")
            }
        }
    }

    // MARK: - iPad Layout
    private var iPadLayout: some View {
        NavigationSplitView {
            // Sidebar with letter grid
            VStack(spacing: 0) {
                // Category filter
                categoryFilterSection

                Divider()

                // Letter grid
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 4),
                        spacing: AppleHIGDesign.Spacing.sm
                    ) {
                        ForEach(filteredLetters, id: \.id) { letter in
                            TeluguLetterCard(
                                letter: letter.character,
                                transliteration: letter.romanization,
                                category: .vowel,  // Simplified for now
                                isSelected: selectedLetter?.id == letter.id
                            ) {
                                selectedLetter = letter
                                HapticsManager.shared.impact(.light)
                            }
                        }
                    }
                    .padding(AppleHIGDesign.Spacing.md)
                }
            }
            .navigationTitle("Letters")
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            // Detail view
            if let letter = selectedLetter,
                let index = filteredLetters.firstIndex(where: { $0.id == letter.id })
            {
                LetterDetailView(letters: filteredLetters, initialIndex: index)
            } else {
                VStack {
                    Text("Select a Letter")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    // MARK: - iPhone Layout
    private var iPhoneLayout: some View {
        VStack(spacing: 0) {
            // Category filter
            categoryFilterSection

            Divider()

            // Letter grid
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                    spacing: AppleHIGDesign.Spacing.sm
                ) {
                    ForEach(Array(filteredLetters.enumerated()), id: \.element.id) {
                        index, letter in
                        NavigationLink(
                            destination: LetterDetailView(
                                letters: filteredLetters, initialIndex: index)
                        ) {
                            TeluguLetterCard(
                                letter: letter.character,
                                transliteration: letter.romanization,
                                category: .vowel,  // Simplified for now
                                isSelected: false
                            ) {
                                AppleHIGDesign.Haptics.light()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(AppleHIGDesign.Spacing.md)
            }
        }
    }

    // MARK: - Category Filter Section
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppleHIGDesign.Spacing.sm) {
                ForEach(LetterCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                        HapticsManager.shared.selection()
                    }
                }
            }
            .padding(.horizontal, AppleHIGDesign.Spacing.md)
            .padding(.vertical, AppleHIGDesign.Spacing.sm)
        }
    }
}

// MARK: - Category Filter Button
struct CategoryFilterButton: View {
    let category: EnhancedAlphabetView.LetterCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppleHIGDesign.Spacing.xs) {
                Image(systemName: category.icon)
                    .font(.caption)

                Text(category.rawValue)
                    .font(AppleHIGDesign.Typography.subheadline.weight(.medium))
            }
            .foregroundColor(isSelected ? .white : category.color)
            .padding(.horizontal, AppleHIGDesign.Spacing.md)
            .padding(.vertical, AppleHIGDesign.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AppleHIGDesign.CornerRadius.md)
                    .fill(
                        isSelected ? category.color : AppleHIGDesign.Colors.tertiarySystemBackground
                    )
            )
        }
        .appleHIGAccessibility(
            label: "\(category.rawValue) category",
            hint: isSelected
                ? "Currently selected"
                : "Double tap to filter by \(category.rawValue.lowercased())",
            traits: [.isButton]
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(AppleHIGDesign.Animation.smooth, value: isSelected)
    }
}
