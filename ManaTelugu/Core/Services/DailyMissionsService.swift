import Foundation
import Combine

class DailyMissionsService: ObservableObject {
    @Published var dailyMissions: [DailyMission] = []
    
    private var allPossibleMissions: [DailyMission] = [
        DailyMission(id: "complete_lesson_1", title: "Complete a Lesson", description: "Finish one full lesson.", iconName: "book.closed.fill", goal: 1, progress: 0, xpReward: 50),
        DailyMission(id: "play_game_3", title: "Play 3 Games", description: "Play any three games in the Game Zone.", iconName: "gamecontroller.fill", goal: 3, progress: 0, xpReward: 75),
        DailyMission(id: "learn_words_5", title: "Learn 5 New Words", description: "Learn five new words in Vocabulary Quest.", iconName: "text.book.closed.fill", goal: 5, progress: 0, xpReward: 40),
        DailyMission(id: "read_story_1", title: "Read a Story", description: "Read a story from the Storybook.", iconName: "book.fill", goal: 1, progress: 0, xpReward: 60)
    ]
    
    init() {
        loadMissions()
    }
    
    func loadMissions() {
        // In a real app, you would load the user's progress for today's missions and check the date.
        // For now, we'll just generate new ones if the list is empty.
        if dailyMissions.isEmpty {
            generateNewMissions()
        }
    }
    
    func generateNewMissions() {
        // Get 3 random missions from the list of all possible missions.
        dailyMissions = Array(allPossibleMissions.shuffled().prefix(3))
    }
    
    // In the future, we will add functions here to update mission progress, like:
    // func completedLesson(), func playedGame(), func learnedWord(), etc.
}
