import SwiftUI

// MARK: - Entry Point (list of practice prompts)

struct PronunciationHubView: View {
    @EnvironmentObject var session: AppSession
    @StateObject private var sttService = SarvamSpeechToTextService()
    @Environment(\.dismiss) private var dismiss

    private let practiceSets: [PracticeSet] = PracticeSet.allSets

    // Programmatic navigation – avoids ButtonStyle / gesture conflicts
    @State private var selectedSetIndex: Int? = nil
    @State private var showFreestyle: Bool = false

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    freeStyleCard
                    setsGrid
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Pronunciation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        // Freestyle destination
        .navigationDestination(isPresented: $showFreestyle) {
            PronunciationPracticeView(practiceSet: PracticeSet.freestyle)
                .environmentObject(session)
                .environmentObject(sttService)
        }
        // Keyed set destination
        .navigationDestination(
            isPresented: Binding(
                get: { selectedSetIndex != nil },
                set: { if !$0 { selectedSetIndex = nil } }
            )
        ) {
            if let idx = selectedSetIndex, practiceSets.indices.contains(idx) {
                PronunciationPracticeView(practiceSet: practiceSets[idx])
                    .environmentObject(session)
                    .environmentObject(sttService)
            }
        }
    }

    // MARK: - Subviews

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.35),
                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.25),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.35, blue: 0.95),
                                    Color(red: 0.35, green: 0.55, blue: 0.95),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Pronunciation Practice")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Speak Telugu & get instant feedback")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }

    private var freeStyleCard: some View {
        Button {
            showFreestyle = true
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.45, blue: 0.35),
                                    Color(red: 0.85, green: 0.25, blue: 0.55),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    Image(systemName: "mic.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Free Practice")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Speak anything in Telugu — no prompt")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }

    private var setsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Practice Sets")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)],
                spacing: 14
            ) {
                ForEach(Array(practiceSets.enumerated()), id: \.element.id) { idx, set in
                    Button {
                        selectedSetIndex = idx
                    } label: {
                        PracticeSetCard(set: set)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Practice Set Card

private struct PracticeSetCard: View {
    let set: PracticeSet

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(set.gradient)
                    .frame(width: 44, height: 44)
                Image(systemName: set.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(set.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text("\(set.prompts.count) phrases")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 4) {
                difficultyDots(set.difficulty)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
        .contentShape(Rectangle())
    }

    private func difficultyDots(_ level: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(
                        i < level
                            ? AnyShapeStyle(set.gradient)
                            : AnyShapeStyle(Color.secondary.opacity(0.25))
                    )
                    .frame(width: 6, height: 6)
            }
        }
    }
}

// MARK: - Main Practice Screen

struct PronunciationPracticeView: View {
    @EnvironmentObject var session: AppSession
    @EnvironmentObject var sttService: SarvamSpeechToTextService
    @StateObject private var onDeviceService = OnDeviceSpeechService()

    let practiceSet: PracticeSet

    // MARK: - Engine selection
    enum RecognitionEngine: String, CaseIterable {
        case onDevice = "On-Device"
        case sarvam = "Sarvam AI"

        var icon: String {
            switch self {
            case .onDevice: return "iphone"
            case .sarvam: return "cloud"
            }
        }
        var description: String {
            switch self {
            case .onDevice: return "Private · no data leaves your phone"
            case .sarvam: return "Higher accuracy · requires internet"
            }
        }
    }
    @State private var selectedEngine: RecognitionEngine = .sarvam

    // MARK: - View State
    @State private var currentIndex: Int = 0
    @State private var showResult: Bool = false
    @State private var pulseRecordButton: Bool = false
    @State private var showPermissionAlert: Bool = false
    @State private var recordingSeconds: Int = 0
    @State private var timer: Timer? = nil
    @Environment(\.dismiss) private var dismiss

    // MARK: - Active engine helpers (route reads to the right service)
    private var activeIsRecording: Bool {
        selectedEngine == .sarvam ? sttService.isRecording : onDeviceService.isRecording
    }
    private var activeIsProcessing: Bool {
        selectedEngine == .sarvam ? sttService.isProcessing : onDeviceService.isProcessing
    }
    private var activeAudioLevel: Float {
        selectedEngine == .sarvam ? sttService.audioLevel : onDeviceService.audioLevel
    }
    private var activeLastResult: PronunciationResult? {
        selectedEngine == .sarvam ? sttService.lastResult : onDeviceService.lastResult
    }
    private var activeErrorMessage: String? {
        selectedEngine == .sarvam ? sttService.errorMessage : onDeviceService.errorMessage
    }
    private var activePermission: Bool {
        selectedEngine == .sarvam ? sttService.permissionGranted : onDeviceService.permissionGranted
    }

    private var currentPrompt: PracticePrompt? {
        guard practiceSet.prompts.indices.contains(currentIndex) else { return nil }
        return practiceSet.prompts[currentIndex]
    }

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                if !practiceSet.prompts.isEmpty {
                    progressBar
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }

                ScrollView {
                    VStack(spacing: 24) {
                        // Engine picker
                        enginePicker

                        // Prompt card
                        if let prompt = currentPrompt {
                            promptCard(prompt)
                        }

                        // Waveform / idle indicator
                        waveformSection

                        // Record button
                        recordButtonSection

                        // Result card
                        if showResult, let result = activeLastResult {
                            ResultCard(result: result)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                        }

                        // Error
                        if let err = activeErrorMessage {
                            ErrorBanner(message: err)
                                .transition(.opacity)
                        }

                        // Navigation
                        if showResult {
                            navigationButtons
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(practiceSet.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if activeIsRecording {
                        selectedEngine == .sarvam
                            ? sttService.stopRecording() : onDeviceService.stopRecording()
                    }
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .alert(
            "Permission Required",
            isPresented: $showPermissionAlert
        ) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                selectedEngine == .sarvam
                    ? "Please allow microphone access in Settings to use pronunciation practice."
                    : "Please allow microphone and speech recognition access in Settings."
            )
        }
        .task {
            if !sttService.permissionGranted {
                await sttService.requestPermission()
            }
        }
        // Mirror recording state changes from both engines for the pulse animation
        .onChange(of: activeIsRecording) { _, recording in
            if recording {
                startRecordingTimer()
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    pulseRecordButton = true
                }
            } else {
                stopRecordingTimer()
                pulseRecordButton = false
            }
        }
        // Reset UI state when switching engine mid-session
        .onChange(of: selectedEngine) { [selectedEngine] _, newEngine in
            guard selectedEngine != newEngine else { return }
            withAnimation {
                showResult = false
                sttService.lastResult = nil
                sttService.errorMessage = nil
                onDeviceService.lastResult = nil
                onDeviceService.errorMessage = nil
            }
        }
    }

    // MARK: - Engine Picker

    private var enginePicker: some View {
        VStack(spacing: 6) {
            // Segmented control
            HStack(spacing: 0) {
                ForEach(RecognitionEngine.allCases, id: \.self) { engine in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedEngine = engine
                        }
                        // Lazily request on-device permission when first selected
                        if engine == .onDevice && !onDeviceService.permissionGranted {
                            Task { await onDeviceService.requestPermission() }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: engine.icon)
                                .font(.system(size: 13, weight: .semibold))
                            Text(engine.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(selectedEngine == engine ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            Group {
                                if selectedEngine == engine {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.55, green: 0.35, blue: 0.95),
                                                    Color(red: 0.35, green: 0.55, blue: 0.95),
                                                ],
                                                startPoint: .leading, endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: .purple.opacity(0.3), radius: 4, x: 0, y: 2)
                                } else {
                                    Color.clear
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            )

            // Description line
            HStack(spacing: 4) {
                Image(systemName: selectedEngine == .onDevice ? "lock.fill" : "arrow.up.arrow.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(selectedEngine == .onDevice ? .green : .blue)
                Text(selectedEngine.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Subviews

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Phrase \(currentIndex + 1) of \(practiceSet.prompts.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.secondary.opacity(0.15))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.35, blue: 0.95),
                                    Color(red: 0.35, green: 0.55, blue: 0.95),
                                ],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geo.size.width * CGFloat(currentIndex + 1)
                                / CGFloat(max(practiceSet.prompts.count, 1))
                        )
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.8), value: currentIndex)
                }
            }
            .frame(height: 6)
        }
    }

    private func promptCard(_ prompt: PracticePrompt) -> some View {
        VStack(spacing: 16) {
            // Telugu text
            Text(prompt.teluguText)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)

            if !prompt.transliteration.isEmpty {
                Text(prompt.transliteration)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.indigo)
            }

            if !prompt.meaning.isEmpty {
                Text(prompt.meaning)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }

    private var waveformSection: some View {
        VStack(spacing: 12) {
            if activeIsRecording {
                LiveWaveformView(level: activeAudioLevel)
                    .frame(height: 60)
                    .transition(.opacity)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .opacity(pulseRecordButton ? 1.0 : 0.3)
                    Text(formatRecordingTime(recordingSeconds))
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary)
                }
            } else if activeIsProcessing {
                ProcessingIndicator()
                    .frame(height: 60)
            } else {
                IdleWaveformView()
                    .frame(height: 60)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: activeIsRecording)
        .animation(.easeInOut(duration: 0.3), value: activeIsProcessing)
    }

    private var recordButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: handleRecordTap) {
                ZStack {
                    Circle()
                        .stroke(
                            activeIsRecording
                                ? Color.red.opacity(0.3)
                                : Color.purple.opacity(0.2),
                            lineWidth: 4
                        )
                        .frame(width: 96, height: 96)
                        .scaleEffect(pulseRecordButton ? 1.25 : 1.0)
                        .opacity(pulseRecordButton ? 0.0 : 1.0)
                        .animation(
                            .easeOut(duration: 0.8).repeatForever(autoreverses: false),
                            value: pulseRecordButton)

                    Circle()
                        .fill(
                            activeIsRecording
                                ? LinearGradient(
                                    colors: [.red, Color(red: 0.8, green: 0.1, blue: 0.2)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(
                                    colors: [
                                        Color(red: 0.55, green: 0.35, blue: 0.95),
                                        Color(red: 0.35, green: 0.55, blue: 0.95),
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 80, height: 80)
                        .shadow(
                            color: activeIsRecording
                                ? .red.opacity(0.5)
                                : Color(red: 0.45, green: 0.25, blue: 0.85).opacity(0.5),
                            radius: 20, x: 0, y: 8)

                    Image(systemName: activeIsRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .disabled(activeIsProcessing)
            .scaleEffect(activeIsProcessing ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: activeIsProcessing)

            Text(buttonLabel)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }

    private var buttonLabel: String {
        if activeIsProcessing { return "Analysing…" }
        if activeIsRecording { return "Tap to stop" }
        return "Tap to record"
    }

    private var navigationButtons: some View {
        HStack(spacing: 14) {
            // Retry
            Button {
                withAnimation(.spring()) {
                    showResult = false
                    sttService.lastResult = nil
                    sttService.errorMessage = nil
                }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                    )
            }

            // Next
            if !practiceSet.prompts.isEmpty {
                Button {
                    advanceToNext()
                } label: {
                    Label(
                        currentIndex + 1 < practiceSet.prompts.count ? "Next" : "Finish",
                        systemImage: currentIndex + 1 < practiceSet.prompts.count
                            ? "arrow.right" : "checkmark"
                    )
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.55, green: 0.35, blue: 0.95),
                                        Color(red: 0.35, green: 0.55, blue: 0.95),
                                    ],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .shadow(
                                color: Color(red: 0.45, green: 0.25, blue: 0.85).opacity(0.4),
                                radius: 12, x: 0, y: 6)
                    )
                }
            }
        }
    }

    // MARK: - Actions

    private func handleRecordTap() {
        HapticsManager.shared.impact(.medium)

        if selectedEngine == .sarvam {
            handleSarvamRecordTap()
        } else {
            handleOnDeviceRecordTap()
        }
    }

    private func handleSarvamRecordTap() {
        if sttService.isRecording {
            sttService.stopRecording()
            Task {
                let expected = currentPrompt?.teluguText ?? ""
                await sttService.transcribe(expectedText: expected)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showResult = true
                }
                playResultSound(result: sttService.lastResult)
            }
        } else {
            guard sttService.permissionGranted else {
                showPermissionAlert = true
                return
            }
            resetResult()
            do {
                try sttService.startRecording()
            } catch let error as STTError {
                sttService.errorMessage = error.errorDescription
            } catch {
                sttService.errorMessage = error.localizedDescription
            }
        }
    }

    private func handleOnDeviceRecordTap() {
        if onDeviceService.isRecording {
            onDeviceService.stopRecording()
            Task {
                let expected = currentPrompt?.teluguText ?? ""
                await onDeviceService.transcribe(expectedText: expected)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showResult = true
                }
                playResultSound(result: onDeviceService.lastResult)
            }
        } else {
            guard onDeviceService.permissionGranted else {
                Task { await onDeviceService.requestPermission() }
                return
            }
            resetResult()
            do {
                try onDeviceService.startRecording()
            } catch let error as STTError {
                onDeviceService.errorMessage = error.errorDescription
            } catch {
                onDeviceService.errorMessage = error.localizedDescription
            }
        }
    }

    private func resetResult() {
        withAnimation {
            showResult = false
            sttService.lastResult = nil
            sttService.errorMessage = nil
            onDeviceService.lastResult = nil
            onDeviceService.errorMessage = nil
        }
    }

    private func playResultSound(result: PronunciationResult?) {
        if let result {
            if result.score >= 0.65 {
                let pitchRate = Float(1.0 + (result.score - 0.65) * 0.3)
                session.audioService.play(name: "success.mp3", rate: pitchRate)
                HapticsManager.shared.notification(.success)
            } else {
                session.audioService.play(name: "tryagain.mp3", rate: 1.0)
                HapticsManager.shared.notification(.error)
            }
            let xp = Int(result.score * 20)
            if xp > 0 { session.updateProgress(xp: xp) }
        } else {
            HapticsManager.shared.notification(.error)
        }
    }

    private func advanceToNext() {
        HapticsManager.shared.impact(.light)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if currentIndex + 1 < practiceSet.prompts.count {
                currentIndex += 1
                showResult = false
                sttService.lastResult = nil
                sttService.errorMessage = nil
                onDeviceService.lastResult = nil
                onDeviceService.errorMessage = nil
            } else {
                dismiss()
            }
        }
    }

    private func startRecordingTimer() {
        recordingSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingSeconds += 1
            // Auto-stop at 28s (API max is 30s)
            if recordingSeconds >= 28 {
                Task { @MainActor in
                    self.sttService.stopRecording()
                    await sttService.transcribe(expectedText: self.currentPrompt?.teluguText ?? "")
                    withAnimation(.spring()) { self.showResult = true }
                }
            }
        }
    }

    private func stopRecordingTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formatRecordingTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

// MARK: - Result Card

struct ResultCard: View {
    let result: PronunciationResult
    @State private var animateScore = false

    private var scoreColor: Color {
        switch result.score {
        case 0.85...1.0: return Color(red: 0.2, green: 0.85, blue: 0.5)
        case 0.65..<0.85: return Color(red: 0.35, green: 0.7, blue: 1.0)
        case 0.40..<0.65: return Color(red: 1.0, green: 0.75, blue: 0.2)
        default: return Color(red: 1.0, green: 0.4, blue: 0.4)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(scoreColor)
                    .font(.system(size: 20))
                Text("Result")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                // Score ring
                ScoreRing(score: animateScore ? result.score : 0, color: scoreColor)
                    .frame(width: 56, height: 56)
            }

            Divider()

            // Feedback message
            Text(result.feedback)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(scoreColor)
                .multilineTextAlignment(.center)

            // Transcript
            if !result.transcript.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label("You said", systemImage: "quote.bubble")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text(result.transcript)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 12).fill(.secondary.opacity(0.08)))
            }

            // Word breakdown
            if !result.expectedText.isEmpty {
                wordBreakdown
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: scoreColor.opacity(0.12), radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(scoreColor.opacity(0.25), lineWidth: 1)
                )
        )
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) {
                animateScore = true
            }
        }
    }

    private var wordBreakdown: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Word Check")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            if !result.matchedWords.isEmpty {
                WordChipsRow(
                    label: "✓ Correct", words: result.matchedWords,
                    color: Color(red: 0.2, green: 0.85, blue: 0.5))
            }
            if !result.missedWords.isEmpty {
                WordChipsRow(
                    label: "✗ Missed", words: result.missedWords,
                    color: Color(red: 1.0, green: 0.4, blue: 0.4))
            }
        }
    }
}

// MARK: - Score Ring

private struct ScoreRing: View {
    let score: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(.secondary.opacity(0.15), lineWidth: 5)
            Circle()
                .trim(from: 0, to: score)
                .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: score)
            Text("\(Int(score * 100))%")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Word Chips Row

private struct WordChipsRow: View {
    let label: String
    let words: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(color)
            FlowLayout(spacing: 6) {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(color.opacity(0.12))
                                .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 1))
                        )
                }
            }
        }
    }
}

// MARK: - Live Waveform

struct LiveWaveformView: View {
    let level: Float
    @State private var bars: [CGFloat] = Array(repeating: 0.05, count: 30)
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 3) {
            ForEach(bars.indices, id: \.self) { i in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.55, green: 0.35, blue: 0.95),
                                Color(red: 0.35, green: 0.75, blue: 0.95),
                            ],
                            startPoint: .bottom, endPoint: .top
                        )
                    )
                    .frame(width: 4, height: max(4, bars[i] * 60))
                    .animation(.easeInOut(duration: 0.08), value: bars[i])
            }
        }
        .onReceive(timer) { _ in
            let base = CGFloat(level)
            for i in bars.indices {
                let noise = CGFloat.random(in: -0.15...0.15)
                bars[i] = max(0.05, min(1.0, base + noise + CGFloat.random(in: 0...0.2)))
            }
        }
    }
}

// MARK: - Idle Waveform

private struct IdleWaveformView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<30, id: \.self) { i in
                Capsule()
                    .fill(Color.indigo.opacity(0.15))
                    .frame(width: 4, height: animate ? CGFloat.random(in: 4...20) : 4)
                    .animation(
                        .easeInOut(duration: Double.random(in: 1.0...2.0))
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.05),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Processing Indicator

private struct ProcessingIndicator: View {
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 3)
                    .frame(width: 40, height: 40)
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [Color(red: 0.55, green: 0.35, blue: 0.95), .clear],
                            startPoint: .leading, endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
            }
            Text("Processing speech…")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Error Banner

private struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.orange.opacity(0.10))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.orange.opacity(0.30), lineWidth: 1)
                )
        )
    }
}

// MARK: - Flow Layout (for word chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Data Models

struct PracticePrompt: Identifiable {
    let id = UUID()
    let teluguText: String
    let transliteration: String
    let meaning: String
}

struct PracticeSet: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let difficulty: Int  // 1‑3
    let gradient: LinearGradient
    let prompts: [PracticePrompt]

    static let freestyle = PracticeSet(
        title: "Free Practice",
        icon: "mic.fill",
        difficulty: 1,
        gradient: LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.45, blue: 0.35),
                Color(red: 0.85, green: 0.25, blue: 0.55),
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing
        ),
        prompts: []
    )

    static let allSets: [PracticeSet] = [
        PracticeSet(
            title: "Greetings",
            icon: "hand.wave.fill",
            difficulty: 1,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.3, green: 0.7, blue: 0.95),
                    Color(red: 0.15, green: 0.5, blue: 0.85),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(
                    teluguText: "నమస్కారం", transliteration: "Namaskāram", meaning: "Hello / Greetings"),
                PracticePrompt(
                    teluguText: "శుభోదయం", transliteration: "Śubhodayam", meaning: "Good morning"),
                PracticePrompt(
                    teluguText: "శుభ రాత్రి", transliteration: "Śubha rātri", meaning: "Good night"),
                PracticePrompt(
                    teluguText: "ధన్యవాదాలు", transliteration: "Dhanyavādālu", meaning: "Thank you"),
                PracticePrompt(teluguText: "సరే", transliteration: "Sarē", meaning: "OK / Alright"),
            ]
        ),
        PracticeSet(
            title: "Numbers",
            icon: "number.circle.fill",
            difficulty: 1,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.65, blue: 0.2),
                    Color(red: 0.85, green: 0.45, blue: 0.1),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(teluguText: "ఒకటి", transliteration: "Okati", meaning: "One"),
                PracticePrompt(teluguText: "రెండు", transliteration: "Rendu", meaning: "Two"),
                PracticePrompt(teluguText: "మూడు", transliteration: "Mūdu", meaning: "Three"),
                PracticePrompt(teluguText: "నాలుగు", transliteration: "Nālugu", meaning: "Four"),
                PracticePrompt(teluguText: "అయిదు", transliteration: "Ayidu", meaning: "Five"),
            ]
        ),
        PracticeSet(
            title: "Vowels",
            icon: "a.circle.fill",
            difficulty: 1,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.85, blue: 0.55),
                    Color(red: 0.1, green: 0.65, blue: 0.45),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(teluguText: "అ", transliteration: "A", meaning: "First vowel"),
                PracticePrompt(teluguText: "ఆ", transliteration: "Ā", meaning: "Long A"),
                PracticePrompt(teluguText: "ఇ", transliteration: "I", meaning: "Short I"),
                PracticePrompt(teluguText: "ఈ", transliteration: "Ī", meaning: "Long I"),
                PracticePrompt(teluguText: "ఉ", transliteration: "U", meaning: "Short U"),
                PracticePrompt(teluguText: "ఊ", transliteration: "Ū", meaning: "Long U"),
            ]
        ),
        PracticeSet(
            title: "Daily Phrases",
            icon: "bubble.left.and.bubble.right.fill",
            difficulty: 2,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.35, blue: 0.95),
                    Color(red: 0.35, green: 0.15, blue: 0.75),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(
                    teluguText: "నీ పేరు ఏమిటి?", transliteration: "Nī pēru ēmiti?",
                    meaning: "What is your name?"),
                PracticePrompt(
                    teluguText: "నా పేరు …", transliteration: "Nā pēru …", meaning: "My name is …"),
                PracticePrompt(
                    teluguText: "మీరు ఎక్కడ ఉన్నారు?", transliteration: "Mīru ekkada unnāru?",
                    meaning: "Where are you?"),
                PracticePrompt(
                    teluguText: "ఇది ఏమిటి?", transliteration: "Idi ēmiti?", meaning: "What is this?"),
                PracticePrompt(
                    teluguText: "నాకు అర్థం కాలేదు", transliteration: "Nāku artham kālēdu",
                    meaning: "I don't understand"),
            ]
        ),
        PracticeSet(
            title: "Animals",
            icon: "hare.fill",
            difficulty: 2,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.35, blue: 0.65),
                    Color(red: 0.65, green: 0.15, blue: 0.45),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(teluguText: "పిల్లి", transliteration: "Pilli", meaning: "Cat"),
                PracticePrompt(teluguText: "కుక్క", transliteration: "Kukka", meaning: "Dog"),
                PracticePrompt(teluguText: "ఆవు", transliteration: "Āvu", meaning: "Cow"),
                PracticePrompt(teluguText: "గుర్రం", transliteration: "Gurram", meaning: "Horse"),
                PracticePrompt(teluguText: "ఏనుగు", transliteration: "Ēnugu", meaning: "Elephant"),
            ]
        ),
        PracticeSet(
            title: "Sentences",
            icon: "text.bubble.fill",
            difficulty: 3,
            gradient: LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.35, blue: 0.35),
                    Color(red: 0.75, green: 0.15, blue: 0.15),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ),
            prompts: [
                PracticePrompt(
                    teluguText: "నేను తెలుగు నేర్చుకుంటున్నాను", transliteration: "Nēnu Telugu nērcukuntunnānu",
                    meaning: "I am learning Telugu"),
                PracticePrompt(
                    teluguText: "తెలుగు చాలా అందమైన భాష", transliteration: "Telugu cālā andamaina bhāsha",
                    meaning: "Telugu is a very beautiful language"),
                PracticePrompt(
                    teluguText: "నాకు తెలుగు అంటే చాలా ఇష్టం", transliteration: "Nāku Telugu ante cālā ishṭam",
                    meaning: "I love Telugu very much"),
            ]
        ),
    ]
}
