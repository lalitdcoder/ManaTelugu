import SwiftUI

struct GlossaryView: View {
    let story: TeluguStory
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private var culturalNotes: [CulturalNote] {
        [
            CulturalNote(
                keyword: "పిల్లి",
                keywordMeaning: "Cat - A small domesticated carnivorous mammal",
                context: "In Telugu culture, cats are often associated with cleverness and agility",
                culturalSignificance: "Associated with cleverness."
            ),
            CulturalNote(
                keyword: "ఎలుక",
                keywordMeaning: "Mouse - A small rodent",
                context: "Mice are often portrayed as clever and quick in folktales",
                culturalSignificance: "Symbol of resourcefulness."
            ),
            CulturalNote(
                keyword: "తెలివితేటలు",
                keywordMeaning: "Intelligence, cleverness, wisdom",
                context: "Highly valued quality in Telugu culture, often more important than physical strength",
                culturalSignificance: "A key virtue in folklore."
            ),
            CulturalNote(
                keyword: "నైతిక కథ",
                keywordMeaning: "Moral story, fable",
                context: "Traditional stories that teach moral lessons and values",
                culturalSignificance: "Primary way of teaching ethics."
            ),
            CulturalNote(
                keyword: "ప్రాచీన",
                keywordMeaning: "Ancient, old, traditional",
                context: "Refers to things from ancient times, often with cultural significance",
                culturalSignificance: "Connects to heritage."
            ),
            CulturalNote(
                keyword: "సంస్కృతి",
                keywordMeaning: "Culture, tradition",
                context: "The way of life, beliefs, and customs of a particular group",
                culturalSignificance: "Defines community identity."
            ),
            CulturalNote(
                keyword: "కథ",
                keywordMeaning: "Story, tale",
                context: "A narrative, often with educational or entertainment value",
                culturalSignificance: "Form of entertainment and education."
            ),
            CulturalNote(
                keyword: "రచయిత",
                keywordMeaning: "Author, writer",
                context: "Person who writes stories, books, or other literary works",
                culturalSignificance: "Respected figure in the culture."
            )
        ]
    }
    
    private var filteredNotes: [CulturalNote] {
        if searchText.isEmpty {
            return culturalNotes
        }
        
        return culturalNotes.filter { note in
            note.keyword.localizedCaseInsensitiveContains(searchText) ||
            note.keywordMeaning.localizedCaseInsensitiveContains(searchText) ||
            note.context.localizedCaseInsensitiveContains(searchText)
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
                // Search Bar
                searchBar
                
                // Glossary Content
                if filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    glossaryList
                }
                }
            }
            .navigationTitle("Glossary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        HapticsService.shared.navigationTap()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search words...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var glossaryList: some View {
        EnhancedScrollView(bottomPadding: 140) {
            LazyVStack(spacing: 16) {
                ForEach(filteredNotes) { note in
                    GlossaryItemView(note: note)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120) // Increased padding to prevent tab bar overlap
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No words found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Try a different word")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct GlossaryItemView: View {
    let note: CulturalNote
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Word Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.keywordMeaning)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text(note.keyword)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: { 
                    HapticsService.shared.buttonTap()
                    isExpanded.toggle() 
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            // Context (Expandable)
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Context:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Text(note.context)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

#Preview {
    GlossaryView(story: TeluguStory(
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
