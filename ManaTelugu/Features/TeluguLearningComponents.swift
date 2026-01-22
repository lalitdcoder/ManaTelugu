import AVFoundation
import SwiftUI

// MARK: - Telugu Letter Card
struct TeluguLetterCard: View {
    let letter: String
    let transliteration: String
    let category: LetterCategory
    let isSelected: Bool
    let action: () -> Void

    enum LetterCategory {
        case vowel, consonant, compound

        var color: Color {
            switch self {
            case .vowel: return AppleHIGDesign.Colors.vowelColor
            case .consonant: return AppleHIGDesign.Colors.consonantColor
            case .compound: return AppleHIGDesign.Colors.numberColor
            }
        }

        var icon: String {
            switch self {
            case .vowel: return "a.circle.fill"
            case .consonant: return "textformat"
            case .compound: return "number.circle.fill"
            }
        }
    }

    var body: some View {
        Button(action: {
            HapticsManager.shared.impact(.light)
            action()
        }) {
            AppleHIGCard(style: .elevated) {
                VStack(spacing: AppleHIGDesign.Spacing.sm) {
                    // Category indicator
                    HStack {
                        Image(systemName: category.icon)
                            .font(.caption)
                            .foregroundColor(category.color)
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(AppleHIGDesign.Colors.systemGreen)
                        }
                    }

                    // Telugu letter
                    Text(letter)
                        .font(AppleHIGDesign.Typography.teluguLarge)
                        .foregroundColor(AppleHIGDesign.Colors.label)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    // Transliteration
                    Text(transliteration)
                        .font(AppleHIGDesign.Typography.caption1)
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                        .lineLimit(1)
                }
                .padding(AppleHIGDesign.Spacing.xs)
            }
        }
        .recommendedTouchTarget()
        .appleHIGAccessibility(
            label: "Telugu letter \(letter), pronounced \(transliteration)",
            hint: "Double tap to learn this letter",
            traits: [.isButton]
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(AppleHIGDesign.Animation.smooth, value: isSelected)
    }
}

// MARK: - Audio Button with Visual Feedback
struct TeluguAudioButton: View {
    let audioFile: String
    let size: AudioButtonSize
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?

    enum AudioButtonSize {
        case small, medium, large

        var iconSize: Font {
            switch self {
            case .small: return .caption
            case .medium: return .title3
            case .large: return .title
            }
        }

        var buttonSize: CGFloat {
            switch self {
            case .small: return AppleHIGDesign.Spacing.minimumTouchTarget
            case .medium: return AppleHIGDesign.Spacing.recommendedTouchTarget
            case .large: return AppleHIGDesign.Spacing.largeTouchTarget
            }
        }
    }

    var body: some View {
        Button(action: playAudio) {
            ZStack {
                Circle()
                    .fill(AppleHIGDesign.Colors.primary)
                    .frame(width: size.buttonSize, height: size.buttonSize)

                if isPlaying {
                    // Animated sound waves
                    HStack(spacing: 2) {
                        ForEach(0..<3) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white)
                                .frame(width: 2, height: 8)
                                .scaleEffect(y: isPlaying ? 1.5 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.5)
                                        .repeatForever()
                                        .delay(Double(index) * 0.1),
                                    value: isPlaying
                                )
                        }
                    }
                } else {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(size.iconSize)
                        .foregroundColor(.white)
                }
            }
        }
        .appleHIGAccessibility(
            label: "Play audio pronunciation",
            hint: "Double tap to hear how this is pronounced",
            traits: [.isButton, .playsSound]
        )
        .scaleEffect(isPlaying ? 1.1 : 1.0)
        .animation(AppleHIGDesign.Animation.bouncy, value: isPlaying)
    }

    private func playAudio() {
        AppleHIGDesign.Haptics.light()

        guard let url = Bundle.main.url(forResource: audioFile, withExtension: "m4a") else {
            print("Audio file not found: \(audioFile)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = AudioPlayerDelegate { [self] in
                withAnimation {
                    isPlaying = false
                }
            }

            withAnimation {
                isPlaying = true
            }

            audioPlayer?.play()

            // Auto-stop animation after 2 seconds if still playing
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if isPlaying {
                    withAnimation {
                        isPlaying = false
                    }
                }
            }
        } catch {
            print("Error playing audio: \(error)")
        }
    }
}

// MARK: - Audio Player Delegate
class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinish()
    }
}

// MARK: - Progress Ring
struct TeluguProgressRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color

    init(
        progress: Double, size: CGFloat = 60, lineWidth: CGFloat = 6,
        color: Color = AppleHIGDesign.Colors.primary
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(AppleHIGDesign.Colors.quaternarySystemFill, lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(AppleHIGDesign.Animation.smooth, value: progress)

            // Progress text
            Text("\(Int(progress * 100))%")
                .font(AppleHIGDesign.Typography.caption1.weight(.semibold))
                .foregroundColor(AppleHIGDesign.Colors.label)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Learning Streak Badge
struct TeluguStreakBadge: View {
    let streakCount: Int
    let size: BadgeSize

    enum BadgeSize {
        case small, medium, large

        var iconSize: Font {
            switch self {
            case .small: return .caption
            case .medium: return .body
            case .large: return .title3
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
    }

    var body: some View {
        HStack(spacing: AppleHIGDesign.Spacing.xxs) {
            Image(systemName: "flame.fill")
                .font(size.iconSize)
                .foregroundColor(.orange)

            Text("\(streakCount)")
                .font(size.iconSize.weight(.bold))
                .foregroundColor(AppleHIGDesign.Colors.label)
        }
        .padding(size.padding)
        .background(AppleHIGDesign.Colors.secondarySystemBackground)
        .cornerRadius(AppleHIGDesign.CornerRadius.sm)
        .appleHIGAccessibility(
            label: "\(streakCount) day learning streak",
            traits: [.isStaticText]
        )
    }
}

// MARK: - Difficulty Level Indicator
struct TeluguDifficultyIndicator: View {
    let level: DifficultyLevel
    let size: IndicatorSize

    enum DifficultyLevel: Int, CaseIterable {
        case beginner = 1
        case intermediate = 2
        case advanced = 3

        var title: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            }
        }

        var color: Color {
            switch self {
            case .beginner: return AppleHIGDesign.Colors.systemGreen
            case .intermediate: return AppleHIGDesign.Colors.systemOrange
            case .advanced: return AppleHIGDesign.Colors.systemRed
            }
        }
    }

    enum IndicatorSize {
        case small, medium

        var dotSize: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            }
        }

        var spacing: CGFloat {
            switch self {
            case .small: return 2
            case .medium: return 3
            }
        }
    }

    var body: some View {
        HStack(spacing: size.spacing) {
            ForEach(1...3, id: \.self) { index in
                Circle()
                    .fill(
                        index <= level.rawValue
                            ? level.color : AppleHIGDesign.Colors.quaternarySystemFill
                    )
                    .frame(width: size.dotSize, height: size.dotSize)
            }
        }
        .appleHIGAccessibility(
            label: "\(level.title) difficulty level",
            traits: [.isStaticText]
        )
    }
}

// MARK: - Achievement Badge
struct TeluguAchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool

    struct Achievement {
        let id: String
        let title: String
        let description: String
        let icon: String
        let color: Color
    }

    var body: some View {
        AppleHIGCard(style: .elevated) {
            VStack(spacing: AppleHIGDesign.Spacing.sm) {
                // Achievement icon
                ZStack {
                    Circle()
                        .fill(
                            isUnlocked
                                ? achievement.color : AppleHIGDesign.Colors.quaternarySystemFill
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: achievement.icon)
                        .font(.title2)
                        .foregroundColor(isUnlocked ? .white : AppleHIGDesign.Colors.tertiaryLabel)
                }

                // Achievement title
                Text(achievement.title)
                    .font(AppleHIGDesign.Typography.headline)
                    .foregroundColor(
                        isUnlocked
                            ? AppleHIGDesign.Colors.label : AppleHIGDesign.Colors.tertiaryLabel
                    )
                    .multilineTextAlignment(.center)

                // Achievement description
                Text(achievement.description)
                    .font(AppleHIGDesign.Typography.caption1)
                    .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(AppleHIGDesign.Spacing.sm)
        }
        .opacity(isUnlocked ? 1.0 : 0.6)
        .appleHIGAccessibility(
            label: "\(achievement.title) achievement",
            hint: isUnlocked ? "Unlocked" : "Not yet unlocked",
            traits: [.isStaticText]
        )
    }
}

// MARK: - Word Building Component
struct TeluguWordBuilder: View {
    @Binding var selectedLetters: [String]
    let availableLetters: [String]
    let targetWord: String
    let onLetterTap: (String) -> Void
    let onLetterRemove: (Int) -> Void

    var body: some View {
        VStack(spacing: AppleHIGDesign.Spacing.lg) {
            // Target word display
            AppleHIGCard(style: .filled) {
                VStack(spacing: AppleHIGDesign.Spacing.sm) {
                    Text("Build this word:")
                        .font(AppleHIGDesign.Typography.headline)
                        .foregroundColor(AppleHIGDesign.Colors.secondaryLabel)

                    Text(targetWord)
                        .font(AppleHIGDesign.Typography.teluguLarge)
                        .foregroundColor(AppleHIGDesign.Colors.label)
                }
            }

            // Selected letters display
            AppleHIGCard(style: .outlined) {
                HStack(spacing: AppleHIGDesign.Spacing.xs) {
                    if selectedLetters.isEmpty {
                        Text("Tap letters below to build the word")
                            .font(AppleHIGDesign.Typography.body)
                            .foregroundColor(AppleHIGDesign.Colors.tertiaryLabel)
                            .italic()
                    } else {
                        ForEach(Array(selectedLetters.enumerated()), id: \.offset) {
                            index, letter in
                            Button(action: {
                                AppleHIGDesign.Haptics.light()
                                onLetterRemove(index)
                            }) {
                                Text(letter)
                                    .font(AppleHIGDesign.Typography.teluguMedium)
                                    .foregroundColor(AppleHIGDesign.Colors.label)
                                    .padding(AppleHIGDesign.Spacing.xs)
                                    .background(AppleHIGDesign.Colors.tertiarySystemBackground)
                                    .cornerRadius(AppleHIGDesign.CornerRadius.sm)
                            }
                            .appleHIGAccessibility(
                                label: "Selected letter \(letter)",
                                hint: "Double tap to remove",
                                traits: [.isButton]
                            )
                        }
                    }
                }
                .frame(minHeight: 60)
            }

            // Available letters
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 4),
                spacing: AppleHIGDesign.Spacing.sm
            ) {
                ForEach(availableLetters, id: \.self) { letter in
                    Button(action: {
                        AppleHIGDesign.Haptics.light()
                        onLetterTap(letter)
                    }) {
                        Text(letter)
                            .font(AppleHIGDesign.Typography.teluguMedium)
                            .foregroundColor(AppleHIGDesign.Colors.label)
                            .frame(width: 60, height: 60)
                            .background(AppleHIGDesign.Colors.secondarySystemBackground)
                            .cornerRadius(AppleHIGDesign.CornerRadius.md)
                    }
                    .appleHIGAccessibility(
                        label: "Letter \(letter)",
                        hint: "Double tap to add to word",
                        traits: [.isButton]
                    )
                }
            }
        }
    }
}
