import SwiftUI

struct CardView: View {
    let telugu: String
    let transliteration: String
    let english: String
    let onTap: () -> Void
    
    @State private var showTranslation = false
    
    var body: some View {
        VStack(spacing: MTSpacing.small) {
            Text(telugu)
                .font(.title)
                .foregroundColor(MTColors.text)
            
            Text(transliteration)
                .font(MTTypography.body())
                .foregroundColor(MTColors.text.opacity(0.8))
            
            if showTranslation {
                Text(english)
                    .font(MTTypography.body())
                    .foregroundColor(MTColors.text)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(MTColors.surfaceAlt)
        .cornerRadius(12)
        .onTapGesture {
            showTranslation.toggle()
            onTap()
        }
    }
}