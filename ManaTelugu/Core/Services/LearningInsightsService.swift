import Foundation

struct LearningInsight {
    let title: String
    let description: String
    let icon: String
}

class LearningInsightsService: ObservableObject {
    
    private let lessonsRepository: LessonsRepository
    
    init(lessonsRepository: LessonsRepository) {
        self.lessonsRepository = lessonsRepository
    }
    
    func generateInsights(from progress: [LessonProgress]) -> [LearningInsight] {
        var insights: [LearningInsight] = []
        
        // --- Strength: Best Question Type ---
        let (bestType, bestAccuracy) = findBestPerformingQuestionType(in: progress)
        if let bestType = bestType {
            let insight = LearningInsight(
                title: "Strength: \(bestType.displayName)",
                description: "Excelling with an average accuracy of \(Int(bestAccuracy * 100))%.",
                icon: "star.fill"
            )
            insights.append(insight)
        }
        
        // --- Weakness: Worst Question Type ---
        let (worstType, worstAccuracy) = findWorstPerformingQuestionType(in: progress)
        if let worstType = worstType {
            let insight = LearningInsight(
                title: "Area to Improve: \(worstType.displayName)",
                description: "Having some trouble here, with an average accuracy of \(Int(worstAccuracy * 100))%.",
                icon: "exclamationmark.triangle.fill"
            )
            insights.append(insight)
        }
        
        return insights
    }
    
    private func calculateAccuracy(for questionType: QuestionType, in progress: [LessonProgress]) -> (correct: Int, total: Int) {
        var correct = 0
        var total = 0
        
        for p in progress {
            for response in p.activityResponses {
                // We need to find the original question to check its type
                if let question = findQuestion(withId: response.questionId, in: p.lessonId) {
                    if question.type == questionType {
                        total += 1
                        if response.isCorrect {
                            correct += 1
                        }
                    }
                }
            }
        }
        
        return (correct, total)
    }
    
    private func findBestPerformingQuestionType(in progress: [LessonProgress]) -> (QuestionType?, Double) {
        var accuracies: [QuestionType: Double] = [:]
        
        for questionType in QuestionType.allCases {
            let (correct, total) = calculateAccuracy(for: questionType, in: progress)
            if total > 0 {
                accuracies[questionType] = Double(correct) / Double(total)
            }
        }
        
        return accuracies.max(by: { $0.value < $1.value }) ?? (nil, 0)
    }
    
    private func findWorstPerformingQuestionType(in progress: [LessonProgress]) -> (QuestionType?, Double) {
        var accuracies: [QuestionType: Double] = [:]
        
        for questionType in QuestionType.allCases {
            let (correct, total) = calculateAccuracy(for: questionType, in: progress)
            if total > 0 { // Only consider types that have been attempted
                accuracies[questionType] = Double(correct) / Double(total)
            }
        }
        
        return accuracies.min(by: { $0.value < $1.value }) ?? (nil, 0)
    }
    
    
    // Helper to find a question. In a real app, this would be more robust.
    private func findQuestion(withId questionId: String, in lessonId: String) -> ActivityQuestion? {
        if let lesson = lessonsRepository.findLesson(byId: lessonId) {
            for activity in lesson.activities {
                if let question = activity.questions.first(where: { $0.id == questionId }) {
                    return question
                }
            }
        }
        return nil
    }
}

extension QuestionType {
    var displayName: String {
        switch self {
        case .characterRecognition: return "Recognizing Letters"
        case .wordTranslation: return "Translating Words"
        case .sentenceTranslation: return "Translating Sentences"
        case .tracing: return "Tracing Letters"
        case .audioIdentification: return "Listening Skills"
        default: return self.rawValue.capitalized
        }
    }
}
