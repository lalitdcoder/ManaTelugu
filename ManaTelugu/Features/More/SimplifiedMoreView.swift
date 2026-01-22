import SwiftUI

struct SimplifiedMoreView: View {
    @EnvironmentObject var session: AppSession
    @State private var showingParentMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.92, green: 0.95, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Header Section
                        headerSection
                            .padding(.top, 20)
                        
                        // Main Options
                        mainOptions
                        
                        // Parent Mode Access
                        parentModeSection
                        
                        // App Info
                        appInfoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingParentMode) {
                SimplifiedParentModeView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("More Options")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Get help and learn more about the app")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // App icon or logo
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Text("మ")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var mainOptions: some View {
        VStack(spacing: 16) {
            NavigationLink {
                ContactUsView()
            } label: {
                MoreOptionCard(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    description: "Get help or send us feedback",
                    color: .blue,
                    showChevron: true
                )
            }
            
            NavigationLink {
                AboutUsView()
            } label: {
                MoreOptionCard(
                    icon: "info.circle.fill",
                    title: "About Us",
                    description: "Learn about Mana Telugu and our mission",
                    color: .green,
                    showChevron: true
                )
            }
        }
    }
    
    private var parentModeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("For Parents")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Button(action: {
                showingParentMode = true
            }) {
                MoreOptionCard(
                    icon: "person.2.fill",
                    title: "Parent Mode",
                    description: "Access parental controls and progress reports",
                    color: .purple,
                    showChevron: false
                )
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            // App version and info
            VStack(spacing: 8) {
                Text("Mana Telugu")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Learn Telugu letters, words, and stories through interactive games and activities.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            // Quick stats
            HStack(spacing: 20) {
                StatItem(title: "36", subtitle: "Telugu Letters")
                StatItem(title: "12+", subtitle: "Fun Games")
                StatItem(title: "50+", subtitle: "Stories")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct MoreOptionCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let showChevron: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct StatItem: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
