import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Stronger gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3),
                    Color(red: 0.46, green: 0.29, blue: 0.64).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Group {
            if session.storyService.bookmarkedStories.isEmpty {
                emptyStateView
            } else {
                storiesList
            }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    HapticsService.shared.navigationTap()
                    dismiss()
                }
            }
        }
    }
    
    private var storiesList: some View {
        EnhancedScrollView(bottomPadding: 140) {
            LazyVStack(spacing: 16) {
                ForEach(session.storyService.bookmarkedStories) { story in
                    NavigationLink(destination: StoryReaderView(story: story).environmentObject(session)) {
                        FavoriteStoryRow(story: story)
                    }
.buttonStyle(HapticPlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .padding(.bottom, 120) // Add bottom padding to prevent tab bar overlap
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Favorite Stories")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("Your favorite stories will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Browse Stories") {
                HapticsService.shared.navigationTap()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoriteStoryRow: View {
    let story: TeluguStory
    
    var body: some View {
        HStack(spacing: 16) {
            // Story Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [ModernDesignSystem.Colors.accent.opacity(0.3), ModernDesignSystem.Colors.accent.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: story.category.icon)
                        .font(.title2)
                        .foregroundColor(ModernDesignSystem.Colors.accent)
                )
            
            // Story Details
            VStack(alignment: .leading, spacing: 4) {
                Text(story.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(story.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(story.category.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ModernDesignSystem.Colors.accent.opacity(0.2))
                        )
                        .foregroundColor(ModernDesignSystem.Colors.accent)
                    
                    Spacer()
                    
                    Text("\(story.estimatedReadingTime) నిమిషాలు")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppSession())
}
