import WidgetKit
import SwiftUI
import Intents

// MARK: - iOS Widget Support
// Home screen widgets for Telugu learning progress

// MARK: - Widget Data Model
struct TeluguProgressEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let totalXP: Int
    let todayProgress: Double
    let nextLesson: String
}

// MARK: - Widget Provider
struct TeluguProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> TeluguProgressEntry {
        TeluguProgressEntry(
            date: Date(),
            streak: 7,
            totalXP: 1250,
            todayProgress: 0.6,
            nextLesson: "Vowels"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TeluguProgressEntry) -> ()) {
        let entry = TeluguProgressEntry(
            date: Date(),
            streak: 5,
            totalXP: 980,
            todayProgress: 0.4,
            nextLesson: "Consonants"
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TeluguProgressEntry>) -> ()) {
        let currentDate = Date()
        let entry = TeluguProgressEntry(
            date: currentDate,
            streak: 7,
            totalXP: 1250,
            todayProgress: 0.8,
            nextLesson: "Stories"
        )
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget Views
struct TeluguProgressWidgetView: View {
    var entry: TeluguProgressProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallProgressWidget(entry: entry)
        case .systemMedium:
            MediumProgressWidget(entry: entry)
        case .systemLarge:
            LargeProgressWidget(entry: entry)
        default:
            SmallProgressWidget(entry: entry)
        }
    }
}

// MARK: - Small Widget
struct SmallProgressWidget: View {
    let entry: TeluguProgressEntry
    
    var body: some View {
        ZStack {
            // Glass background
            iOSGlassEffect(
                glassType: .regular,
                cornerRadius: 16,
                enableShimmer: true
            )
            
            VStack(spacing: 8) {
                // Streak
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.teluguOrange)
                Text("\(entry.streak)")
                    .font(.teluguHeadline)
                    .foregroundColor(.primary)
                }
                
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: entry.todayProgress)
                        .stroke(
                            LinearGradient(
                                colors: [.teluguBlue, .culturalPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(entry.todayProgress * 100))%")
                        .font(.teluguCaption)
                        .foregroundColor(.primary)
                }
                
                // Next lesson
                Text(entry.nextLesson)
                    .font(.teluguCaption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding()
        }
    }
}

// MARK: - Medium Widget
struct MediumProgressWidget: View {
    let entry: TeluguProgressEntry
    
    var body: some View {
        ZStack {
            // Glass background
            iOSGlassEffect(
                glassType: .regular,
                cornerRadius: 20,
                enableShimmer: true
            )
            
            HStack(spacing: 16) {
                // Left side - Streak and XP
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.teluguOrange)
                        Text("\(entry.streak) Day Streak")
                            .font(.teluguBody)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.teluguGold)
                        Text("\(entry.totalXP) XP")
                            .font(.teluguBody)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                // Right side - Progress
                VStack(spacing: 8) {
                    Text("Today's Progress")
                        .font(.teluguCaption)
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 6)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: entry.todayProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [.teluguBlue, .culturalPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(entry.todayProgress * 100))%")
                            .font(.teluguCaption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Large Widget
struct LargeProgressWidget: View {
    let entry: TeluguProgressEntry
    
    var body: some View {
        ZStack {
            // Glass background
            iOSGlassEffect(
                glassType: .regular,
                cornerRadius: 24,
                enableShimmer: true
            )
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Telugu Learning")
                            .font(.teluguHeadline)
                            .foregroundColor(.primary)
                        Text("Keep up the great work!")
                            .font(.teluguCaption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "book.fill")
                        .foregroundColor(.teluguBlue)
                        .font(.title2)
                }
                
                // Stats row
                HStack(spacing: 20) {
                    WidgetStatItem(
                        icon: "flame.fill",
                        value: "\(entry.streak)",
                        label: "Streak",
                        color: .teluguOrange
                    )
                    
                    WidgetStatItem(
                        icon: "star.fill",
                        value: "\(entry.totalXP)",
                        label: "XP",
                        color: .teluguGold
                    )
                    
                    WidgetStatItem(
                        icon: "book.fill",
                        value: entry.nextLesson,
                        label: "Next",
                        color: .teluguBlue
                    )
                }
                
                // Progress section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Progress")
                        .font(.teluguBody)
                        .foregroundColor(.primary)
                    
                    HStack {
                        ProgressView(value: entry.todayProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .teluguBlue))
                        
                        Text("\(Int(entry.todayProgress * 100))%")
                            .font(.teluguCaption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Widget Stat Item
struct WidgetStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(value)
                .font(.teluguHeadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(label)
                .font(.teluguCaption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Widget Configuration
struct TeluguProgressWidget: Widget {
    let kind: String = "TeluguProgress"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TeluguProgressProvider()) { entry in
            TeluguProgressWidgetView(entry: entry)
        }
        .configurationDisplayName("Telugu Learning Progress")
        .description("See your daily learning streak and progress")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Siri Shortcuts
import Intents

// MARK: - Start Lesson Intent
class StartLessonIntent: INIntent {
    @NSManaged public var lessonType: String?
    @NSManaged public var difficulty: String?
}

// MARK: - Siri Shortcuts Manager
class SiriShortcutsManager {
    static let shared = SiriShortcutsManager()
    
    private init() {}
    
    func donateStartLessonIntent(lessonType: String, difficulty: String = "beginner") {
        let intent = StartLessonIntent()
        intent.lessonType = lessonType
        intent.difficulty = difficulty
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Failed to donate interaction: \(error)")
            } else {
                print("Successfully donated start lesson intent")
            }
        }
    }
    
    func donateViewProgressIntent() {
        let intent = ViewProgressIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Failed to donate interaction: \(error)")
            } else {
                print("Successfully donated view progress intent")
            }
        }
    }
    
    func donatePlayStoryIntent(storyTitle: String) {
        let intent = PlayStoryIntent()
        intent.storyTitle = storyTitle
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Failed to donate interaction: \(error)")
            } else {
                print("Successfully donated play story intent")
            }
        }
    }
}

// MARK: - Additional Intents
class ViewProgressIntent: INIntent {
    // View progress intent
}

class PlayStoryIntent: INIntent {
    @NSManaged public var storyTitle: String?
}

// MARK: - Widget Bundle
struct TeluguWidgets: WidgetBundle {
    var body: some Widget {
        TeluguProgressWidget()
    }
}

// MARK: - SwiftUI Integration for Widgets
struct WidgetPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Widget Previews")
                .font(.teluguTitle)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                SmallProgressWidget(
                    entry: TeluguProgressEntry(
                        date: Date(),
                        streak: 7,
                        totalXP: 1250,
                        todayProgress: 0.6,
                        nextLesson: "Vowels"
                    )
                )
                .frame(width: 150, height: 150)
                
                MediumProgressWidget(
                    entry: TeluguProgressEntry(
                        date: Date(),
                        streak: 7,
                        totalXP: 1250,
                        todayProgress: 0.6,
                        nextLesson: "Vowels"
                    )
                )
                .frame(width: 300, height: 150)
            }
        }
        .padding()
    }
}

#Preview {
    WidgetPreview()
}
