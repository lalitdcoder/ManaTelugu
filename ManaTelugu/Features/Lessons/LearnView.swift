import SwiftUI

struct LearnView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var curriculumRepo = CurriculumRepository()
    @State private var selectedLevel: Int = 1
    @State private var selectedModule: CurriculumModule? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Card: Curriculum Journey Overview
                    overviewHeaderCard

                    if curriculumRepo.modules.isEmpty {
                        emptyStateCard
                    } else {
                        // Level Selector Picker (Levels 1-4)
                        levelPickerSection

                        // Level Modules List
                        modulesListSection
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Learn Telugu")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(session.currentStreak)d")
                            .font(.subheadline.bold())
                    }
                }
            }
            .refreshable {
                curriculumRepo.loadOfflineCurriculum()
            }
            .fullScreenCover(item: $selectedModule) { module in
                LessonEngineView(module: module)
                    .environmentObject(session)
            }
        }
    }

    // MARK: - Subviews
    private var overviewHeaderCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Telugu Journey")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Text("\(curriculumRepo.modules.count) Course Modules")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "graduationcap.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
            }

            // Progress Bar
            let totalCount = max(1, curriculumRepo.modules.count)
            let completedCount = session.completedLessons
            let progressRatio = min(Double(completedCount) / Double(totalCount), 1.0)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(completedCount) of \(totalCount) Modules Complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(progressRatio * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                }
                ProgressView(value: progressRatio)
                    .tint(.orange)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }

    private var emptyStateCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 40))
                .foregroundColor(.secondary)

            Text("No Modules Loaded")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Tap reload to refresh the offline curriculum.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Reload Curriculum") {
                curriculumRepo.loadOfflineCurriculum()
            }
            .font(.subheadline.bold())
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    private var levelPickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Level")
                .font(.headline)
                .foregroundColor(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    let stagesToDisplay = curriculumRepo.stages.isEmpty ? [1, 2, 3, 4] : curriculumRepo.stages.map { $0.stageNumber }
                    ForEach(stagesToDisplay, id: \.self) { levelNumber in
                        let isSelected = selectedLevel == levelNumber
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedLevel = levelNumber
                                AppleHIGDesign.Haptics.selection()
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text("Level \(levelNumber)")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? Color.orange : Color(uiColor: .secondarySystemGroupedBackground))
                            )
                            .foregroundColor(isSelected ? .white : .primary)
                            .shadow(color: isSelected ? Color.orange.opacity(0.3) : Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var modulesListSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            let currentModules = curriculumRepo.modules(forLevel: selectedLevel).isEmpty ? curriculumRepo.modules : curriculumRepo.modules(forLevel: selectedLevel)

            HStack {
                Text("Level \(selectedLevel) Modules")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(currentModules.count) Modules")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(currentModules) { module in
                moduleRowCard(module)
            }
        }
    }

    private func moduleRowCard(_ module: CurriculumModule) -> some View {
        Button {
            selectedModule = module
            AppleHIGDesign.Haptics.selection()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Text("\(module.moduleNumber)")
                        .font(.headline.bold())
                        .foregroundColor(.orange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(module.title)
                            .font(.body.bold())
                            .foregroundColor(.primary)

                        if let teluguTitle = module.teluguTitle {
                            Text("• \(teluguTitle)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    if let description = module.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    if let minutes = module.estimatedMinutes {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("\(minutes) mins")
                        }
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
