import SwiftUI

// MARK: - Modern Alphabet Hub View
struct ProfessionalAlphabetHubView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [Letter] = []
    @State private var isLoading = true
    @State private var navigateToQuiz = false
    @State private var navigateToVowels = false
    @State private var navigateToConsonants = false
    @State private var navigateToTracing = false
    @State private var navigateToGudinthalu = false
    @State private var animateStats = false
    @State private var animateProgress = false

    var vowels: [Letter] { letters.filter { $0.category == .vowel } }
    var consonants: [Letter] { letters.filter { $0.category == .consonant } }
    var learnedCount: Int { letters.filter { $0.isLearned }.count }
    var progressPercentage: Double {
        letters.isEmpty ? 0 : Double(learnedCount) / Double(letters.count)
    }

    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(AppleHIGDesign.Colors.primary)
                    Text("Loading alphabet...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Compact Hero Section
                        compactHeroSection
                            .padding(.top, -20)

                        // Learning Modes
                        learningModesSection

                        // Bottom padding
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            loadLetters()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateStats = true
            }
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.4)) {
                animateProgress = true
            }
        }
        .fullScreenCover(isPresented: $navigateToVowels) {
            NavigationStack {
                VowelsView()
            }
        }
        .fullScreenCover(isPresented: $navigateToConsonants) {
            NavigationStack {
                ConsonantsView()
            }
        }
        .fullScreenCover(isPresented: $navigateToTracing) {
            NavigationStack {
                TraceGameView()
            }
        }
        .fullScreenCover(isPresented: $navigateToGudinthalu) {
            NavigationStack {
                GudinthaluView()
            }
        }
        .fullScreenCover(isPresented: $navigateToQuiz) {
            NavigationStack {
                LettersQuizView(scope: .all)
            }
        }
        .navigationTitle("Telugu Alphabet")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08),
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
    }

    // MARK: - Compact Hero Section
    private var compactHeroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Master Telugu Script")
                .font(.title2.bold())
                .foregroundColor(.primary)

            Text("Interactive learning with 52 letters")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
    }

    // MARK: - Stats Cards with Telugu Glyphs
    private var statsCardsSection: some View {
        HStack(spacing: 16) {
            AlphabetStatCard(
                glyph: "అ",
                count: vowels.count,
                label: "Vowels",
                color: .blue
            )
            .scaleEffect(animateStats ? 1.0 : 0.8)
            .opacity(animateStats ? 1.0 : 0.0)

            AlphabetStatCard(
                glyph: "క",
                count: consonants.count,
                label: "Consonants",
                color: .green
            )
            .scaleEffect(animateStats ? 1.0 : 0.8)
            .opacity(animateStats ? 1.0 : 0.0)
            .animation(.spring().delay(0.1), value: animateStats)

            AlphabetStatCard(
                glyph: "అక్",
                count: letters.count,
                label: "Total",
                color: .purple
            )
            .scaleEffect(animateStats ? 1.0 : 0.8)
            .opacity(animateStats ? 1.0 : 0.0)
            .animation(.spring().delay(0.2), value: animateStats)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    // MARK: - Learning Progress Section
    private var learningProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3.bold())
                    .foregroundColor(.blue)

                Text("Learning Progress")
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                Spacer()

                Text("\(learnedCount)/\(letters.count)")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
            }

            // Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(Int(progressPercentage * 100))% Complete")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: animateProgress
                                    ? geometry.size.width * progressPercentage : 0,
                                height: 8
                            )
                            .animation(.easeInOut(duration: 1.2), value: animateProgress)
                    }
                }
                .frame(height: 8)
            }

            // Quick Stats
            HStack(spacing: 20) {
                ProgressStatItem(
                    icon: "checkmark.circle.fill",
                    value: "\(learnedCount)",
                    label: "Learned",
                    color: .green
                )

                ProgressStatItem(
                    icon: "clock.fill",
                    value: "5m",
                    label: "Today",
                    color: .blue
                )

                ProgressStatItem(
                    icon: "flame.fill",
                    value: "\(session.currentStreak)",
                    label: "Streak",
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .scaleEffect(animateProgress ? 1.0 : 0.95)
        .opacity(animateProgress ? 1.0 : 0.0)
    }

    // MARK: - Individual Letters Section
    private var individualLettersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Telugu Letters")
                .font(.headline.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 4)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12
            ) {
                ForEach(Array(letters.enumerated()), id: \.element.id) { index, letter in
                    NavigationLink {
                        LetterDetailView(letters: letters, initialIndex: index)
                    } label: {
                        VStack(spacing: 4) {
                            Text(letter.character)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.primary)

                            if letter.isLearned {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(letter.isLearned ? .green.opacity(0.1) : .gray.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    letter.isLearned ? .green.opacity(0.3) : .gray.opacity(0.2),
                                    lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Learning Modes Section
    private var learningModesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Modes")
                .font(.headline.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                LearningModeCard(
                    title: "Vowels",
                    description: "Learn Telugu vowel sounds",
                    icon: "textformat.abc",
                    color: .blue,
                    action: { navigateToVowels = true }
                )

                LearningModeCard(
                    title: "Consonants",
                    description: "Master consonant letters",
                    icon: "textformat.abc",
                    color: .green,
                    action: { navigateToConsonants = true }
                )

                LearningModeCard(
                    title: "Gudinthalu",
                    description: "Consonant-vowel combinations",
                    icon: "character.textbox",
                    color: .indigo,
                    action: { navigateToGudinthalu = true }
                )

                LearningModeCard(
                    title: "Practice Writing",
                    description: "Trace and write letters",
                    icon: "pencil.tip",
                    color: .orange,
                    action: { navigateToTracing = true }
                )

                LearningModeCard(
                    title: "Letter Quiz",
                    description: "Test your knowledge",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    action: { navigateToQuiz = true }
                )
            }
        }
    }

    private func loadLetters() {
        letters = session.dataRepository.letters
        isLoading = false
    }
}

// MARK: - Supporting Views
struct AlphabetStatCard: View {
    let glyph: String
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(glyph)
                .font(.title.bold())
                .foregroundColor(color)

            Text("\(count)")
                .font(.title2.bold())
                .foregroundColor(.primary)

            Text(label)
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct ProgressStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.bold())
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)

                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct LearningModeCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2.bold())
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct LearningModeCardView: View {
    let title: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2.bold())
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Replace the original AlphabetHubView
typealias AlphabetHubView = ProfessionalAlphabetHubView
