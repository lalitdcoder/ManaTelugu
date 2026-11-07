import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showingExportSheet = false
    @State private var showingResetConfirmation = false

    @State private var soundEffectsEnabled = true
    @State private var hapticFeedbackEnabled = true
    @State private var showingExportSuccess = false
    @State private var exportedFileURL: URL? = nil
    @State private var showDocumentPreview = false

    private let midnightIndigo = Color(red: 0.18, green: 0.13, blue: 0.42)
    private let saffronGold = Color(red: 0.98, green: 0.67, blue: 0.12)

    var body: some View {
        ZStack {
            // Premium deep purple gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.11, blue: 0.35),
                    Color(red: 0.08, green: 0.05, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Privacy shield banner (top priority)
                    privacyBanner
                        .padding(.top, 16)

                    // Audio & Feedback
                    audioSection

                    // Appearance
                    appearanceSection

                    // Data Management
                    dataSection

                    // About
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            session.systemColorScheme = colorScheme
            soundEffectsEnabled = session.audioFeedback.isEnabled
            hapticFeedbackEnabled = session.hapticsService.isEnabled
        }
        .onChange(of: colorScheme) { _, newScheme in
            session.systemColorScheme = newScheme
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            exportSheet
        }
        .alert("Reset Progress", isPresented: $showingResetConfirmation) {
            Button("Reset", role: .destructive) {
                HapticsService.shared.error()
                resetProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to reset all progress? This cannot be undone.")
        }
    }

    // MARK: - Privacy Banner (NEW — top section)
    private var privacyBanner: some View {
        NavigationLink(destination: PrivacyPolicyView()) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [saffronGold, Color(red: 1.0, green: 0.82, blue: 0.40)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: saffronGold.opacity(0.35), radius: 10, x: 0, y: 4)

                    Image(systemName: "shield.checkmark.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(midnightIndigo)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Privacy Protected")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("100% offline")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color(red: 0.13, green: 0.62, blue: 0.41))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(red: 0.13, green: 0.62, blue: 0.41).opacity(0.12))
                            .clipShape(Capsule())
                    }

                    Text("All your data stays on your device — never shared")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(saffronGold.opacity(0.30), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Audio Section
    private var audioSection: some View {
        settingsCard(title: "Audio & Feedback", icon: "speaker.wave.2.fill", iconColor: midnightIndigo) {
            VStack(spacing: 0) {
                settingToggleRow("Sound Effects", icon: "speaker.wave.2.fill", iconColor: .blue,
                                 binding: $soundEffectsEnabled) { newVal in
                    session.audioFeedback.isEnabled = newVal
                }

                Divider().padding(.leading, 52)

                settingToggleRow("Haptic Feedback", icon: "iphone.radiowaves.left.and.right", iconColor: .purple,
                                 binding: $session.isHapticsEnabled) { _ in }
            }
        }
    }

    // MARK: - Appearance Section
    private var appearanceSection: some View {
        settingsCard(title: "Appearance", icon: "paintbrush.fill", iconColor: .orange) {
            settingToggleRow("Dark Mode", icon: "moon.fill", iconColor: .indigo,
                             binding: $session.darkModeEnabled) { _ in
                HapticsManager.shared.selection()
            }
        }
    }

    // MARK: - Data Section
    private var dataSection: some View {
        settingsCard(title: "Data Management", icon: "externaldrive.fill", iconColor: .teal) {
            VStack(spacing: 0) {
                Button {
                    HapticsService.shared.buttonTap()
                    showingExportSheet = true
                } label: {
                    settingActionRow("Export Progress", icon: "square.and.arrow.up", iconColor: .blue)
                }
                .buttonStyle(.plain)

                Divider().padding(.leading, 52)

                Button {
                    HapticsService.shared.warning()
                    showingResetConfirmation = true
                } label: {
                    settingActionRow("Reset Progress", icon: "trash.fill", iconColor: .red)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - About Section
    private var aboutSection: some View {
        settingsCard(title: "About ManaTelugu", icon: "heart.text.square.fill", iconColor: .red) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [midnightIndigo, Color(red: 0.32, green: 0.18, blue: 0.62)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)

                        Text("మ")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("ManaTelugu v3.0")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("Telugu Learning App")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }

                Text("Built with ❤️ by a 12-year-old developer in England, dedicated to preserving the Telugu language for the next generation.")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }
        }
    }

    // MARK: - Helper View Builders
    @ViewBuilder
    private func settingsCard<Content: View>(
        title: String, icon: String, iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.3)
            }
            .padding(.horizontal, 4)

            content()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                )
        }
    }

    private func settingToggleRow(
        _ title: String, icon: String, iconColor: Color,
        binding: Binding<Bool>,
        onChange: @escaping (Bool) -> Void
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 7))

            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(.primary)

            Spacer()

            Toggle("", isOn: binding)
                .tint(midnightIndigo)
                .onChange(of: binding.wrappedValue) { _, newVal in
                    HapticsManager.shared.selection()
                    onChange(newVal)
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func settingActionRow(_ title: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 7))

            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(iconColor == .red ? .red : .primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Export Sheet
    private var exportSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(midnightIndigo)

                VStack(spacing: 8) {
                    Text("Export Progress")
                        .font(.title2.bold())

                    Text("Your progress will be exported as a JSON file to your device's Documents folder.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Button {
                    exportProgress()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(midnightIndigo)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if showingExportSuccess {
                    Label("Export successful!", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(red: 0.13, green: 0.62, blue: 0.41))
                }

                Button("Close") {
                    showingExportSheet = false
                }
                .foregroundStyle(.secondary)
            }
            .padding(32)
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(24)
    }

    // MARK: - Actions
    private func exportProgress() {
        let lessonProgress = session.progressTrackingService.lessonProgress
        let storiesLearned = lessonProgress.filter { $0.isCompleted }.count
        let wordsLearned = lessonProgress.reduce(0) { $0 + $1.correctAnswers }
        let summary: [String: Any] = [
            "storiesLearned": storiesLearned,
            "wordsLearned": wordsLearned,
            "totalLessons": lessonProgress.count,
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "rawProgress": lessonProgress.map { $0.dictionary }
        ]
        if let data = try? JSONSerialization.data(withJSONObject: summary, options: .prettyPrinted) {
            let fileName = "ManaTelugu_Progress_\(Int(Date().timeIntervalSince1970)).json"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            do {
                try data.write(to: url)
                exportedFileURL = url
                showingExportSuccess = true
            } catch {
                showingExportSuccess = false
            }
        }
    }

    private func resetProgress() {
        let keysToRemove = [
            "lessonProgress", "completedLessons", "currentXP", "currentLevel",
            "totalXP", "streak", "lastActiveDate", "badges", "unlockedBadges",
            "xpHistory", "learnedLetters", "masteredWords", "completedStories", "gamificationState"
        ]
        for key in keysToRemove { UserDefaults.standard.removeObject(forKey: key) }
        session.progressTrackingService.lessonProgress.removeAll()
        session.progressTrackingService.lessonProgress = []
        session.gamificationService.resetProgress()
        session.dataRepository.resetProgress()
        UserDefaults.standard.synchronize()
        HapticsManager.shared.notification(.success)
        DispatchQueue.main.async { self.session.objectWillChange.send() }
    }
}

// MARK: - Document Preview
struct DocumentPreviewController: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> UIDocumentInteractionControllerView {
        UIDocumentInteractionControllerView(url: url)
    }
    func updateUIViewController(_ uiViewController: UIDocumentInteractionControllerView, context: Context) {}
}

class UIDocumentInteractionControllerView: UIViewController, UIDocumentInteractionControllerDelegate {
    let url: URL
    var docController: UIDocumentInteractionController?
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func viewDidLoad() {
        super.viewDidLoad()
        docController = UIDocumentInteractionController(url: url)
        docController?.delegate = self
        docController?.presentPreview(animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension LessonProgress {
    var dictionary: [String: Any] {
        [
            "lessonId": lessonId,
            "isCompleted": isCompleted,
            "completionDate": completionDate?.description ?? "",
            "xpEarned": xpEarned,
            "correctAnswers": correctAnswers,
            "totalQuestions": totalQuestions,
            "timeSpent": timeSpent,
            "attempts": attempts
        ]
    }
}
