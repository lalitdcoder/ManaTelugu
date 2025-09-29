import SwiftUI

@main
struct ManaTeluguApp: App {
    @StateObject private var session = AppSession()
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashView()
                    .onAppear {
                        setupAppearance()
                        Task {
                            await session.preloadData()
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                ElegantRootTabView()
                    .environmentObject(session)
            }
        }
    }
    
    private func setupAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            ElegantGradient()
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("మన")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.blue)
                    
                    Text("తెలుగు")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.green)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.blue)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
        }
    }
}
