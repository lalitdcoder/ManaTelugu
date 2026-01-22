import SwiftUI

struct LearningInsightsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss

    @State private var insights: [LearningInsight] = []

    private var insightsService: LearningInsightsService {
        LearningInsightsService(lessonsRepository: session.lessonsRepository)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Learning Insights")
                .font(.title2)
                .fontWeight(.semibold)

            if insights.isEmpty {
                Text("Not enough data yet. Complete more lessons to see insights.")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                ForEach(insights, id: \.title) { insight in
                    InsightCard(insight: insight)
                }
            }
        }
        .navigationTitle("Learning Insights")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .onAppear(perform: loadInsights)
    }

    private func loadInsights() {
        insights = insightsService.generateInsights(from: [])
    }
}

private struct InsightCard: View {
    let insight: LearningInsight

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: insight.icon)
                .font(.title)
                .foregroundColor(insight.title.contains("Strength") ? .green : .orange)

            VStack(alignment: .leading) {
                Text(insight.title)
                    .font(.headline)
                Text(insight.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
