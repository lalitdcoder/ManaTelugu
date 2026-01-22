import SwiftUI

// MARK: - iPad-Optimized Alphabet View
/// Adapts alphabet learning for iPad with:
/// - 4-column grid for letters on iPad (vs 2-3 on iPhone)
/// - Larger letter cards with better touch targets
/// - Split view for letter details on iPad
/// - Optimized spacing and typography
struct IPadOptimizedAlphabetView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var letters: [Letter] = []
    @State private var isLoading = true
    @State private var selectedLetter: Letter?
    @State private var navigateToQuiz = false
    @State private var navigateToVowels = false
    @State private var navigateToConsonants = false
    @State private var navigateToTracing = false
    
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
                
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.blue)
                        
                        Text("Loading alphabet...")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(32)
                } else if horizontalSizeClass == .regular {
                    // iPad: Split view layout
                    iPadSplitLayout
                } else {
                    // iPhone: Standard scroll layout
                    iPhoneLayout
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToQuiz) {
                LettersQuizView(scope: .all)
            }
            .navigationDestination(isPresented: $navigateToVowels) {
                VowelsView()
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $navigateToConsonants) {
                ConsonantsView()
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $navigateToTracing) {
                TraceGameView()
                    .environmentObject(session)
            }
        }
        .onAppear {
            loadLetters()
        }
    }
    
    // MARK: - iPad Split View Layout
    /// Simplified iPad layout to avoid type-checking issues
    /// Uses NavigationSplitView with sidebar and detail view
    private var iPadSplitLayout: some View {
        NavigationSplitView {
            iPadSidebar
        } detail: {
            iPadDetail
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // MARK: - iPad Sidebar
    private var iPadSidebar: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Telugu Alphabet")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Learn all Telugu letters")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.2)))
                
                // Learning Modes
                VStack(spacing: 12) {
                    modeButton(title: "Vowels", icon: "a.circle.fill", color: .blue) { navigateToVowels = true }
                    modeButton(title: "Consonants", icon: "k.circle.fill", color: .green) { navigateToConsonants = true }
                    modeButton(title: "Tracing", icon: "pencil.tip.crop.circle.fill", color: .orange) { navigateToTracing = true }
                    modeButton(title: "Quiz", icon: "questionmark.circle.fill", color: .purple) { navigateToQuiz = true }
                }
                
                // Letter Grid (4 columns on iPad)
                let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(letters, id: \.id) { letter in
                        letterButton(letter)
                    }
                }
                
                Color.clear.frame(height: 20)
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .background(LinearGradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.9), Color(red: 0.4, green: 0.2, blue: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
    }
    
    // MARK: - iPad Detail
    @ViewBuilder
    private var iPadDetail: some View {
        if let letter = selectedLetter {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Large Letter Display
                    VStack(spacing: 16) {
                        Text(letter.character)
                            .font(.system(size: 120, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(letter.romanization)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Meaning: \(letter.meaning)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    
                    // Letter Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Letter Information")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Meaning")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(letter.meaning)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.1)))
                    }
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(action: { navigateToQuiz = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "questionmark.circle.fill")
                                Text("Quiz")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                        }
                        
                        Button(action: { navigateToTracing = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil.tip.crop.circle.fill")
                                Text("Trace")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange))
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    Color.clear.frame(height: 20)
                }
                .padding(24)
            }
            .scrollIndicators(.hidden)
            .background(LinearGradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.9), Color(red: 0.4, green: 0.2, blue: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        } else {
            VStack(spacing: 16) {
                Image(systemName: "hand.point.left.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.5))
                
                Text("Select a letter to view details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.9), Color(red: 0.4, green: 0.2, blue: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        }
    }
    
    // MARK: - Helper Views
    private func modeButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.2)))
            .foregroundColor(.white)
        }
    }
    
    private func letterButton(_ letter: Letter) -> some View {
        Button(action: { selectedLetter = letter }) {
            VStack(spacing: 8) {
                Text(letter.character)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(letter.romanization)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)).overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1)))
            .scaleEffect(selectedLetter?.id == letter.id ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedLetter?.id)
        }
    }
    
    // MARK: - iPhone Standard Layout
    private var iPhoneLayout: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Hero Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Telugu Alphabet")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Learn all Telugu letters")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                )
                
                // Learning Modes
                VStack(spacing: 12) {
                    Button(action: { navigateToVowels = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "a.circle.fill")
                            Text("Vowels")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.2))
                        )
                        .foregroundColor(.white)
                    }
                    
                    Button(action: { navigateToConsonants = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "k.circle.fill")
                            Text("Consonants")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.2))
                        )
                        .foregroundColor(.white)
                    }
                }
                
                // Letter Grid (2-3 columns on iPhone)
                let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(letters.indices, id: \.self) { index in
                        NavigationLink(destination: LetterDetailView(letters: letters, initialIndex: index)) {
                            VStack(spacing: 8) {
                                Text(letters[index].character)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(letters[index].romanization)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.blue.opacity(0.3),
                                                Color.purple.opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                
                Color.clear.frame(height: 20)
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Helper Methods
    private func loadLetters() {
        // Simulate loading letters
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isLoading = false
                // Load actual letters from data source
            }
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedAlphabetView()
        .environmentObject(AppSession())
}
