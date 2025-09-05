import SwiftUI

// MARK: - Legacy Practice Types (for backward compatibility)
struct ReadingPractice: Codable {
    let characters: [String]
    let words: [String]
    let phrases: [String]
    let sentences: [String]
}

struct WritingPractice: Codable {
    let characters: [String]
    let words: [String]
    let phrases: [String]
    let sentences: [String]
    let tracingExercises: [String]
    let wordWriting: [String]
    let sentenceWriting: [String]
}

struct SpeakingPractice: Codable {
    let words: [String]
    let phrases: [String]
    let sentences: [String]
    let isPlaceholder: Bool
}

struct LessonView: View {
    let lesson: Lesson
    let lessonsRepository: LessonsRepository
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentSection: LessonSection = .reading
    @State private var startTime = Date()
    @State private var showingCompletion = false
    @State private var readingScore: Double = 0
    @State private var writingScore: Double = 0
    @State private var speakingScore: Double = 0
    
    enum LessonSection: String, CaseIterable {
        case reading = "Reading"
        case writing = "Writing"
        case speaking = "Speaking"
        
        var icon: String {
            switch self {
            case .reading: return "book.open"
            case .writing: return "pencil"
            case .speaking: return "mic"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Header
                progressHeader
                
                // Section Picker
                sectionPicker
                
                // Content Area
                ScrollView {
                    VStack(spacing: MTSpacing.large) {
                        switch currentSection {
                        case .reading:
                            ReadingPracticeView(
                                practice: ReadingPractice(
                                    characters: ["అ", "ఆ", "ఇ", "ఈ"],
                                    words: ["అమ్మ", "అన్న", "అక్క"],
                                    phrases: ["నమస్కారం", "ధన్యవాదాలు"],
                                    sentences: ["నేను తెలుగు నేర్చుకుంటున్నాను"]
                                ),
                                onScoreUpdate: { score in readingScore = score }
                            )
                        case .writing:
                            WritingPracticeView(
                                practice: WritingPractice(
                                    characters: ["అ", "ఆ", "ఇ", "ఈ"],
                                    words: ["అమ్మ", "అన్న", "అక్క"],
                                    phrases: ["నమస్కారం", "ధన్యవాదాలు"],
                                    sentences: ["నేను తెలుగు నేర్చుకుంటున్నాను"],
                                    tracingExercises: ["అ", "ఆ", "ఇ"],
                                    wordWriting: ["అమ్మ", "అన్న"],
                                    sentenceWriting: ["నేను తెలుగు నేర్చుకుంటున్నాను"]
                                ),
                                onScoreUpdate: { score in writingScore = score }
                            )
                        case .speaking:
                            SpeakingPracticeView(
                                practice: SpeakingPractice(
                                    words: ["అమ్మ", "అన్న", "అక్క"],
                                    phrases: ["నమస్కారం", "ధన్యవాదాలు"],
                                    sentences: ["నేను తెలుగు నేర్చుకుంటున్నాను"],
                                    isPlaceholder: true
                                ),
                                onScoreUpdate: { score in speakingScore = score }
                            )
                        }
                        
                        // Complete Lesson Button
                        if currentSection == .speaking {
                            completeLessonButton
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $showingCompletion) {
            LessonCompletionView(
                lesson: lesson,
                xpEarned: lesson.xpReward,
                timeSpent: Date().timeIntervalSince(startTime),
                scores: (reading: readingScore, writing: writingScore, speaking: speakingScore),
                onDismiss: {
                    lessonsRepository.markLessonComplete(lessonId: lesson.id, levelId: lesson.levelId)
                    session.userProfile.totalXP += lesson.xpReward
                    session.userProfile.streakDays += 1
                    dismiss()
                }
            )
        }
    }
    
    private var progressHeader: some View {
        VStack(spacing: MTSpacing.small) {
            HStack {
                Text("Lesson \(lesson.order)")
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.6))
                
                Spacer()
                
                Text("\(lesson.estimatedMinutes) min")
                    .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
            
            ProgressView(value: Double(currentSection.rawValue == "Reading" ? 0.33 : currentSection.rawValue == "Writing" ? 0.66 : 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: MTColors.primary))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(MTColors.surface)
    }
    
    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(LessonSection.allCases, id: \.self) { section in
                Button(action: {
                    currentSection = section
                }) {
                    VStack(spacing: MTSpacing.tiny) {
                        Image(systemName: section.icon)
                            .font(.title3)
                        Text(section.rawValue)
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                    }
                    .foregroundColor(currentSection == section ? MTColors.primary : MTColors.text.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MTSpacing.small)
                }
            }
        }
        .background(MTColors.surfaceAlt)
    }
    
    private var completeLessonButton: some View {
        Button(action: {
            showingCompletion = true
        }) {
            Text("Complete Lesson")
                .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(MTColors.primary)
                .cornerRadius(12)
        }
        .padding(.top, MTSpacing.large)
    }
}

// MARK: - Reading Practice View
struct ReadingPracticeView: View {
    let practice: ReadingPractice
    let onScoreUpdate: (Double) -> Void
    @EnvironmentObject var session: AppSession
    @State private var currentIndex = 0
    @State private var currentType: ContentType = .characters
    
    enum ContentType: String, CaseIterable {
        case characters = "Characters"
        case words = "Words"
        case phrases = "Phrases"
        case sentences = "Sentences"
        
        func getContent(from practice: ReadingPractice) -> [String] {
            switch self {
            case .characters: return practice.characters
            case .words: return practice.words
            case .phrases: return practice.phrases
            case .sentences: return practice.sentences
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.large) {
            Text("Reading Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            // Content Type Picker
            Picker("Content Type", selection: $currentType) {
                ForEach(ContentType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: currentType) { _, _ in
                currentIndex = 0
            }
            
            let content = currentType.getContent(from: practice)
            
            if !content.isEmpty && currentIndex < content.count {
                // Content Display
                VStack(spacing: MTSpacing.medium) {
                    Text(content[currentIndex])
                        .font(currentType == .characters ? .largeTitle : MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MTColors.surfaceAlt)
                        .cornerRadius(12)
                    
                    // Navigation
                    HStack {
                        Button("Previous") {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                        .disabled(currentIndex == 0 || content.isEmpty)
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1) of \(content.count)")
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.6))
                        
                        Spacer()
                        
                        Button("Next") {
                            if currentIndex < content.count - 1 {
                                currentIndex += 1
                            } else {
                                onScoreUpdate(1.0) // Full score for completing reading
                            }
                        }
                        .disabled(content.isEmpty || currentIndex >= content.count - 1)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Text("No content available for this section")
                    .foregroundColor(MTColors.text.opacity(0.6))
                    .frame(maxWidth: .infinity, minHeight: 100)
            }
        }
    }
}

// MARK: - Writing Practice View
struct WritingPracticeView: View {
    let practice: WritingPractice
    let onScoreUpdate: (Double) -> Void
    @EnvironmentObject var session: AppSession
    @State private var currentExercise = 0
    @State private var practiceType: WritingType = .tracing
    
    enum WritingType: String, CaseIterable {
        case tracing = "Tracing"
        case words = "Words"
        case sentences = "Sentences"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.large) {
            Text("Writing Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            Picker("Practice Type", selection: $practiceType) {
                ForEach(WritingType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            switch practiceType {
            case .tracing:
                tracingView
            case .words:
                wordWritingView
            case .sentences:
                sentenceWritingView
            }
        }
    }
    
    private var tracingView: some View {
        VStack(spacing: MTSpacing.medium) {
            if !practice.tracingExercises.isEmpty && currentExercise < practice.tracingExercises.count {
                let exercise = practice.tracingExercises[currentExercise]
                
                Text("Trace: \(exercise)")
                    .font(.largeTitle)
                    .foregroundColor(MTColors.text)
                
                // Tracing area placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surfaceAlt)
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Text(exercise)
                                .font(.system(size: 100))
                                .foregroundColor(MTColors.text.opacity(0.3))
                            
                            Text("Trace with your finger")
                                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                                .foregroundColor(MTColors.text.opacity(0.6))
                        }
                    )
                
                // Stroke order instructions
                VStack(alignment: .leading, spacing: MTSpacing.tiny) {
                    Text("Stroke Order:")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .fontWeight(.medium)
                    
                    ForEach(0..<3, id: \.self) { index in
                        Text("\(index + 1). Sample stroke instruction")
                            .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                            .foregroundColor(MTColors.text.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Next Exercise") {
                    if currentExercise < practice.tracingExercises.count - 1 {
                        currentExercise += 1
                    } else {
                        onScoreUpdate(0.8) // Good score for completing tracing
                    }
                }
                .buttonStyle(.bordered)
            } else {
                Text("No tracing exercises available")
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
        }
    }
    
    private var wordWritingView: some View {
        VStack(spacing: MTSpacing.medium) {
            if !practice.wordWriting.isEmpty && currentExercise < practice.wordWriting.count {
                Text("Write: \(practice.wordWriting[currentExercise])")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                
                // Writing area placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surfaceAlt)
                    .frame(height: 100)
                    .overlay(
                        Text("Writing area - tap to write")
                            .foregroundColor(MTColors.text.opacity(0.6))
                    )
                
                Button("Next Word") {
                    if currentExercise < practice.wordWriting.count - 1 {
                        currentExercise += 1
                    } else {
                        onScoreUpdate(0.9)
                    }
                }
                .buttonStyle(.bordered)
            } else {
                Text("No word writing exercises available")
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
        }
    }
    
    private var sentenceWritingView: some View {
        VStack(spacing: MTSpacing.medium) {
            if !practice.sentenceWriting.isEmpty && currentExercise < practice.sentenceWriting.count {
                Text("Write: \(practice.sentenceWriting[currentExercise])")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .multilineTextAlignment(.center)
                
                // Writing area placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(MTColors.surfaceAlt)
                    .frame(height: 120)
                    .overlay(
                        Text("Writing area - tap to write")
                            .foregroundColor(MTColors.text.opacity(0.6))
                    )
                
                Button("Next Sentence") {
                    if currentExercise < practice.sentenceWriting.count - 1 {
                        currentExercise += 1
                    } else {
                        onScoreUpdate(1.0)
                    }
                }
                .buttonStyle(.bordered)
            } else {
                Text("No sentence writing exercises available")
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
        }
    }
}

// MARK: - Speaking Practice View
struct SpeakingPracticeView: View {
    let practice: SpeakingPractice
    let onScoreUpdate: (Double) -> Void
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: MTSpacing.large) {
            Text("Speaking Practice")
                .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                .foregroundColor(MTColors.text)
            
            if practice.isPlaceholder {
                VStack(spacing: MTSpacing.medium) {
                    Image(systemName: "mic.slash")
                        .font(.system(size: 60))
                        .foregroundColor(MTColors.text.opacity(0.4))
                    
                    Text("Speaking Practice")
                        .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    
                    Text("Coming Soon!")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.primary)
                        .fontWeight(.medium)
                    
                    Text("This feature will include pronunciation practice and voice recognition to help you speak Telugu correctly.")
                        .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Button("Skip for Now") {
                        onScoreUpdate(0.5) // Partial score for skipping
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(MTColors.surfaceAlt.opacity(0.5))
                .cornerRadius(12)
            } else {
                // Future implementation for actual speaking practice
                Text("Speaking exercises would go here")
                    .foregroundColor(MTColors.text.opacity(0.6))
            }
        }
    }
}
