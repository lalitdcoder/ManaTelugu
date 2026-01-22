import SwiftUI

struct BadgeGalleryView: View {
    @ObservedObject var gamification: GamificationState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRarity: BadgeRarity? = nil
    @State private var searchText = ""

    var filteredBadges: [GamificationBadge] {
        var badges = gamification.badges

        if let rarity = selectedRarity {
            badges = badges.filter { $0.rarity == rarity }
        }

        if !searchText.isEmpty {
            badges = badges.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.teluguName.localizedCaseInsensitiveContains(searchText)
            }
        }

        return badges.sorted { badge1, badge2 in
            if badge1.isUnlocked && !badge2.isUnlocked { return true }
            if !badge1.isUnlocked && badge2.isUnlocked { return false }
            return badge1.rarity.rawValue > badge2.rarity.rawValue
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Enhanced background gradient for Liquid Glass effect
                Color.clear
                    .liquidGlassBackground()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search and Filter Bar
                    VStack(spacing: ModernDesignSystem.Spacing.md) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search badges...", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        .padding(.vertical, ModernDesignSystem.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemGroupedBackground))
                        )

                        // Rarity Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: ModernDesignSystem.Spacing.sm) {
                                FilterChip(
                                    title: "All",
                                    isSelected: selectedRarity == nil,
                                    action: { selectedRarity = nil }
                                )

                                ForEach(BadgeRarity.allCases, id: \.self) { rarity in
                                    FilterChip(
                                        title: rarity.rawValue.capitalized,
                                        isSelected: selectedRarity == rarity,
                                        color: rarity.color,
                                        action: { selectedRarity = rarity }
                                    )
                                }
                            }
                            .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        }
                    }
                    .padding(.vertical, ModernDesignSystem.Spacing.md)
                    .background(Color(.systemGroupedBackground))

                    // Badge Grid
                    EnhancedScrollView {
                        LazyVGrid(
                            columns: Array(
                                repeating: GridItem(
                                    .flexible(), spacing: ModernDesignSystem.Spacing.md), count: 2),
                            spacing: ModernDesignSystem.Spacing.md
                        ) {
                            ForEach(filteredBadges) { badge in
                                BadgeCardView(badge: badge)
                            }
                        }
                        .padding(.horizontal, ModernDesignSystem.Spacing.md)
                        .padding(.bottom, ModernDesignSystem.Spacing.lg)
                    }
                }
            }
            .navigationTitle("Badge Gallery")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Badge Card View
struct BadgeCardView: View {
    let badge: GamificationBadge
    @State private var showingDetails = false

    var body: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            // Badge Icon
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ? Color(badge.color) : Color(.systemGray4))
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: badge.isUnlocked ? Color(badge.color).opacity(0.3) : .clear,
                        radius: 8, x: 0, y: 4
                    )

                Text(badge.emoji)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(badge.isUnlocked ? .white : .secondary)

                // Lock overlay for locked badges
                if !badge.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(.black.opacity(0.6))
                                .frame(width: 24, height: 24)
                        )
                        .offset(x: 30, y: -30)
                }
            }

            // Badge Info
            VStack(spacing: 4) {
                Text(badge.name)
                    .font(ModernDesignSystem.Typography.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(badge.teluguName)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(badge.description)
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                // XP Reward
                if badge.isUnlocked {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(ModernDesignSystem.Colors.funYellow)
                        Text("+\(badge.xpReward) XP")
                            .font(ModernDesignSystem.Typography.caption)
                            .fontWeight(.medium)
                            .foregroundColor(ModernDesignSystem.Colors.funYellow)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ModernDesignSystem.Colors.funYellow.opacity(0.1))
                    )
                }
            }

            // Rarity Badge
            RarityBadge(rarity: badge.rarity)
        }
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            BadgeDetailView(
                badge: convertToBadge(gamificationBadge: badge), isUnlocked: badge.isUnlocked)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: String?
    let action: () -> Void

    init(title: String, isSelected: Bool, color: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(ModernDesignSystem.Typography.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSelected
                                ? (color != nil ? Color(color!) : ModernDesignSystem.Colors.primary)
                                : Color(.tertiarySystemGroupedBackground))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Rarity Badge
struct RarityBadge: View {
    let rarity: BadgeRarity

    var body: some View {
        Text(rarity.rawValue.capitalized)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(rarity.color))
            )
    }
}

// MARK: - Helper Functions
private func convertToBadge(gamificationBadge: GamificationBadge) -> Badge {
    // Convert GamificationBadge to Badge
    // This is a simplified conversion - you may need to adjust based on your specific needs
    let criteria: BadgeCriteria

    switch gamificationBadge.requirement {
    case .streakDays(let count):
        criteria = .streak(count)
    case .wordsLearned(let count):
        criteria = .wordsMastered(count)
    case .quizzesCompleted(let count):
        criteria = .lessonsCompleted(count)
    case .perfectQuizzes(let count):
        criteria = .lessonsCompleted(count)
    case .xpEarned(_):
        criteria = .streak(1)  // Default fallback
    case .levelReached(let count):
        criteria = .lettersMastered(count)  // Fallback or new criteria
    case .daysActive(let count):
        criteria = .streak(count)  // Fallback
    case .lettersLearned(let count):
        criteria = .lettersMastered(count)
    case .storiesCompleted(let count):
        criteria = .storiesCompleted(count)
    case .combo(let requirements):
        // For combo requirements, use the first one as primary
        if let firstRequirement = requirements.first {
            switch firstRequirement {
            case .streakDays(let count):
                criteria = .streak(count)
            case .wordsLearned(let count):
                criteria = .wordsMastered(count)
            case .quizzesCompleted(let count):
                criteria = .lessonsCompleted(count)
            case .perfectQuizzes(let count):
                criteria = .lessonsCompleted(count)
            case .xpEarned(_):
                criteria = .streak(1)
            case .levelReached(let count):
                criteria = .lettersMastered(count)
            case .daysActive(let count):
                criteria = .streak(count)
            case .lettersLearned(let count):
                criteria = .lettersMastered(count)
            case .storiesCompleted(let count):
                criteria = .storiesCompleted(count)
            case .combo(_):
                criteria = .streak(1)
            }
        } else {
            criteria = .streak(1)
        }
    }

    return Badge(
        id: gamificationBadge.id.uuidString,
        name: gamificationBadge.name,
        criteria: criteria,
        emoji: gamificationBadge.emoji
    )
}

#Preview {
    BadgeGalleryView(gamification: GamificationState())
}
