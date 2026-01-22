import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.primary
                .ignoresSafeArea()
            
            VStack(spacing: ModernDesignSystem.Spacing.lg) {
                // App icon or logo would go here
                Image(systemName: "book.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("ManaTelugu")
                    .font(ModernDesignSystem.Typography.title1)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("Learn Telugu Alphabet")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(.white.opacity(0.8))
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .padding(.top, ModernDesignSystem.Spacing.lg)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
