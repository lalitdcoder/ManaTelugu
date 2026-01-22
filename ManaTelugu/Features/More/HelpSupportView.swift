import SwiftUI

struct HelpSupportView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var showingContactForm = false
    @State private var contactSubject = ""
    @State private var contactMessage = ""
    @State private var contactEmail = ""
    
    var body: some View {
        ZStack {
            // Beautiful gradient background (static version of original animated background)
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: [
                        RefinedColors.gradientBlue,
                        RefinedColors.gradientPurple,
                        RefinedColors.gradientPink,
                        RefinedColors.gradientOrange
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all, edges: .all)
                
                // Subtle overlay for depth
                LinearGradient(
                    colors: [
                        RefinedColors.gradientPurple.opacity(0.3),
                        RefinedColors.gradientBlue.opacity(0.3)
                    ],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea(.all, edges: .all)
            }
            
            EnhancedScrollView(bottomPadding: 140) {
                VStack(spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Quick Help Section
                    quickHelpSection
                    
                    // FAQ Section
                    faqSection
                    
                    // Contact Section
                    contactSection
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingContactForm) {
            contactFormSheet
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(20)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            LiquidGlassHeader(
                title: "Help & Support",
                subtitle: "Get the help you need to learn Telugu effectively",
                iconName: "questionmark.circle.fill",
                iconColor: ModernDesignSystem.Colors.funBlue,
                layer: .content
            )
            
            // Quick Stats
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("24/7")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    Text("Support")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(spacing: 4) {
                    Text("< 2hrs")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    Text("Response")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(spacing: 4) {
                    Text("100%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                    Text("Free")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Quick Help Section
    private var quickHelpSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "Quick Help",
                iconName: "lightbulb.fill",
                iconColor: ModernDesignSystem.Colors.funYellow
            )
            
            VStack(spacing: 16) {
                HelpCard(
                    title: "Getting Started",
                    description: "Learn the basics of using ManaTelugu",
                    icon: "play.circle.fill",
                    color: ModernDesignSystem.Colors.funGreen
                ) {
                    // Navigate to getting started guide
                }
                
                HelpCard(
                    title: "Alphabet Learning",
                    description: "Master Telugu letters and pronunciation",
                    icon: "textformat.abc",
                    color: ModernDesignSystem.Colors.funBlue
                ) {
                    // Navigate to alphabet guide
                }
                
                HelpCard(
                    title: "Progress Tracking",
                    description: "Understand your learning journey",
                    icon: "chart.bar.fill",
                    color: ModernDesignSystem.Colors.funPurple
                ) {
                    // Navigate to progress guide
                }
                
                HelpCard(
                    title: "Parental Controls",
                    description: "Set up safe learning environment",
                    icon: "shield.fill",
                    color: ModernDesignSystem.Colors.funPink
                ) {
                    // Navigate to parental controls
                }
            }
        }
    }
    
    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "Frequently Asked Questions",
                iconName: "questionmark.circle.fill",
                iconColor: ModernDesignSystem.Colors.funPink
            )
            
            VStack(spacing: 12) {
                FAQItem(
                    question: "How do I track my progress?",
                    answer: "Your progress is automatically tracked as you complete lessons, games, and activities. Check the Progress section in the More tab."
                )
                
                FAQItem(
                    question: "Can I use the app offline?",
                    answer: "Yes! Once you download content, you can learn offline. Your progress will sync when you're back online."
                )
                
                FAQItem(
                    question: "How do I reset my progress?",
                    answer: "Go to Settings > Reset Progress. This will clear all your learning data and start fresh."
                )
                
                FAQItem(
                    question: "Is the app safe for children?",
                    answer: "Absolutely! We have parental controls and kid-friendly content. Parents can monitor and control their child's learning experience."
                )
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            LiquidGlassSectionHeader(
                title: "Contact Us",
                iconName: "envelope.fill",
                iconColor: ModernDesignSystem.Colors.funPink
            )
            
            VStack(spacing: 16) {
                ContactCard(
                    title: "Email Support",
                    subtitle: "manateluguhelp@gmail.com",
                    icon: "envelope.fill",
                    color: ModernDesignSystem.Colors.funBlue
                ) {
                    showingContactForm = true
                }
                
                ContactCard(
                    title: "Response Time",
                    subtitle: "We typically respond within 2 hours",
                    icon: "clock.fill",
                    color: ModernDesignSystem.Colors.funGreen
                ) {
                    // Show response time info
                }
                
                ContactCard(
                    title: "Feedback",
                    subtitle: "Help us improve ManaTelugu",
                    icon: "heart.fill",
                    color: ModernDesignSystem.Colors.funPink
                ) {
                    showingContactForm = true
                }
            }
        }
    }
    
    // MARK: - Contact Form Sheet
    private var contactFormSheet: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    // Base gradient
                    LinearGradient(
                        colors: [
                            RefinedColors.gradientBlue,
                            RefinedColors.gradientPurple,
                            RefinedColors.gradientPink,
                            RefinedColors.gradientOrange
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Subtle overlay for depth
                    LinearGradient(
                        colors: [
                            RefinedColors.gradientPurple.opacity(0.3),
                            RefinedColors.gradientBlue.opacity(0.3)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                    .ignoresSafeArea()
                }
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Us")
                            .font(ModernDesignSystem.Typography.title1)
                            .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        
                        Text("We'd love to hear from you! Send us your questions, feedback, or suggestions.")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        TextField("Your Email", text: $contactEmail)
                            .textFieldStyle(EnhancedTextFieldStyle())
                        
                        TextField("Subject", text: $contactSubject)
                            .textFieldStyle(EnhancedTextFieldStyle())
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Message")
                                .font(ModernDesignSystem.Typography.caption)
                                .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                            
                            TextEditor(text: $contactMessage)
                                .frame(minHeight: 120)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.regularMaterial)
                                        .stroke(.separator, lineWidth: 1)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    Button("Send Message") {
                        HapticsService.shared.importantAction()
                        sendContactMessage()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(contactEmail.isEmpty || contactSubject.isEmpty || contactMessage.isEmpty)
                }
                .padding(20)
            }
            .navigationTitle("Contact Form")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        HapticsService.shared.navigationTap()
                        showingContactForm = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func sendContactMessage() {
        // In a real app, this would send the email
        // For now, we'll just show a success message
        showingContactForm = false
        contactEmail = ""
        contactSubject = ""
        contactMessage = ""
    }
}

// MARK: - Help Card
struct HelpCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsService.shared.buttonTap()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: ModernDesignSystem.Spacing.minimumTouchTarget, height: ModernDesignSystem.Spacing.minimumTouchTarget)
                    .background(
                        Circle()
                            .fill(color.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ModernDesignSystem.Colors.tertiaryText)
            }
            .padding(16)
            .background(
            Color.clear
                .glassEffect(.regular, shape: .rect(cornerRadius: 16))
            )
        }
.buttonStyle(HapticPlainButtonStyle())
    }
}

// MARK: - FAQ Item
struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { 
                HapticsService.shared.buttonTap()
                isExpanded.toggle() 
            }) {
                HStack {
                    Text(question)
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ModernDesignSystem.Colors.tertiaryText)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                    .multilineTextAlignment(.leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            Color.clear
                .glassEffect(.subtle, shape: .rect(cornerRadius: 12))
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

// MARK: - Contact Card
struct ContactCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsService.shared.buttonTap()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: ModernDesignSystem.Spacing.minimumTouchTarget, height: ModernDesignSystem.Spacing.minimumTouchTarget)
                    .background(
                        Circle()
                            .fill(color.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(ModernDesignSystem.Typography.headline)
                        .foregroundColor(ModernDesignSystem.Colors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ModernDesignSystem.Colors.tertiaryText)
            }
            .padding(16)
            .background(
            Color.clear
                .glassEffect(.regular, shape: .rect(cornerRadius: 16))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Enhanced Text Field Style
struct EnhancedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .stroke(.separator, lineWidth: 1)
            )
    }
}

#Preview {
    HelpSupportView()
        .environmentObject(AppSession())
}
