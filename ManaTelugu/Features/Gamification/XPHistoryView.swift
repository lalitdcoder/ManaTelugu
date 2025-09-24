import SwiftUI

struct XPHistoryView: View {
    @ObservedObject var gamification: GamificationState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: TimeFrame = .week
    @State private var showingStats = false
    
    enum TimeFrame: String, CaseIterable {
        case day = "Today"
        case week = "This Week"
        case month = "This Month"
        case all = "All Time"
    }
    
    var filteredEvents: [XPEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeframe {
        case .day:
            return gamification.xpHistory.filter { calendar.isDate($0.timestamp, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return gamification.xpHistory.filter { $0.timestamp >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return gamification.xpHistory.filter { $0.timestamp >= monthAgo }
        case .all:
            return gamification.xpHistory
        }
    }
    
    var totalXPInTimeframe: Int {
        filteredEvents.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Enhanced background gradient for Liquid Glass effect
                Color.clear
                    .liquidGlassBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Stats Header
                    VStack(spacing: MTSpacing.medium) {
                        // Timeframe Selector
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                                Text(timeframe.rawValue).tag(timeframe)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        // XP Summary
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(totalXPInTimeframe) XP")
                                    .font(MTTypography.title())
                                    .foregroundColor(.primary)
                                Text("Earned \(selectedTimeframe.rawValue.lowercased())")
                                    .font(MTTypography.body())
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: { showingStats = true }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                    .foregroundColor(MTColors.primary)
                            }
                        }
                        .padding(.horizontal, MTSpacing.medium)
                    }
                    .padding(.vertical, MTSpacing.medium)
                    .background(Color(.systemGroupedBackground))
                    
                    // XP Events List
                    if filteredEvents.isEmpty {
                        EmptyStateView(timeframe: selectedTimeframe)
                    } else {
                        EnhancedScrollView {
                            LazyVStack(spacing: MTSpacing.small) {
                                ForEach(filteredEvents.reversed()) { event in
                                    XPEventRowView(event: event)
                                }
                            }
                            .padding(.horizontal, MTSpacing.medium)
                            .padding(.bottom, MTSpacing.large)
                        }
                    }
                }
            }
            .navigationTitle("XP History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingStats) {
            XPStatsView(gamification: gamification, timeframe: selectedTimeframe)
        }
    }
}

// MARK: - XP Event Row View
struct XPEventRowView: View {
    let event: XPEvent
    
    var body: some View {
        HStack(spacing: MTSpacing.medium) {
            // Event Icon
            ZStack {
                Circle()
                    .fill(Color(event.type.color))
                    .frame(width: 40, height: 40)
                
                Image(systemName: event.type.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Event Details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.description)
                    .font(MTTypography.body())
                    .foregroundColor(.primary)
                
                if let associatedData = event.associatedData {
                    Text(associatedData)
                        .font(MTTypography.caption())
                        .foregroundColor(.secondary)
                }
                
                Text(event.timestamp, style: .relative)
                    .font(MTTypography.caption2())
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // XP Amount
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(MTColors.funYellow)
                Text("+\(event.amount)")
                    .font(MTTypography.body())
                    .fontWeight(.semibold)
                    .foregroundColor(MTColors.funYellow)
            }
        }
        .padding(MTSpacing.medium)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
        )
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let timeframe: XPHistoryView.TimeFrame
    
    var body: some View {
        VStack(spacing: MTSpacing.large) {
            Image(systemName: "star")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            VStack(spacing: MTSpacing.small) {
                Text("No XP Yet")
                    .font(MTTypography.heading())
                    .foregroundColor(.primary)
                
                Text("Complete activities to start earning XP!")
                    .font(MTTypography.body())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - XP Stats View
struct XPStatsView: View {
    @ObservedObject var gamification: GamificationState
    let timeframe: XPHistoryView.TimeFrame
    @Environment(\.dismiss) private var dismiss
    
    var filteredEvents: [XPEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeframe {
        case .day:
            return gamification.xpHistory.filter { calendar.isDate($0.timestamp, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return gamification.xpHistory.filter { $0.timestamp >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return gamification.xpHistory.filter { $0.timestamp >= monthAgo }
        case .all:
            return gamification.xpHistory
        }
    }
    
    var eventTypeStats: [(XPEventType, Int)] {
        let grouped = Dictionary(grouping: filteredEvents) { $0.type }
        return grouped.map { (type, events) in
            (type, events.reduce(0) { $0 + $1.amount })
        }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        NavigationStack {
            EnhancedScrollView {
                VStack(spacing: MTSpacing.large) {
                    // Total XP
                    VStack(spacing: MTSpacing.small) {
                        Text("\(filteredEvents.reduce(0) { $0 + $1.amount })")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(MTColors.primary)
                        Text("Total XP \(timeframe.rawValue.lowercased())")
                            .font(MTTypography.body())
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    
                    // Event Type Breakdown
                    VStack(alignment: .leading, spacing: MTSpacing.medium) {
                        Text("Breakdown by Activity")
                            .font(MTTypography.heading())
                            .foregroundColor(.primary)
                        
                        ForEach(eventTypeStats, id: \.0) { (type, totalXP) in
                            HStack {
                                Image(systemName: type.icon)
                                    .font(.title3)
                                    .foregroundColor(Color(type.color))
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(type.description)
                                        .font(MTTypography.body())
                                        .foregroundColor(.primary)
                                    Text("\(filteredEvents.filter { $0.type == type }.count) times")
                                        .font(MTTypography.caption())
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(totalXP) XP")
                                    .font(MTTypography.body())
                                    .fontWeight(.semibold)
                                    .foregroundColor(MTColors.primary)
                            }
                            .padding(.vertical, MTSpacing.small)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                }
                .padding()
            }
            .navigationTitle("XP Statistics")
            .navigationBarTitleDisplayMode(.inline)
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

// MARK: - XPEventType Extensions
extension XPEventType {
    var icon: String {
        switch self {
        case .wordLearned: return "book.fill"
        case .quizCompleted: return "brain.head.profile"
        case .streakMaintained: return "flame.fill"
        case .badgeEarned: return "star.fill"
        case .dailyGoal: return "target"
        case .perfectQuiz: return "checkmark.seal.fill"
        case .firstWord: return "sparkles"
        case .weekStreak: return "calendar"
        case .monthStreak: return "crown.fill"
        }
    }
    
    var color: String {
        switch self {
        case .wordLearned: return "funBlue"
        case .quizCompleted: return "funGreen"
        case .streakMaintained: return "funYellow"
        case .badgeEarned: return "funPink"
        case .dailyGoal: return "primary"
        case .perfectQuiz: return "success"
        case .firstWord: return "accent"
        case .weekStreak: return "warning"
        case .monthStreak: return "error"
        }
    }
}

#Preview {
    XPHistoryView(gamification: GamificationState())
}
