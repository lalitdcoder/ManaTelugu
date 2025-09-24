import SwiftUI

struct CulturalNotesView: View {
    let story: TeluguStory
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            EnhancedScrollView(bottomPadding: 140) {
                VStack(alignment: .leading, spacing: 24) {
                    // Cultural Context
                    culturalContextSection
                    
                    // Keywords and Meanings
                    if !story.keywords.isEmpty {
                        keywordsSection
                    }
                    
                    // Moral/Educational Value
                    if let moral = story.moral, !moral.isEmpty {
                        moralSection
                    }
                    
                    // Story Category Info
                    categoryInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.bottom, 120) // Add bottom padding to prevent tab bar overlap
            }
            .navigationTitle("Cultural Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var culturalContextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(MTColors.accent)
                Text("Cultural Context")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Text(story.culturalContext)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineSpacing(6)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
    
    private var keywordsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "key.fill")
                    .foregroundColor(.orange)
                Text("Keywords")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(story.keywords, id: \.self) { keyword in
                    KeywordChip(keyword: keyword)
                }
            }
        }
    }
    
    private var moralSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Moral")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Text(story.moral ?? "")
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    private var categoryInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: story.category.icon)
                    .foregroundColor(MTColors.accent)
                Text("Story Category")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Category:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(story.category.displayName)
                        .font(.subheadline)
                        .foregroundColor(MTColors.accent)
                }
                HStack {
                    Text("Difficulty:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(story.difficulty.displayName)
                        .font(.subheadline)
                        .foregroundColor(difficultyColor)
                }
                HStack {
                    Text("Reading Time:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("\(story.estimatedReadingTime) min")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    private var difficultyColor: Color {
        switch story.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

struct KeywordChip: View {
    let keyword: String
    
    var body: some View {
        Text(keyword)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(MTColors.accent.opacity(0.2))
            )
            .foregroundColor(MTColors.accent)
    }
}

#Preview {
    CulturalNotesView(story: TeluguStory(
        title: "పిల్లి మరియు ఎలుక",
        titleEnglish: "The Cat and the Mouse",
        author: "ప్రాచీన కథ",
        category: .folktales,
        difficulty: .beginner,
        estimatedReadingTime: 5,
        content: "ఒకప్పుడు ఒక పిల్లి ఉండేది...",
        culturalContext: "ఈ కథ తెలుగు సంస్కృతిలో చాలా ప్రసిద్ధమైన నైతిక కథ.",
        moral: "తెలివితేటలు శక్తి కంటే ముఖ్యమైనవి.",
        keywords: ["పిల్లి", "ఎలుక", "తెలివితేటలు", "నైతిక కథ"]
    ))
}
