import SwiftUI

struct ContactUsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [RefinedColors.background, RefinedColors.secondaryBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                EnhancedScrollView {
                    VStack(spacing: 24) {
                        // Header
                        LiquidGlassHeader(
                            title: "Contact Us",
                            subtitle: "We'd love to hear from you!",
                            iconName: "envelope.fill",
                            iconColor: RefinedColors.softGreen,
                            layer: .content
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Contact Form
                        VStack(spacing: 20) {
                            // Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(EnhancedTypography.caption)
                                    .foregroundColor(RefinedColors.charcoal)
                                
                                TextField("Your name", text: $name)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(RefinedColors.glassWhite.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(RefinedColors.mediumGray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(EnhancedTypography.caption)
                                    .foregroundColor(RefinedColors.charcoal)
                                
                                TextField("your.email@example.com", text: $email)
                                    .textFieldStyle(.plain)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(RefinedColors.glassWhite.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(RefinedColors.mediumGray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Subject Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Subject")
                                    .font(EnhancedTypography.caption)
                                    .foregroundColor(RefinedColors.charcoal)
                                
                                TextField("What's this about?", text: $subject)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(RefinedColors.glassWhite.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(RefinedColors.mediumGray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Message Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message")
                                    .font(EnhancedTypography.caption)
                                    .foregroundColor(RefinedColors.charcoal)
                                
                                TextField("Tell us how we can help...", text: $message, axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .lineLimit(5...10)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(RefinedColors.glassWhite.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(RefinedColors.mediumGray.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Submit Button
                        LiquidGlassButton(
                            title: "Send Message"
                        ) {
                            // Simulate sending message
                            showingSuccess = true
                        }
                        .padding(.horizontal, 20)
                        
                        // Contact Information
                        VStack(spacing: 16) {
                            LiquidGlassSectionHeader(
                                title: "Other Ways to Reach Us",
                                iconName: "phone.fill",
                                iconColor: RefinedColors.warmYellow
                            )
                            
                            VStack(spacing: 12) {
                                ContactInfoRow(
                                    icon: "envelope.fill",
                                    title: "Email",
                                    value: "support@manatelugu.com",
                                    action: { /* Open email */ }
                                )
                                
                                ContactInfoRow(
                                    icon: "phone.fill",
                                    title: "Phone",
                                    value: "+1 (555) 123-4567",
                                    action: { /* Open phone */ }
                                )
                                
                                ContactInfoRow(
                                    icon: "globe",
                                    title: "Website",
                                    value: "www.manatelugu.com",
                                    action: { /* Open website */ }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 140) // Prevent overlap with tab bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Message Sent!", isPresented: $showingSuccess) {
            Button("OK") { }
        } message: {
            Text("Thank you for contacting us! We'll get back to you within 24 hours.")
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(RefinedColors.warmYellow)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(EnhancedTypography.caption)
                        .foregroundColor(RefinedColors.mediumGray)
                    
                    Text(value)
                        .font(EnhancedTypography.bodyText)
                        .foregroundColor(RefinedColors.charcoal)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(RefinedColors.mediumGray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                UnifiedLiquidGlassCard(
                    layer: .content,
                    intensity: 0.1,
                    cornerRadius: 12,
                    padding: 0,
                    isInteractive: false
                ) {
                    Color.clear
                }
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactUsView()
}
