import SwiftUI

// MARK: - Premium Word of the Day Card (iOS 17+)
struct WordOfTheDayCard: View {
    let word: Word
    let onPlayAudio: () -> Void

    @State private var isAudioPlaying = false

    private let saffronGold = Color(red: 0.98, green: 0.67, blue: 0.12)
    private let midnightIndigo = Color(red: 0.18, green: 0.13, blue: 0.42)
    private let peacockBlue = Color(red: 0.09, green: 0.55, blue: 0.71)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Gradient background
            LinearGradient(
                colors: [peacockBlue, Color(red: 0.05, green: 0.38, blue: 0.58)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Decorative watermark glyph
            Text(word.telugu.prefix(1).description)
                .font(.system(size: 110, weight: .bold))
                .foregroundStyle(.white.opacity(0.07))
                .offset(x: 18, y: 22)
                .allowsHitTesting(false)

            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Label row
                HStack {
                    Label("Word of the Day", systemImage: "sun.max.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.70))
                        .tracking(0.5)

                    Spacer()

                    // Play button
                    Button {
                        HapticsService.shared.buttonTap()
                        isAudioPlaying = true
                        onPlayAudio()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isAudioPlaying = false
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(saffronGold)
                                .frame(width: 40, height: 40)
                                .shadow(color: saffronGold.opacity(0.45), radius: 8, x: 0, y: 4)

                            Image(systemName: isAudioPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(midnightIndigo)
                                .symbolEffect(.variableColor.iterative, isActive: isAudioPlaying)
                        }
                    }
                }

                Spacer().frame(height: 14)

                // Telugu word (large)
                Text(word.telugu)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                Spacer().frame(height: 6)

                // Transliteration (phonetics)
                Text(word.transliteration)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.75))

                Spacer().frame(height: 10)

                // Divider
                Rectangle()
                    .fill(.white.opacity(0.18))
                    .frame(height: 1)

                Spacer().frame(height: 10)

                // English translation
                HStack {
                    Text(word.english)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    // Category pill if available
                    Text("Today's Pick")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(saffronGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(saffronGold.opacity(0.18))
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(saffronGold.opacity(0.35), lineWidth: 1))
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 180)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: peacockBlue.opacity(0.35), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Edge Border (kept for compatibility)
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}
