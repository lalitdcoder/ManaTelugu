import SwiftUI

struct ElegantLessonsView: View {
    @EnvironmentObject var session: AppSession
    @State private var lessons: [TeluguLesson] = teluguLessons
    
    var body: some View {
        ZStack {
                // Stronger gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                        Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.xl)
                        
                        // Lessons List
                        lessonsSection
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                    .padding(.bottom, ModernDesignSystem.Spacing.xl)
                }
            }
            .navigationTitle("Telugu Alphabet")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1),
                        Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.08)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text("Learn Telugu letters step by step")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var lessonsSection: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            ForEach(lessons, id: \.id) { lesson in
                lessonCard(lesson)
            }
        }
    }
    
    private func lessonCard(_ lesson: TeluguLesson) -> some View {
        NavigationLink(destination: LessonFlowView(lesson: lesson)) {
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                // Lesson number
                ZStack {
                    Circle()
                        .fill(lesson.isCompleted ? ModernDesignSystem.Colors.success : 
                              lesson.isUnlocked ? ModernDesignSystem.Colors.primary.opacity(0.1) : 
                              ModernDesignSystem.Colors.textTertiary.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    if lesson.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    } else if lesson.isUnlocked {
                        Text("\(lesson.id)")
                            .font(ModernDesignSystem.Typography.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(ModernDesignSystem.Colors.primary)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                    }
                }
                
                // Lesson content
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text(lesson.title)
                        .font(ModernDesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(lesson.isUnlocked ? ModernDesignSystem.Colors.textPrimary : ModernDesignSystem.Colors.textTertiary)
                    
                    HStack {
                        ForEach(lesson.letters.prefix(4), id: \.character) { letter in
                            Text(letter.character)
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(lesson.isUnlocked ? ModernDesignSystem.Colors.primary : ModernDesignSystem.Colors.textTertiary)
                        }
                        if lesson.letters.count > 4 {
                            Text("...")
                                .foregroundColor(lesson.isUnlocked ? ModernDesignSystem.Colors.primary : ModernDesignSystem.Colors.textTertiary)
                        }
                    }
                    
                    Text("\(lesson.letters.count) letters")
                        .font(ModernDesignSystem.Typography.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                }
                
                Spacer()
                
                if lesson.isUnlocked {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ModernDesignSystem.Colors.textTertiary)
                }
            }
            .padding(ModernDesignSystem.Spacing.md)
            .modernCard()
        }
.buttonStyle(HapticPlainButtonStyle())
        .disabled(!lesson.isUnlocked)
    }
}
