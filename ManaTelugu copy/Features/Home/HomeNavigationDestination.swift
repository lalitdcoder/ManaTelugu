import Foundation

enum HomeNavigationDestination: Hashable {
    case alphabet
    case vocabulary
    case games
    case story(id: UUID)
    case lesson(id: String)
    case practice
    case progress
    case settings
    case help
    case parentDashboard
    case badgeGallery
    case xpHistory
    case stickerAlbum
    case dailyMissions
    case lettersQuiz(scope: LettersQuizScope)
    case vocabularyCards
    case vocabularyThemes
    case storyReader(storyId: UUID)
    case storySettings
    case storyFavorites
    case storyGlossary
    case culturalNotes
    case gameSentenceBuilder
    case gameListeningChallenge
    case gameTraceLetters
    case gameCardMatch
    case gameSoundMatch
    case learningInsights
    case parentalGate
    case pinReset
}

