import SwiftUI

struct NativeCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ProfessionalMoreView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingParentMode = false

    var body: some View {
        ZStack {
            // Adaptive system grouped background
            ManaTheme.Colors.groupedBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: ManaTheme.Spacing.lg) {
                    // Header Banner
                    moreHeaderCard

                    // Navigation Menu Cards
                    VStack(spacing: ManaTheme.Spacing.sm) {
                        NavigationLink(destination: GamificationDashboardView()) {
                            MoreMenuCard(
                                icon: "chart.bar.xaxis",
                                iconColor: ManaTheme.Colors.peacockBlue,
                                title: "Progress Dashboard",
                                subtitle: "XP, badges, streaks & achievements"
                            )
                        }
                        .buttonStyle(NativeCardButtonStyle())

                        Button {
                            showingParentMode = true
                        } label: {
                            MoreMenuCard(
                                icon: "person.2.fill",
                                iconColor: ManaTheme.Colors.royalIndigo,
                                title: "Parent Mode",
                                subtitle: "Parental controls & oversight"
                            )
                        }
                        .buttonStyle(NativeCardButtonStyle())

                        NavigationLink(destination: SettingsView()) {
                            MoreMenuCard(
                                icon: "gearshape.fill",
                                iconColor: Color.gray,
                                title: "Settings",
                                subtitle: "Audio, appearance & data"
                            )
                        }
                        .buttonStyle(NativeCardButtonStyle())

                        NavigationLink(destination: PrivacyPolicyView()) {
                            MoreMenuCard(
                                icon: "shield.checkmark.fill",
                                iconColor: ManaTheme.Colors.primary,
                                title: "Privacy Policy",
                                subtitle: "100% offline • No data collected"
                            )
                        }
                        .buttonStyle(NativeCardButtonStyle())
                    }

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, ManaTheme.Spacing.screenMarginLarge)
                .padding(.top, ManaTheme.Spacing.sm)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("More")
        .sheet(isPresented: $showingParentMode) {
            ParentModeView()
                .environmentObject(session)
        }
    }

    private var moreHeaderCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(ManaTheme.Colors.primary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Mana Telugu Settings")
                    .font(ManaTheme.Typography.headline)
                    .foregroundColor(ManaTheme.Colors.label)

                Text("Customization, stats & parental controls")
                    .font(ManaTheme.Typography.footnote)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
            }

            Spacer()
        }
        .padding(ManaTheme.Spacing.md)
        .background(ManaTheme.Colors.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card))
    }
}

struct MoreMenuCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(ManaTheme.Typography.bodyEmphasized)
                    .foregroundColor(ManaTheme.Colors.label)

                Text(subtitle)
                    .font(ManaTheme.Typography.caption1)
                    .foregroundColor(ManaTheme.Colors.secondaryLabel)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(ManaTheme.Colors.tertiaryLabel)
        }
        .padding(14)
        .background(ManaTheme.Colors.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: ManaTheme.CornerRadius.card))
    }
}
