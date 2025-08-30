import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        TabView {
            homeTab
            practiceTab
            vocabularyTab
            lessonsTab
            progressTab
            settingsTab
        }
        .tint(MTColors.primary)
    }
}

// MARK: - Tabs split to help the type-checker
private extension RootTabView {
    var homeTab: some View {
        HomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
    }
    
    var lessonsTab: some View {
        LessonsHubView()
            .tabItem {
                Image(systemName: "graduationcap")
                Text("Lessons")
            }
    }
    
    // Move Practice earlier so it's always visible in the tab bar
    var practiceTab: some View {
        PracticeView()
            .tabItem {
                Image(systemName: "book")
                Text("Practice")
            }
    }
    
    var alphabetTab: some View {
        NavigationStack {
            AlphabetGridView()
        }
            .tabItem {
                Image(systemName: "textformat.abc.dottedunderline")
                Text("Alphabet")
            }
    }
    
    var vocabularyTab: some View {
        VocabularyThemesView()
            .tabItem {
                Image(systemName: "books.vertical")
                Text("Vocabulary")
            }
    }
    
    var progressTab: some View {
        ProgressDashboardView()
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Progress")
            }
    }
    
    var settingsTab: some View {
        SettingsView()
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
    }
}