import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Enhanced background gradient for Liquid Glass effect
                Color.clear
                    .liquidGlassBackground()
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
                        dismiss()
                    }
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
                    .buttonStyle(PlainButtonStyle())
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
                    colors: [MTColors.accent.opacity(0.3), MTColors.accent.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: story.category.icon)
                        .font(.title2)
                        .foregroundColor(MTColors.accent)
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
                                .fill(MTColors.accent.opacity(0.2))
                        )
                        .foregroundColor(MTColors.accent)
                    
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
