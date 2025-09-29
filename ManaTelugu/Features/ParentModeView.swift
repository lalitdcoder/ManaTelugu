import SwiftUI

struct ParentModeView: View {
    @State private var isAuthenticated = false
    @State private var enteredPassword = ""
    @State private var showingError = false
    private let correctPassword = "1234" // Simple password for demo
    
    var body: some View {
        ZStack {
            ElegantGradient()
                .ignoresSafeArea(.all, edges: .all)
            
            if isAuthenticated {
                authenticatedView
            } else {
                passwordView
            }
        }
        .navigationTitle("Parent Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var passwordView: some View {
        VStack(spacing: ElegantDesign.Spacing.xl) {
            VStack(spacing: ElegantDesign.Spacing.lg) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ElegantDesign.Colors.primary)
                
                Text("Parent Mode")
                    .font(ElegantDesign.Typography.title1)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
                
                Text("Enter password to access parental controls")
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: ElegantDesign.Spacing.md) {
                SecureField("Password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(ElegantDesign.Typography.body)
                
                ElegantButton(title: "Enter", style: .primary) {
                    authenticatePassword()
                }
                
                if showingError {
                    Text("Incorrect password. Try again.")
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(ElegantDesign.Spacing.xl)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(ElegantDesign.Spacing.md)
    }
    
    private var authenticatedView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: ElegantDesign.Spacing.xl) {
                // Header
                headerSection
                    .padding(.top, ElegantDesign.Spacing.xl)
                
                // About Section
                aboutSection
                
                // Support Section
                supportSection
                
                // Settings Section
                parentSettingsSection
            }
            .padding(.horizontal, ElegantDesign.Spacing.md)
            .padding(.bottom, ElegantDesign.Spacing.xl)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Parental Controls")
                .font(ElegantDesign.Typography.title1)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Text("Manage your child's learning experience and access app information")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("About Mana Telugu")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                infoRow("Version", "1.0.0", "info.circle.fill")
                infoRow("Developer", "Mana Telugu Team", "person.circle.fill")
                infoRow("Contact", "support@manatelugu.com", "envelope.fill")
                infoRow("Website", "www.manatelugu.com", "globe")
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Support & Legal")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Privacy Policy", "hand.raised.fill", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Terms of Service", "doc.text.fill", ElegantDesign.Colors.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Help & Support", "questionmark.circle.fill", ElegantDesign.Colors.accent)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Contact Us", "envelope.fill", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var parentSettingsSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.md) {
            Text("Parental Settings")
                .font(ElegantDesign.Typography.headline)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            VStack(spacing: ElegantDesign.Spacing.sm) {
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Kid Mode Settings", "figure.and.child.holdinghands", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Progress Reports", "chart.bar.fill", ElegantDesign.Colors.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Time Limits", "clock.fill", ElegantDesign.Colors.accent)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { hapticFeedback() }) {
                    menuRowContent("Reset Progress", "arrow.clockwise.circle.fill", ElegantDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func infoRow(_ title: String, _ value: String, _ icon: String) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ElegantDesign.Colors.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                Text(title)
                    .font(ElegantDesign.Typography.caption)
                    .foregroundColor(ElegantDesign.Colors.textSecondary)
                
                Text(value)
                    .font(ElegantDesign.Typography.body)
                    .foregroundColor(ElegantDesign.Colors.textPrimary)
            }
            
            Spacer()
        }
        .padding(ElegantDesign.Spacing.md)
        .background(ElegantDesign.Colors.surfaceSecondary)
        .cornerRadius(ElegantDesign.CornerRadius.md)
    }
    
    private func menuRowContent(_ title: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: ElegantDesign.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ElegantDesign.Colors.textTertiary)
        }
        .padding(ElegantDesign.Spacing.md)
        .background(ElegantDesign.Colors.surfaceSecondary)
        .cornerRadius(ElegantDesign.CornerRadius.md)
    }
    
    private func authenticatePassword() {
        hapticFeedback()
        if enteredPassword == correctPassword {
            withAnimation {
                isAuthenticated = true
                showingError = false
            }
        } else {
            showingError = true
            enteredPassword = ""
        }
    }
    
    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}
