import SwiftUI

struct StoryReaderView: View {
    let story: TeluguStory
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    @State private var showingSettings = false
    @State private var showingCulturalNotes = false
    @State private var showingGlossary = false
    @State private var isPlayingAudio = false
    @State private var readingProgress: Double = 0.0
    
    private let pagesPerView = 1
    private var totalPages: Int {
        return max(1, story.content.components(separatedBy: "\n\n").count)
    }
    
    var body: some View {
        ZStack {
            // Enhanced background gradient for Liquid Glass effect
            Color.clear
                .liquidGlassBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                customNavigationBar
                
                // Story Content
                EnhancedScrollView(bottomPadding: 140) {
                    VStack(spacing: 24) {
                        // Story Header
                        storyHeader
                        
                        // Story Content
                        storyContent
                        
                        // Cultural Context
                        if session.storyService.settings.showCulturalNotes {
                            culturalContextSection
                        }
                        
                        // Moral/Educational Note
                        if let moral = story.moral, !moral.isEmpty {
                            moralSection(moral: moral)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 140) // Increased padding to account for tab bar and bottom controls
                }
                
                // Bottom Controls
                bottomControls
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadReadingProgress()
        }
        .onDisappear {
            saveReadingProgress()
        }
        .sheet(isPresented: $showingSettings) {
            StorySettingsView()
                .environmentObject(session)
        }
        .sheet(isPresented: $showingCulturalNotes) {
            CulturalNotesView(story: story)
        }
        .sheet(isPresented: $showingGlossary) {
            GlossaryView(story: story)
        }
    }
    
    // MARK: - Custom Navigation Bar
    private var customNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(story.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(currentPage + 1) / \(totalPages)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Button(action: { toggleBookmark() }) {
                    Image(systemName: story.isBookmarked ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(story.isBookmarked ? .red : .primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
    
    // MARK: - Story Header
    private var storyHeader: some View {
        VStack(spacing: 16) {
            // Story Title
            VStack(spacing: 8) {
                Text(story.titleEnglish)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                Text(story.title)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Author and Metadata
            VStack(spacing: 8) {
                Text("రచయిత: \(story.author)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    Label(story.category.displayName, systemImage: story.category.icon)
                        .font(.subheadline)
                        .foregroundColor(MTColors.accent)
                    
                    Label("\(story.estimatedReadingTime) నిమిషాలు", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Label(story.difficulty.displayName, systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(difficultyColor)
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Story Content
    private var storyContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            if session.storyService.settings.showEnglishTranslation,
               let englishContent = story.contentEnglish {
                let teluguLines = story.content.components(separatedBy: "\n")
                let englishLines = englishContent.components(separatedBy: "\n")
                ForEach(0..<max(teluguLines.count, englishLines.count), id: \.self) { idx in
                    VStack(alignment: .leading, spacing: 8) {
                        // English content first and larger
                        if idx < englishLines.count {
                            Text(englishLines[idx])
                                .font(.system(size: session.storyService.settings.fontSize.size + 2))
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .accessibilityLabel(englishLines[idx])
                        }
                        // Telugu content second and smaller
                        if idx < teluguLines.count {
                            Text(teluguLines[idx])
                                .font(.system(size: session.storyService.settings.fontSize.size - 2))
                                .foregroundColor(.secondary)
                                .accessibilityLabel(teluguLines[idx])
                        }
                    }
                    .padding(.vertical, 6)
                }
            } else {
                // Default to English if available, otherwise Telugu
                if let englishContent = story.contentEnglish {
                    Text(englishContent)
                        .font(.system(size: session.storyService.settings.fontSize.size))
                        .lineSpacing(8)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                } else {
                    Text(story.content)
                        .font(.system(size: session.storyService.settings.fontSize.size))
                        .lineSpacing(8)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Cultural Context Section
    private var culturalContextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("సాంస్కృతిక సందర్భం")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("అన్ని చూడండి") {
                    showingCulturalNotes = true
                }
                .font(.subheadline)
                .foregroundColor(MTColors.accent)
            }
            
            Text(story.culturalContext)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .glassEffect(.subtle, shape: .rect(cornerRadius: 12))
        }
    }
    
    // MARK: - Moral Section
    private func moralSection(moral: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("నైతిక సందేశం")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Text(moral)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .glassEffect(.regular, shape: .rect(cornerRadius: 12))
        }
    }
    
    // MARK: - Bottom Controls
    private var bottomControls: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 20) {
                // Audio Play/Pause
                Button(action: { toggleAudio() }) {
                    Image(systemName: isPlayingAudio ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(MTColors.accent)
                }
                .disabled(story.audioFileName == nil)

                // Progress Bar
                VStack(spacing: 4) {
                    ProgressView(value: readingProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: MTColors.accent))

                    Text("\(Int(readingProgress * 100))% పూర్తయింది")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Cultural Notes
                Button(action: { showingCulturalNotes = true }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                // Glossary
                Button(action: { showingGlossary = true }) {
                    Image(systemName: "book.closed")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        Group {
            switch session.storyService.settings.backgroundTheme {
            case .light:
                Color(.systemBackground)
            case .sepia:
                Color(.systemBrown).opacity(0.1)
            case .dark:
                Color(.systemGray6)
            case .parchment:
                Color(.systemYellow).opacity(0.05)
            }
        }
    }
    
    // MARK: - Helper Properties
    private var difficultyColor: Color {
        switch story.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
    
    // MARK: - Actions
    private func toggleBookmark() {
        session.storyService.toggleBookmark(for: story.id)
    }
    
    private func toggleAudio() {
        if isPlayingAudio {
            session.audioService.stop()
        } else {
            if let audioFileName = story.audioFileName {
                session.audioService.play(name: audioFileName, rate: 1.0)
            }
        }
        isPlayingAudio.toggle()
    }
    
    private func loadReadingProgress() {
        readingProgress = session.storyService.getReadingProgress(for: story.id)
    }
    
    private func saveReadingProgress() {
        session.storyService.updateReadingProgress(for: story.id, progress: readingProgress)
        
        // Mark story as completed if progress is 100%
        if readingProgress >= 1.0 && !story.isCompleted {
            session.storyService.markStoryAsCompleted(story.id)
        }
    }
}

#Preview {
    StoryReaderView(story: TeluguStory(
        title: "పిల్లి మరియు ఎలుక",
        titleEnglish: "The Cat and the Mouse",
        author: "ప్రాచీన కథ",
        category: .folktales,
        difficulty: .beginner,
        estimatedReadingTime: 5,
        content: "ఒకప్పుడు ఒక పిల్లి ఉండేది. అది చాలా చురుకుగా ఉండేది. ఒక రోజు అది ఒక ఎలుకను చూసింది...",
        culturalContext: "ఈ కథ తెలుగు సంస్కృతిలో చాలా ప్రసిద్ధమైన నైతిక కథ.",
        moral: "మిత్రులను నమ్మకూడదు."
    ))
    .environmentObject(AppSession())
}
