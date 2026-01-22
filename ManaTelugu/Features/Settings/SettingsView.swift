import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showingExportSheet = false
    @State private var showingResetConfirmation = false
    @State private var isParentalGateUnlocked = false

    // Settings state
    @State private var soundEffectsEnabled = true
    @State private var hapticFeedbackEnabled = true
    @State private var showingExportSuccess = false
    @State private var exportedFileURL: URL? = nil
    @State private var showDocumentPreview = false

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
            ScrollView(showsIndicators: false) {
                VStack(spacing: ModernDesignSystem.Spacing.xl) {
                    headerSection
                        .padding(.top, ModernDesignSystem.Spacing.xl)
                    audioSection
                    appSection
                    dataSection
                    aboutSection
                }
                .padding(.horizontal, ModernDesignSystem.Spacing.md)
                .padding(.bottom, ModernDesignSystem.Spacing.xl)
            }
        }
        .onAppear {
            session.systemColorScheme = colorScheme
            // Sync local toggles with session services
            soundEffectsEnabled = session.audioFeedback.isEnabled
            hapticFeedbackEnabled = session.hapticsService.isEnabled
        }
        .onChange(of: colorScheme) { _, newScheme in
            session.systemColorScheme = newScheme
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            VStack(spacing: ModernDesignSystem.Spacing.lg) {
                Text("Export Progress")
                    .font(ModernDesignSystem.Typography.title2)
                Text("Your progress data will be exported as a file.")
                    .font(ModernDesignSystem.Typography.body)
                ElegantButton(title: "Export", style: .primary) {
                    exportProgress()
                }
                if showingExportSuccess, let url = exportedFileURL {
                    Text("Export successful! File saved at:\n\(url.path)")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(.green)
                    ElegantButton(title: "Open File", style: .secondary) {
                        showDocumentPreview = true
                    }
                    .sheet(isPresented: $showDocumentPreview) {
                        DocumentPreviewController(url: exportedFileURL!)
                    }
                } else if showingExportSuccess {
                    Text("Export successful!")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(.green)
                }
                ElegantButton(title: "Close", style: .secondary) {
                    showingExportSheet = false
                }
            }
            .padding(ModernDesignSystem.Spacing.xl)
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

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text("Customize your learning experience")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modernCard()
    }

    private var audioSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Audio & Feedback")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            settingToggle("Sound Effects", $soundEffectsEnabled, "speaker.wave.2.fill")
            settingToggle(
                "Haptic Feedback", $session.isHapticsEnabled, "iphone.radiowaves.left.and.right")
        }
        .modernCard()
    }

    private var appSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Appearance")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
            Toggle(isOn: $session.darkModeEnabled) {
                HStack {
                    Image(systemName: "moon.fill")
                        .font(.title3)
                        .foregroundColor(ModernDesignSystem.Colors.primary)
                        .frame(width: 24)
                    Text("Dark Mode")
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textPrimary)
                }
            }
            .onChange(of: session.darkModeEnabled) { _, _ in
                HapticsManager.shared.selection()
            }
            .tint(ModernDesignSystem.Colors.primary)
        }
        .modernCard()
    }

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("Data Management")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Button(action: {
                HapticsService.shared.buttonTap()
                showingExportSheet = true
            }) {
                settingButton(
                    "Export Progress", "square.and.arrow.up", ModernDesignSystem.Colors.primary)
            }

            Button(action: {
                HapticsService.shared.warning()
                showingResetConfirmation = true
            }) {
                settingButton("Reset Progress", "trash.fill", .red)
            }
        }
        .modernCard()
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.md) {
            Text("About the Developer")
                .font(ModernDesignSystem.Typography.headline)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            HStack(alignment: .top, spacing: ModernDesignSystem.Spacing.md) {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2)
                    .foregroundColor(.red)

                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text("ManaTelugu Version 3.0")
                        .font(ModernDesignSystem.Typography.subheadline)
                        .fontWeight(.bold)
                    Text(
                        "Built with ❤️ by a 12-year-old developer in England. Dedicated to preserving the Telugu language for the next generation."
                    )
                    .font(ModernDesignSystem.Typography.caption)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
            }
            .padding(.top, ModernDesignSystem.Spacing.xs)
        }
        .modernCard()
    }

    private func settingToggle(_ title: String, _ binding: Binding<Bool>, _ icon: String)
        -> some View
    {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ModernDesignSystem.Colors.primary)
                .frame(width: 24)

            Text(title)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Spacer()

            Toggle("", isOn: binding)
                .tint(ModernDesignSystem.Colors.primary)
                .onChange(of: binding.wrappedValue) { _, newValue in
                    // Use selection feedback for toggles per HIG
                    HapticsManager.shared.selection()
                    if title == "Sound Effects" {
                        session.audioFeedback.isEnabled = newValue
                    } else if title == "Haptic Feedback" {
                        // Synced handled via AppSession didSet binding
                    } else if title == "Dark Mode" {
                        // Already provided selection feedback above
                    }
                }
        }
        .padding(.vertical, ModernDesignSystem.Spacing.xs)
    }

    private func settingButton(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)

            Text(title)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ModernDesignSystem.Colors.textTertiary)
        }
        .padding(.vertical, ModernDesignSystem.Spacing.xs)
    }

    private func exportProgress() {
        let lessonProgress = session.progressTrackingService.lessonProgress
        let storiesLearned = lessonProgress.filter { $0.isCompleted }.count
        let wordsLearned = lessonProgress.reduce(0) { $0 + $1.correctAnswers }
        let summary: [String: Any] = [
            "storiesLearned": storiesLearned,
            "wordsLearned": wordsLearned,
            "totalLessons": lessonProgress.count,
            "rawProgress": lessonProgress.map { $0.dictionary },
        ]
        if let data = try? JSONSerialization.data(withJSONObject: summary, options: .prettyPrinted)
        {
            let fileName = "ManaTelugu_Progress_Export_\(Date().timeIntervalSince1970).json"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            do {
                try data.write(to: url)
                exportedFileURL = url
                showingExportSuccess = true
            } catch {
                showingExportSuccess = false
            }
        } else {
            showingExportSuccess = false
        }
    }
    private func resetProgress() {
        session.progressTrackingService.lessonProgress.removeAll()
        UserDefaults.standard.removeObject(forKey: "lessonProgress")
        session.progressTrackingService.lessonProgress = []
        // Optionally reload or notify other services/views here
    }
}

struct DocumentPreviewController: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> UIDocumentInteractionControllerView {
        UIDocumentInteractionControllerView(url: url)
    }
    func updateUIViewController(
        _ uiViewController: UIDocumentInteractionControllerView, context: Context
    ) {}
}

class UIDocumentInteractionControllerView: UIViewController, UIDocumentInteractionControllerDelegate
{
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
    func documentInteractionControllerViewControllerForPreview(
        _ controller: UIDocumentInteractionController
    ) -> UIViewController {
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
            "attempts": attempts,
        ]
    }
}
