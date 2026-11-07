import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Premium indigo gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.18, green: 0.13, blue: 0.42),
                    Color(red: 0.22, green: 0.17, blue: 0.52),
                    Color(red: 0.32, green: 0.18, blue: 0.62)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Hero Section
                    heroSection
                    
                    // Data we store
                    dataStoredSection
                    
                    // What we DON'T do
                    doNotDoSection
                    
                    // Children's Privacy
                    childrensPrivacySection
                    
                    // Contact
                    contactSection
                    
                    // Last updated
                    Text("Last updated: July 2026")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.45))
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color(red: 0.18, green: 0.13, blue: 0.42),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.98, green: 0.67, blue: 0.12), Color(red: 1.0, green: 0.88, blue: 0.50)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: Color(red: 0.98, green: 0.67, blue: 0.12).opacity(0.4), radius: 20, x: 0, y: 8)
                
                Image(systemName: "shield.checkmark.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 8) {
                Text("Your Privacy is Protected")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("ManaTelugu is 100% offline — your data never leaves your device")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
    }
    
    // MARK: - Data Stored Section
    private var dataStoredSection: some View {
        privacyCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Data Stored On Your Device", systemImage: "iphone")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    dataItem(icon: "chart.bar.fill", color: .blue, text: "Learning progress & lesson completion")
                    dataItem(icon: "gear", color: Color(red: 0.6, green: 0.6, blue: 0.8), text: "App preferences & settings")
                    dataItem(icon: "flame.fill", color: .orange, text: "Streak and XP data")
                    dataItem(icon: "heart.fill", color: .pink, text: "Favourite words")
                }
                
                Divider().overlay(.white.opacity(0.2))
                
                HStack(spacing: 12) {
                    Image(systemName: "lock.shield.fill")
                        .font(.title3)
                        .foregroundStyle(Color(red: 0.98, green: 0.67, blue: 0.12))
                    
                    Text("Nothing is sent to our servers — because we don't have any.")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    // MARK: - What We Don't Do
    private var doNotDoSection: some View {
        privacyCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("What We Don't Do", systemImage: "hand.raised.fill")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    dontItem("No account creation required")
                    dontItem("No email or personal info collection")
                    dontItem("No location access")
                    dontItem("No camera or microphone access")
                    dontItem("No advertising or tracking")
                    dontItem("No third-party analytics")
                    dontItem("No internet connection required")
                }
            }
        }
    }
    
    // MARK: - Children's Privacy
    private var childrensPrivacySection: some View {
        privacyCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Children's Privacy (COPPA)", systemImage: "figure.child")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    privacyText("This app is designed for children and families learning Telugu.")
                    privacyText("We fully comply with COPPA — no personal information is collected from users of any age.")
                    privacyText("Parents can erase all data at any time from Settings → Reset Progress.")
                }
            }
        }
    }
    
    // MARK: - Contact
    private var contactSection: some View {
        privacyCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("About This App", systemImage: "heart.text.square.fill")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                privacyText("Built with ❤️ by a young developer passionate about preserving the Telugu language for future generations.")
                
                privacyText("For questions or concerns about privacy, please contact us through the App Store listing.")
            }
        }
    }
    
    // MARK: - Helper Views
    @ViewBuilder
    private func privacyCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            )
    }
    
    private func dataItem(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 28, height: 28)
                .background(color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 7))
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
    }
    
    private func dontItem(_ text: String) -> some View {
        HStack(spacing: 10) {
            Text("✗")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.red.opacity(0.85))
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
    }
    
    private func privacyText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.80))
            .lineSpacing(4)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
