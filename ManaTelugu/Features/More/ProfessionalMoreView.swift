import SwiftUI

// MARK: - Professional More View
struct ProfessionalMoreView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Professional gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.9),
                        Color(red: 0.4, green: 0.2, blue: 0.8),
                        Color(red: 0.8, green: 0.3, blue: 0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                ScrollView {
                    LazyVStack(spacing: ProfessionalSpacing.large.value) {
                        // Header Section
                        ProfessionalCard(type: .hero) {
                            VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                                ProfessionalText(
                                    "More Options",
                                    style: .heroTitle,
                                    color: .textPrimary
                                )
                                
                                ProfessionalText(
                                    "Manage your profile, settings, and get support",
                                    style: .bodyText,
                                    color: .textSecondary
                                )
                            }
                        }
                        .padding(.top, ProfessionalSpacing.extraLarge.value)
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                            ProfessionalSectionHeader(
                                title: "Settings",
                                subtitle: "Customize your experience"
                            )
                            
                            VStack(spacing: ProfessionalSpacing.small.value) {
                                ProfessionalMoreOptionCard(
                                    title: "Profile Settings",
                                    icon: "person.crop.circle",
                                    action: { /* Navigate to Profile Settings */ }
                                )
                                ProfessionalMoreOptionCard(
                                    title: "Progress Dashboard",
                                    icon: "chart.bar.fill",
                                    action: { /* Navigate to Progress Dashboard */ }
                                )
                            }
                        }
                        
                        // Support Section
                        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                            ProfessionalSectionHeader(
                                title: "Support",
                                subtitle: "Get help and contact us"
                            )
                            
                            VStack(spacing: ProfessionalSpacing.small.value) {
                                ProfessionalMoreOptionCard(
                                    title: "Help & FAQ",
                                    icon: "questionmark.circle.fill",
                                    action: { /* Navigate to Help & FAQ */ }
                                )
                                ProfessionalMoreOptionCard(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    action: { /* Navigate to Contact Us */ }
                                )
                            }
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: ProfessionalSpacing.medium.value) {
                            ProfessionalSectionHeader(
                                title: "About",
                                subtitle: "Learn more about Mana Telugu"
                            )
                            
                            VStack(spacing: ProfessionalSpacing.small.value) {
                                ProfessionalMoreOptionCard(
                                    title: "About This App",
                                    icon: "info.circle.fill",
                                    action: { /* Navigate to About App */ }
                                )
                                ProfessionalMoreOptionCard(
                                    title: "Privacy Policy",
                                    icon: "hand.raised.fill",
                                    action: { /* Navigate to Privacy Policy */ }
                                )
                                ProfessionalMoreOptionCard(
                                    title: "Terms of Service",
                                    icon: "doc.text.fill",
                                    action: { /* Navigate to Terms of Service */ }
                                )
                            }
                        }
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 120)
                    }
                    .padding(.horizontal, ProfessionalSpacing.medium.value)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Professional More Option Card
struct ProfessionalMoreOptionCard: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ProfessionalCard(type: .interactive, isInteractive: true) {
                HStack(spacing: ProfessionalSpacing.medium.value) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.professionalBlue)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.professionalBlue.opacity(0.15))
                        )
                    
                    ProfessionalText(title, style: .cardTitle, color: .textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// MARK: - Preview
#Preview {
    ProfessionalMoreView()
        .environmentObject(AppSession())
}
