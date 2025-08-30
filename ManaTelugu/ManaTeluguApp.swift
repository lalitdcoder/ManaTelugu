import SwiftUI

@main
struct ManaTeluguApp: App {
    @StateObject private var session = AppSession()
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(session)
        }
    }
}