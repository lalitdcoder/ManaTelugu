import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: AppSession

    @State private var showGames = false
    @State private var showAlphabet = false
    @State private var showVocabulary = false
    @State private var showThemePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Apple-style background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Header - Apple-style
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Welcome!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("Ready to explore Telugu?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { showThemePicker = true }) {
                                Image(systemName: "paintpalette.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        // Section: Alphabet Adventure
                        SectionCard(
                            title: "Alphabet Adventure",
                            icon: "textformat.abc.dottedunderline",
                            accent: MTColors.funBlue,
                            action: { 
                                print("Alphabet button tapped!")
                                showAlphabet = true 
                                print("showAlphabet set to: \(showAlphabet)")
                            },
                            content: {
                                Text("Learn Telugu letters with interactive activities.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        )
                        NavigationLink(destination: AlphabetGridView().environmentObject(session), isActive: $showAlphabet) { 
                            EmptyView() 
                        }
                        .hidden()
                        .onChange(of: showAlphabet) { newValue in
                            print("showAlphabet changed to: \(newValue)")
                        }
                        // Section: Vocabulary Quest
                        SectionCard(
                            title: "Vocabulary Quest",
                            icon: "books.vertical",
                            accent: MTColors.funGreen,
                            action: { showVocabulary = true },
                            content: {
                                Text("Explore new words and meanings.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        )
                        NavigationLink(destination: VocabularyThemesView().environmentObject(session), isActive: $showVocabulary) { 
                            EmptyView() 
                        }
                        .hidden()
                        // Section: Game Zone
                        SectionCard(
                            title: "Game Zone",
                            icon: "gamecontroller.fill",
                            accent: MTColors.funPink,
                            action: { showGames = true },
                            content: {
                                Text("Play fun Telugu games!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        )
                        NavigationLink(destination: GamesHubView().environmentObject(session), isActive: $showGames) { 
                            EmptyView() 
                        }
                        .hidden()
                        // Modern Progress Bar
                        ModernProgressBar(progress: min(Double(session.userProfile.totalXP) / 1000.0, 1.0))
                            .padding(.horizontal)
                        // Modern Badges Row
                        ModernBadgesRow()
                            .padding(.horizontal)
                        // Theme picker placeholder
                        if showThemePicker {
                            ThemePickerView(isPresented: $showThemePicker)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavBarIcon(systemName: "house.fill", selected: true)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavBarIcon(systemName: "star.fill", selected: false)
                }
            }
        }
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let accent: Color
    let action: () -> Void
    let content: () -> Content
    @EnvironmentObject var session: AppSession
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { isPressed = false }
        }) {
            HStack(spacing: 16) {
                // Apple-style icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(accent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    content()
                }
                
                Spacer()
                
                // Apple-style chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .frame(minHeight: 44) // Apple's minimum touch target
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Modern Progress Bar
struct ModernProgressBar: View {
    let progress: Double // 0.0 to 1.0
    @EnvironmentObject var session: AppSession
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 18)
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [MTColors.funBlue, MTColors.funGreen, MTColors.funPink]), startPoint: .leading, endPoint: .trailing))
                .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.8, height: 18)
                .animation(.easeOut(duration: 1.0), value: progress)
            Text("Progress")
                .font(MTTypography.caption(kidMode: session.userProfile.kidMode))
                .foregroundColor(.gray)
                .padding(.leading, 12)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Modern Badges Row
struct ModernBadgesRow: View {
    @EnvironmentObject var session: AppSession
    @State private var badges: [String] = ["star.fill", "rosette", "flame.fill"]
    var body: some View {
        HStack(spacing: 28) {
            ForEach(badges, id: \ .self) { badge in
                Image(systemName: badge)
                    .font(.system(size: 36))
                    .foregroundColor(MTColors.funYellow)
                    .shadow(color: MTColors.funBlue.opacity(0.12), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Modern NavBar Icon
struct NavBarIcon: View {
    let systemName: String
    let selected: Bool
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(selected ? MTColors.funBlue : Color.gray.opacity(0.5))
            .shadow(color: selected ? MTColors.funBlue.opacity(0.18) : .clear, radius: 4, x: 0, y: 2)
            .background(
                Circle()
                    .fill(Color.white.opacity(selected ? 0.9 : 0.5))
                    .frame(width: 44, height: 44)
            )
    }
}

// MARK: - Theme Picker Placeholder
struct ThemePickerView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a Theme (Coming Soon)")
                .font(.title2)
                .foregroundColor(MTColors.text)
            Button("Close") { isPresented = false }
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.98))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(40)
    }
}