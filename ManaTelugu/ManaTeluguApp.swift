import SwiftUI

@main
struct ManaTeluguApp: App {
    @StateObject private var session = AppSession()
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashScreenView()
                    .onAppear {
                        Task {
                            await session.preloadData()
                            // Add a small delay for a smoother transition
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                RootTabView()
                    .environmentObject(session)
            }
        }
    }
}