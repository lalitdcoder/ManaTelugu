import SwiftUI

struct LetterCardView: View {
    let letter: Letter
    @EnvironmentObject var session: AppSession

    var isLearned: Bool {
        session.learnedLettersSet.contains(letter.id)
    }

    var body: some View {
        ManaCard(style: .elevated, padding: 8) {
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    if isLearned {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(ManaTheme.Colors.emeraldGreen)
                    }
                }
                .frame(height: 12)

                Text(letter.character)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(ManaTheme.Colors.primary)

                Text(letter.romanization)
                    .font(ManaTheme.Typography.caption2.weight(.medium))
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
