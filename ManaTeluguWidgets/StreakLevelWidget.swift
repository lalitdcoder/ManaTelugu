import WidgetKit
import SwiftUI

// Shared app group for data exchange
private let appGroupId = "group.com.LalitDusanapudi.ManaTelugu"

struct StreakLevelEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let level: Int
}

struct StreakLevelProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakLevelEntry {
        StreakLevelEntry(date: Date(), streak: 3, level: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakLevelEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakLevelEntry>) -> Void) {
        let entry = loadEntry()
        // Refresh every 30 minutes
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func loadEntry() -> StreakLevelEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let streak = defaults?.integer(forKey: "widget_streak") ?? 0
        let level = defaults?.integer(forKey: "widget_level") ?? 1
        return StreakLevelEntry(date: Date(), streak: streak, level: level)
    }
}

struct StreakLevelWidgetView: View {
    let entry: StreakLevelEntry

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.25), Color.cyan.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill").foregroundColor(.orange)
                    Text("Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("\(entry.streak) days")
                    .font(.title2).bold()
                    .foregroundColor(.primary)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("\(entry.level)")
                    .font(.title3).bold()
                    .foregroundColor(.primary)
            }
            .padding()
        }
    }
}

@main
struct StreakLevelWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "StreakLevelWidget", provider: StreakLevelProvider()) { entry in
            StreakLevelWidgetView(entry: entry)
        }
        .configurationDisplayName("Learning Streak")
        .description("Shows your streak days and current level.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


