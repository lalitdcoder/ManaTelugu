import SwiftUI

struct AlphabetHubView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: MTSpacing.large) {
                Text("Alphabet")
                    .font(MTTypography.title(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text)
                    .padding(.horizontal)
                
                Text("Learn Telugu vowels and consonants")
                    .font(MTTypography.body(kidMode: session.userProfile.kidMode))
                    .foregroundColor(MTColors.text.opacity(0.7))
                    .padding(.horizontal)
                
                VStack(spacing: MTSpacing.medium) {
                    NavigationLink {
                        VowelsView()
                    } label: {
                        hubCard(title: "Vowels (అచ్చులు)", subtitle: "అ ఆ ఇ ఈ ఉ ఊ ఋ ఎ ఏ ఐ ఒ ఓ ఔ", icon: "character")
                    }
                    
                    NavigationLink {
                        ConsonantsView()
                    } label: {
                        hubCard(title: "Consonants (హల్లులు)", subtitle: "క నుండి క్ష వరకు", icon: "textformat.abc.dottedunderline")
                    }

                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    private func hubCard(title: String, subtitle: String, icon: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(MTColors.surfaceAlt)
                .frame(height: 110)
            HStack(spacing: MTSpacing.medium) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(MTColors.primary)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(MTTypography.heading(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text)
                    Text(subtitle)
                        .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                        .foregroundColor(MTColors.text.opacity(0.7))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(MTColors.text.opacity(0.5))
            }
            .padding(.horizontal)
        }
    }
}


