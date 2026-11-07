import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var learnerRepo = LearnerRepository.shared
    @State private var selectedSkillPractice: String? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Targeted Practice")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)

                        Text("Strengthen your Telugu skills based on your learning journey.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Section 1: Mistakes Review (if any active mistakes exist)
                    if !learnerRepo.activeMistakes.isEmpty {
                        mistakesReviewCard
                    }

                    // Section 2: Recommended Skills Focus Grid
                    skillsFocusSection

                    // Section 3: Interactive Skills Practice
                    interactiveGamesSection
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Practice")
            .sheet(item: $selectedSkillPractice) { skill in
                skillPracticeSheet(skill: skill)
            }
        }
    }

    // MARK: - Subviews
    private var mistakesReviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("\(learnerRepo.activeMistakes.count) Unresolved Mistakes")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }

            Text("Review and clear phrases you recently struggled with during lessons.")
                .font(.caption)
                .foregroundColor(.secondary)

            Button {
                selectedSkillPractice = "mistakes"
                HapticsManager.shared.impact(.medium)
            } label: {
                Text("Review Recent Mistakes")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }

    private var skillsFocusSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Skills Breakdown")
                .font(.title3.bold())
                .foregroundColor(.primary)

            let skills = [
                ("comprehension", "Comprehension", "brain.head.profile", Color.purple),
                ("vocabulary", "Vocabulary", "book.fill", Color.blue),
                ("reading", "Reading Script", "eye.fill", Color.green),
                ("sentence_construction", "Sentence Building", "character.cursor", Color.orange),
                ("listening", "Listening", "speaker.wave.2.fill", Color.pink),
                ("speaking", "Speaking Practice", "mic.fill", Color.red)
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(skills, id: \.0) { key, title, icon, color in
                    let score = learnerRepo.skillScores[key] ?? 0.5
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: icon)
                                .foregroundColor(color)
                            Spacer()
                            Text("\(Int(score * 100))%")
                                .font(.caption.bold())
                                .foregroundColor(color)
                        }

                        Text(title)
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)

                        ProgressView(value: score)
                            .tint(color)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    )
                }
            }
        }
    }

    private var interactiveGamesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Skill Practice Modules")
                .font(.title3.bold())
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                practiceRowCard(
                    title: "Vocabulary Match",
                    subtitle: "Match Telugu terms with English meanings",
                    icon: "rectangle.stack.fill",
                    color: .blue,
                    destination: AnyView(VocabularyCardsView(theme: "General").environmentObject(session))
                )

                practiceRowCard(
                    title: "Sentence Builder",
                    subtitle: "Construct proper Telugu sentences step-by-step",
                    icon: "text.bubble.fill",
                    color: .orange,
                    destination: AnyView(SentenceBuilderGameView().environmentObject(session))
                )

                practiceRowCard(
                    title: "Listening Challenge",
                    subtitle: "Identify spoken Telugu words & pronunciations",
                    icon: "ear.fill",
                    color: .pink,
                    destination: AnyView(ListeningChallengeGameView().environmentObject(session))
                )

                practiceRowCard(
                    title: "Trace & Write Script",
                    subtitle: "Practice writing Telugu letters accurately",
                    icon: "pencil.tip",
                    color: .green,
                    destination: AnyView(TraceGameView().environmentObject(session))
                )
            }
        }
    }

    private func practiceRowCard(title: String, subtitle: String, icon: String, color: Color, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.headline)
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.bold())
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
    }

    private func skillPracticeSheet(skill: String) -> some View {
        VStack(spacing: 20) {
            Text("Reviewing \(skill == "mistakes" ? "Recent Mistakes" : skill.capitalized)")
                .font(.title2.bold())
                .padding(.top)

            if learnerRepo.activeMistakes.isEmpty {
                Text("Great job! You have no unresolved mistakes right now.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Text("\(learnerRepo.activeMistakes.count) items ready for practice.")
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Clear All Reviewed Mistakes") {
                learnerRepo.activeMistakes.removeAll()
                selectedSkillPractice = nil
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.orange)
            .cornerRadius(12)
            .padding()
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
