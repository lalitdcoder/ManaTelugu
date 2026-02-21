import AVFoundation
import SwiftUI

/// Gudinthalu (Consonant-Vowel Combinations) Learning View
/// Displays Telugu gunintams dynamically generated using Unicode composition
struct GudinthaluView: View {
    @StateObject private var manager = GudinthaluManager()
    @Environment(\.dismiss) private var dismiss
    @State private var animateHeader = false
    @State private var selectedConsonant: String?

    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.56, green: 0.35, blue: 0.85).opacity(0.25),
                    Color(red: 0.29, green: 0.56, blue: 0.89).opacity(0.2),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    // Hero Header
                    heroHeaderSection
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)

                    // Gudinthalu Sections
                    ForEach(manager.consonants, id: \.self) { consonant in
                        gudinthaluSection(for: consonant)
                    }

                    // Bottom padding
                    Color.clear.frame(height: 100)
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Gudinthalu")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.56, green: 0.35, blue: 0.85).opacity(0.1),
                    Color(red: 0.29, green: 0.56, blue: 0.89).opacity(0.08),
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline.bold())
                        Text("Back")
                            .font(.body)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateHeader = true
            }
        }
    }

    // MARK: - Hero Header
    private var heroHeaderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Telugu title with icon
            HStack(spacing: 12) {
                Image(systemName: "character.textbox")
                    .font(.title2.bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("గుణింతాలు")
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    Text("Consonant-Vowel Combinations")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .scaleEffect(animateHeader ? 1.0 : 0.9)
            .opacity(animateHeader ? 1.0 : 0.0)

            // Info card
            HStack(spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Learn how consonants combine with vowel signs")
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    Text(
                        "\(manager.consonants.count) consonants × \(manager.vowelSigns.count) vowel signs"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .scaleEffect(animateHeader ? 1.0 : 0.95)
            .opacity(animateHeader ? 1.0 : 0.0)
            .animation(
                .spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: animateHeader)
        }
    }

    // MARK: - Gudinthalu Section
    private func gudinthaluSection(for consonant: String) -> some View {
        Section {
            // Horizontal scrolling grid of gudinthalu
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(manager.generateGudinthaluForConsonant(consonant)) { item in
                        gudinthamCard(item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        } header: {
            sectionHeader(for: consonant)
        }
    }

    // MARK: - Section Header
    private func sectionHeader(for consonant: String) -> some View {
        HStack(spacing: 12) {
            // Large consonant display
            Text(consonant)
                .font(.system(size: 32, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.2),
                                    Color.blue.opacity(0.15),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("\(consonant) Gudintham")
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                Text("\(manager.vowelSigns.count) combinations")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Swipe indicator
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Image(systemName: "chevron.right")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .opacity(0.6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }

    // MARK: - Gudintham Card
    private func gudinthamCard(_ item: GudinthamItem) -> some View {
        VStack(spacing: 12) {
            // Combined character (the gudintham itself)
            Text(item.combined)
                .font(.custom("Telugu Sangam MN", size: 48))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(width: 100, height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.white.opacity(0.6),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.15), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.3),
                                    Color.blue.opacity(0.2),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )

            // Romanization label
            VStack(spacing: 4) {
                // Vowel sign display
                Text(item.vowelSign.display)
                    .font(.caption.bold())
                    .foregroundColor(.primary)

                // Full Romanization (e.g., "ka", "kha", "ki")
                Text(
                    manager.getFullRomanization(
                        consonant: item.consonant, vowelSign: item.vowelSign)
                )
                .font(.caption2)
                .foregroundColor(.secondary)
                .italic()
            }
            .frame(width: 100)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .frame(width: 110)
        .onTapGesture {
            playMelodiousAudio(for: item.combined)
            HapticsManager.shared.selection()
        }
    }

    private func playMelodiousAudio(for text: String) {
        // Stop any previous speech
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        // Use Telugu voice
        utterance.voice = AVSpeechSynthesisVoice(language: "te-IN")
        // Slightly slower rate for clarity
        utterance.rate = 0.4
        // Lower pitch for a deeper, more traditional sound (optional)
        utterance.pitchMultiplier = 1.0

        speechSynthesizer.speak(utterance)
    }

    private let speechSynthesizer = AVSpeechSynthesizer()

    // MARK: - Preview
}

#Preview {
    NavigationStack {
        GudinthaluView()
    }
}
