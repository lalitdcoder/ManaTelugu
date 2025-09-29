import SwiftUI

struct ElegantLessonsView: View {
    @EnvironmentObject var session: AppSession
    @State private var lessons: [TeluguLesson] = teluguLessons
    
    var body: some View {
        NavigationView {
            ZStack {
                ElegantGradient()
                    .ignoresSafeArea(.all, edges: .all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: ElegantDesign.Spacing.xl) {
                        // Header
                        headerSection
                            .padding(.top, ElegantDesign.Spacing.xl)
                        
                        // Lessons List
                        lessonsSection
                    }
                    .padding(.horizontal, ElegantDesign.Spacing.md)
                    .padding(.bottom, ElegantDesign.Spacing.xl)
                }
            }
            .navigationTitle("Telugu Alphabet")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
            Text("Learn Telugu letters step by step")
                .font(ElegantDesign.Typography.body)
                .foregroundColor(ElegantDesign.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var lessonsSection: some View {
        VStack(spacing: ElegantDesign.Spacing.md) {
            ForEach(lessons, id: \.id) { lesson in
                lessonCard(lesson)
            }
        }
    }
    
    private func lessonCard(_ lesson: TeluguLesson) -> some View {
        NavigationLink(destination: LessonFlowView(lesson: lesson)) {
            HStack(spacing: ElegantDesign.Spacing.md) {
                // Lesson number
                ZStack {
                    Circle()
                        .fill(lesson.isCompleted ? ElegantDesign.Colors.success : 
                              lesson.isUnlocked ? ElegantDesign.Colors.primary.opacity(0.1) : 
                              ElegantDesign.Colors.textTertiary.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    if lesson.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    } else if lesson.isUnlocked {
                        Text("\(lesson.id)")
                            .font(ElegantDesign.Typography.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(ElegantDesign.Colors.primary)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(ElegantDesign.Colors.textTertiary)
                    }
                }
                
                // Lesson content
                VStack(alignment: .leading, spacing: ElegantDesign.Spacing.xs) {
                    Text(lesson.title)
                        .font(ElegantDesign.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(lesson.isUnlocked ? ElegantDesign.Colors.textPrimary : ElegantDesign.Colors.textTertiary)
                    
                    HStack {
                        ForEach(lesson.letters.prefix(4), id: \.character) { letter in
                            Text(letter.character)
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(lesson.isUnlocked ? ElegantDesign.Colors.primary : ElegantDesign.Colors.textTertiary)
                        }
                        if lesson.letters.count > 4 {
                            Text("...")
                                .foregroundColor(lesson.isUnlocked ? ElegantDesign.Colors.primary : ElegantDesign.Colors.textTertiary)
                        }
                    }
                    
                    Text("\(lesson.letters.count) letters")
                        .font(ElegantDesign.Typography.caption)
                        .foregroundColor(ElegantDesign.Colors.textTertiary)
                }
                
                Spacer()
                
                if lesson.isUnlocked {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ElegantDesign.Colors.textTertiary)
                }
            }
            .padding(ElegantDesign.Spacing.md)
            .elegantCard()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!lesson.isUnlocked)
    }
}
