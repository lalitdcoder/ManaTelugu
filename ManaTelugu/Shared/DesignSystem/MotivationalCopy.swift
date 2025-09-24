import SwiftUI

// MARK: - Motivational Copy System
// Friendly, encouraging, and culturally appropriate messages

enum MotivationalCopy {
    
    // MARK: - Welcome Messages
    enum Welcome {
        static let greeting = "Welcome to your Telugu learning journey"
        static let encouragement = "Ready to discover the beauty of Telugu language?"
        static let cultural = "Explore the rich heritage of Telugu culture"
    }
    
    // MARK: - Progress Messages
    enum Progress {
        static let greatJob = "Great job! Keep going"
        static let excellent = "Excellent work! You're doing well"
        static let fantastic = "Fantastic! Your progress is inspiring"
        static let outstanding = "Outstanding! You're mastering Telugu beautifully"
        static let incredible = "Incredible! Your dedication is paying off"
        
        // Telugu-specific encouragement
        static let teluguProgress = "చాలా బాగుంది! కొనసాగించండి!" // "Very good! Keep going!"
        static let teluguExcellent = "అద్భుతం! మీరు చాలా బాగా చేస్తున్నారు!" // "Excellent! You're doing very well!"
        static let teluguFantastic = "అద్భుతం! మీ ప్రగతి ప్రేరేపిస్తోంది!" // "Fantastic! Your progress is inspiring!"
    }
    
    // MARK: - Achievement Messages
    enum Achievement {
        static let streak = "Amazing streak! You're on fire"
        static let levelUp = "Level up! You're getting stronger"
        static let badge = "New badge unlocked! You're a Telugu champion"
        static let milestone = "Milestone reached! Your journey is inspiring"
        static let perfect = "Perfect! You're a natural"
        
        // Telugu achievements
        static let teluguStreak = "అద్భుతమైన స్ట్రీక్! మీరు అగ్నిపర్వతంలా ఉన్నారు!" // "Amazing streak! You're like a volcano!"
        static let teluguLevelUp = "లెవెల్ అప్! మీరు బలంగా మారుతున్నారు!" // "Level up! You're getting stronger!"
        static let teluguBadge = "కొత్త బ్యాడ్జ్ అన్లాక్! మీరు తెలుగు ఛాంపియన్!" // "New badge unlocked! You're a Telugu champion!"
    }
    
    // MARK: - Learning Messages
    enum Learning {
        static let newLesson = "New lesson unlocked! Let's learn something amazing"
        static let practice = "Practice makes perfect! You're getting better"
        static let review = "Time for a quick review! You've got this"
        static let challenge = "Ready for a challenge? I believe in you"
        static let discovery = "What a wonderful discovery! Keep exploring"
        
        // Telugu learning
        static let teluguNewLesson = "కొత్త పాఠం అన్లాక్! అద్భుతమైనది నేర్చుకుందాం!" // "New lesson unlocked! Let's learn something amazing!"
        static let teluguPractice = "అభ్యాసం పరిపూర్ణతను తెస్తుంది! మీరు మెరుగవుతున్నారు!" // "Practice brings perfection! You're getting better!"
    }
    
    // MARK: - Error Messages (Encouraging)
    enum Error {
        static let tryAgain = "Not quite right, but don't give up! Try again! 💪"
        static let close = "Close! You're almost there! Keep trying! 🎯"
        static let learning = "That's how we learn! Every mistake is progress! 📈"
        static let patience = "Take your time! Learning is a journey! 🚀"
        static let support = "I'm here to help! Let's try together! 🤝"
        
        // Telugu errors
        static let teluguTryAgain = "సరిగ్గా లేదు, కానీ వదిలేయకండి! మళ్లీ ప్రయత్నించండి!" // "Not quite right, but don't give up! Try again!"
        static let teluguClose = "దగ్గరగా! మీరు దాదాపు అక్కడే ఉన్నారు! కొనసాగించండి!" // "Close! You're almost there! Keep going!"
    }
    
    // MARK: - Cultural Messages
    enum Cultural {
        static let tradition = "Telugu has a rich 2000-year history! You're part of something special! 📜"
        static let heritage = "You're preserving a beautiful cultural heritage! 🌸"
        static let community = "Join millions of Telugu speakers worldwide! 🌍"
        static let wisdom = "Telugu literature is full of wisdom and beauty! 📖"
        static let pride = "Be proud of learning this beautiful language! 🇮🇳"
        
        // Telugu cultural
        static let teluguTradition = "తెలుగుకు 2000 సంవత్సరాల గొప్ప చరిత్ర ఉంది! మీరు ప్రత్యేకమైనదానిలో భాగం!" // "Telugu has a great 2000-year history! You're part of something special!"
        static let teluguHeritage = "మీరు అందమైన సాంస్కృతిక వారసత్వాన్ని సంరక్షిస్తున్నారు!" // "You're preserving a beautiful cultural heritage!"
    }
    
    // MARK: - Daily Motivation
    enum Daily {
        static let morning = "Good morning! Ready to learn some Telugu? ☀️"
        static let afternoon = "Afternoon learning session! Let's make it count! 🌤️"
        static let evening = "Evening practice! You're building great habits! 🌙"
        static let weekend = "Weekend learning! You're dedicated! 🎉"
        static let holiday = "Holiday learning! You're truly committed! 🏖️"
        
        // Telugu daily
        static let teluguMorning = "శుభోదయం! కొంచెం తెలుగు నేర్చుకోవడానికి సిద్ధమా?" // "Good morning! Ready to learn some Telugu?"
        static let teluguEvening = "సాయంత్ర అభ్యాసం! మీరు గొప్ప అలవాట్లను నిర్మిస్తున్నారు!" // "Evening practice! You're building great habits!"
    }
    
    // MARK: - Completion Messages
    enum Completion {
        static let lessonComplete = "Lesson complete! You're amazing! 🎊"
        static let chapterComplete = "Chapter finished! Your progress is incredible! 📚"
        static let levelComplete = "Level mastered! You're unstoppable! 🚀"
        static let courseComplete = "Course completed! You're a Telugu expert! 🏆"
        
        // Telugu completion
        static let teluguLessonComplete = "పాఠం పూర్తయింది! మీరు అద్భుతమైనవారు!" // "Lesson complete! You're amazing!"
        static let teluguChapterComplete = "అధ్యాయం పూర్తయింది! మీ ప్రగతి అద్భుతమైనది!" // "Chapter finished! Your progress is incredible!"
    }
    
    // MARK: - Random Encouragement
    static func randomEncouragement() -> String {
        let messages = [
            Progress.greatJob,
            Progress.excellent,
            Progress.fantastic,
            Achievement.streak,
            Learning.practice,
            Cultural.heritage,
            "You're doing wonderfully! 🌟",
            "Keep up the great work! 💪",
            "Your dedication is inspiring! ✨",
            "Every step counts! 🚶‍♀️",
            "You're making Telugu proud! 🇮🇳"
        ]
        return messages.randomElement() ?? Progress.greatJob
    }
    
    // MARK: - Random Telugu Encouragement
    static func randomTeluguEncouragement() -> String {
        let messages = [
            Progress.teluguProgress,
            Progress.teluguExcellent,
            Achievement.teluguLevelUp,
            Learning.teluguPractice,
            Cultural.teluguHeritage,
            "మీరు అద్భుతంగా చేస్తున్నారు! 🌟", // "You're doing wonderfully!"
            "గొప్ప పనిని కొనసాగించండి! 💪", // "Keep up the great work!"
            "మీ అంకితభావం ప్రేరేపిస్తోంది! ✨", // "Your dedication is inspiring!"
            "ప్రతి అడుగు ముఖ్యమైనది! 🚶‍♀️", // "Every step counts!"
            "మీరు తెలుగును గర్వపెట్టుతున్నారు! 🇮🇳" // "You're making Telugu proud!"
        ]
        return messages.randomElement() ?? Progress.teluguProgress
    }
}

// MARK: - Motivational View Components
struct MotivationalMessage: View {
    let message: String
    let isTelugu: Bool
    @State private var isVisible = false
    
    var body: some View {
        Text(message)
            .font(isTelugu ? MTTypography.teluguBody() : MTTypography.encouragement())
            .foregroundColor(isTelugu ? MTColors.culturalGold : MTColors.funBlue)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [MTColors.culturalGold.opacity(0.3), MTColors.culturalOrange.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - Progress Celebration
struct ProgressCelebration: View {
    let message: String
    let progress: Double
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(MTTypography.celebration())
                .foregroundColor(MTColors.culturalGold)
                .multilineTextAlignment(.center)
            
            // Animated progress ring
            ZStack {
                Circle()
                    .stroke(MTColors.culturalGold.opacity(0.2), lineWidth: 8)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [MTColors.culturalGold, MTColors.culturalOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                Text("\(Int(progress * 100))%")
                    .font(MTTypography.progress())
                    .foregroundColor(MTColors.culturalGold)
            }
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
