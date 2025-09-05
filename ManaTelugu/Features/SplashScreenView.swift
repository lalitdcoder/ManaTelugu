import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            MTColors.primary
                .ignoresSafeArea()
            
            VStack(spacing: MTSpacing.large) {
                // App icon or logo would go here
                Image(systemName: "book.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("ManaTelugu")
                    .font(MTTypography.title())
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("Learn Telugu Alphabet")
                    .font(MTTypography.body())
                    .foregroundColor(.white.opacity(0.8))
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .padding(.top, MTSpacing.large)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
