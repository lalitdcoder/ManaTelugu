import SwiftUI

// MARK: - iPad-Optimized Lessons View
/// Adapts lessons for iPad with:
/// - Split view showing lesson list and content side-by-side
/// - Larger lesson cards with better readability
/// - Multi-column layout for lesson categories
/// - Optimized spacing and touch targets
struct IPadOptimizedLessonsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var lessons: [ProfessionalLesson] = []
    @State private var selectedLesson: ProfessionalLesson?
    @State private var isLoading = true
    @State private var selectedCategory: String = "all"
    
    private let categories = ["All", "Beginner", "Intermediate", "Advanced"]
    
    var body: some View {
        ZStack {
            // Background gradient
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
                        .tint(.white)
                    
                    Text("Loading lessons...")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            } else if horizontalSizeClass == .regular {
                // iPad: Split view layout
                iPadSplitLayout
            } else {
                // iPhone: Standard scroll layout
                iPhoneLayout
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadLessons()
        }
    }
    
    // MARK: - iPad Split View Layout
    private var iPadSplitLayout: some View {
        NavigationSplitView {
            // Sidebar: Lesson List
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Lessons")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Learn Telugu step by step")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                    )
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category.lowercased() }) {
                                    Text(category)
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    selectedCategory == category.lowercased() ?
                                                    Color.white :
                                                    Color.white.opacity(0.2)
                                                )
                                        )
                                        .foregroundColor(
                                            selectedCategory == category.lowercased() ?
                                            Color.blue :
                                            Color.white
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)
                    
                    // Lesson List
                    VStack(spacing: 12) {
                        ForEach(filteredLessons, id: \.id) { lesson in
                            Button(action: { selectedLesson = lesson }) {
                                HStack(spacing: 16) {
                                    // Status Icon
                                    ZStack {
                                        Circle()
                                            .fill(lesson.isLocked ? Color.gray.opacity(0.3) : lesson.difficulty.color.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                        
                                        if lesson.isLocked {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.white)
                                        } else if lesson.isCompleted {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "play.circle.fill")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(lesson.difficulty.color)
                                        }
                                    }
                                    
                                    // Lesson Info
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(lesson.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Text(lesson.difficulty.displayName)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(lesson.difficulty.color)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedLesson?.id == lesson.id {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            selectedLesson?.id == lesson.id ?
                                            Color.white.opacity(0.2) :
                                            Color.white.opacity(0.1)
                                        )
                                )
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 20)
                }
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
        } detail: {
            // Detail: Lesson Content
            if let lesson = selectedLesson {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Lesson Header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(lesson.title)
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(lesson.description)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                // Difficulty Badge
                                VStack(spacing: 8) {
                                    Text(lesson.difficulty.displayName)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(lesson.difficulty.color)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(lesson.difficulty.color.opacity(0.2))
                                        )
                                    
                                    Text(lesson.estimatedTime)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.2))
                        )
                        
                        // Progress Section
                        if lesson.progress > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Progress")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(lesson.progress * 100))%")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(lesson.difficulty.color)
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white.opacity(0.2))
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(lesson.difficulty.color)
                                            .frame(width: geometry.size.width * lesson.progress)
                                    }
                                }
                                .frame(height: 8)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.2))
                            )
                        }
                        
                        // Action Button
                        if !lesson.isLocked {
                            Button(action: { /* Start lesson */ }) {
                                HStack(spacing: 12) {
                                    Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "play.circle.fill")
                                    Text(lesson.isCompleted ? "Review Lesson" : "Start Lesson")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .font(.system(size: 18, weight: .semibold))
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(lesson.difficulty.color)
                                )
                                .foregroundColor(.white)
                            }
                        }
                        
                        Color.clear.frame(height: 20)
                    }
                    .padding(24)
                }
                .scrollIndicators(.hidden)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "hand.point.left.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("Select a lesson to view details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // MARK: - iPhone Standard Layout
    private var iPhoneLayout: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Lessons")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Learn Telugu step by step")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                )
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category.lowercased() }) {
                                Text(category)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(
                                                selectedCategory == category.lowercased() ?
                                                Color.white :
                                                Color.white.opacity(0.2)
                                            )
                                    )
                                    .foregroundColor(
                                        selectedCategory == category.lowercased() ?
                                        Color.blue :
                                        Color.white
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
                
                // Lesson List
                VStack(spacing: 12) {
                    ForEach(filteredLessons, id: \.id) { lesson in
                        Button(action: { selectedLesson = lesson }) {
                            HStack(spacing: 12) {
                                // Status Icon
                                ZStack {
                                    Circle()
                                        .fill(lesson.isLocked ? Color.gray.opacity(0.3) : lesson.difficulty.color.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                    
                                    if lesson.isLocked {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                    } else if lesson.isCompleted {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.green)
                                    } else {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(lesson.difficulty.color)
                                    }
                                }
                                
                                // Lesson Info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lesson.title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    
                                    HStack(spacing: 8) {
                                        Text(lesson.difficulty.displayName)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(lesson.difficulty.color)
                                        
                                        Text("•")
                                            .foregroundColor(.white.opacity(0.5))
                                        
                                        Text(lesson.estimatedTime)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Color.clear.frame(height: 20)
            }
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Helper Methods
    private var filteredLessons: [ProfessionalLesson] {
        if selectedCategory == "all" {
            return lessons
        }
        return lessons.filter { $0.difficulty.displayName.lowercased() == selectedCategory }
    }
    
    private func loadLessons() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isLoading = false
                // Load actual lessons from data source
            }
        }
    }
}

// MARK: - Preview
#Preview {
    IPadOptimizedLessonsView()
        .environmentObject(AppSession())
}
