import SwiftUI

struct FixedElegantLessonsView: View {
    @EnvironmentObject var session: AppSession
    @State private var lessons: [TeluguLesson] = teluguLessons
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ModernDesignSystem.Spacing.xl) {
                        // Header with proper spacing
                        headerSection
                            .padding(.top, ModernDesignSystem.Spacing.md)
                        
                        // Lessons List with proper spacing
                        lessonsSection
                        
                        // Bottom padding to prevent tab bar overlap
                        Color.clear
                            .frame(height: 100)
                    }
                    .padding(.horizontal, ModernDesignSystem.Spacing.md)
                }
            }
            .navigationTitle("Telugu Lessons")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
            Text("Learn Telugu letters step by step")
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ModernDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private var lessonsSection: some View {
        VStack(spacing: ModernDesignSystem.Spacing.md) {
            ForEach(lessons, id: \.id) { lesson in
                fixedLessonCard(lesson)
            }
        }
    }
    
    private func fixedLessonCard(_ lesson: TeluguLesson) -> some View {
        NavigationLink(destination: LessonFlowView(lesson: lesson)) {
            HStack(spacing: ModernDesignSystem.Spacing.md) {
                // Lesson number with fixed sizing
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
                
                // Lesson content with proper spacing
                VStack(alignment: .leading, spacing: ModernDesignSystem.Spacing.xs) {
                    Text(lesson.title)
                        .font(ModernDesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(lesson.isUnlocked ? ModernDesignSystem.Colors.textPrimary : ModernDesignSystem.Colors.textTertiary)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
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
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
.buttonStyle(HapticPlainButtonStyle())
        .disabled(!lesson.isUnlocked)
    }
}
