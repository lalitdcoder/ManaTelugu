import SwiftUI

struct ProfessionalMoreView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingParentMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Stronger gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                        Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 12) {
                            Text("🎯")
                                .font(.system(size: 50))

                            Text("More Options")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Track progress and manage settings")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)

                        // Cards
                        VStack(spacing: 16) {
                            NavigationLink(destination: EnhancedProgressView()) {
                                MoreCard(
                                    icon: "📊",
                                    title: "Progress Dashboard",
                                    subtitle: "View your learning journey",
                                    color: .blue
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button {
                                showingParentMode = true
                            } label: {
                                MoreCard(
                                    icon: "👨‍👩‍👧‍👦",
                                    title: "Parent Mode",
                                    subtitle: "Parental controls and settings",
                                    color: .professionalPurple
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $showingParentMode) {
                    NavigationStack {
                        SimplifiedParentModeView()
                    }
                }
            }
        }
    }
}

struct MoreCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 32))
                .frame(width: 60, height: 60)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ProfessionalMoreView()
        .environmentObject(AppSession())
}
