import SwiftUI

struct Recommendation: Identifiable {
    enum RecType {
        case lesson, story, game, vocabulary
    }
    let uuid = UUID()
    let type: RecType
    let id: String?
    let title: String
    let description: String
    let iconName: String
    let color: Color
    
    // Custom identifiable conformance
    var identifiableId: UUID {
        return uuid
    }
}

struct RecommendedForYouView: View {
    let recommendations: [Recommendation]
    let onNavigate: (HomeNavigationDestination) -> Void
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recommendations) { recommendation in
                    EnhancedButton(
                        interaction: .medium,
                        isLoading: false,
                        isEnabled: true,
                        action: {
                            handleNavigation(for: recommendation)
                        },
                        content: {
                            RecommendedForYouCard(recommendation: recommendation)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
    
    private func handleNavigation(for recommendation: Recommendation) {
        print("DEBUG: Navigating to recommendation: \(recommendation.title) of type: \(recommendation.type)")
        print("DEBUG: Recommendation ID: \(recommendation.id ?? "nil")")
        
        switch recommendation.type {
        case .lesson:
            // Use the first lesson ID from the repository
            print("DEBUG: Navigating to lesson")
            onNavigate(.lesson(id: "lesson_1_1"))
        case .story:
            if let storyIDString = recommendation.id, let storyID = UUID(uuidString: storyIDString) {
                print("DEBUG: Navigating to story with ID: \(storyID)")
                onNavigate(.story(id: storyID))
            } else {
                print("DEBUG: Story ID not found or invalid, navigating to story hub")
                print("DEBUG: Story ID string was: \(recommendation.id ?? "nil")")
                // Navigate to story hub by using random UUID (will fallback to StorybookHubView)
                onNavigate(.story(id: UUID()))
            }
        case .game:
            print("DEBUG: Navigating to games")
            onNavigate(.games)
        case .vocabulary:
            print("DEBUG: Navigating to vocabulary")
            onNavigate(.vocabulary)
        }
    }
}


struct RecommendedForYouCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Enhanced icon with liquid glass effect
                ZStack {
                    Circle()
                        .fill(recommendation.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: recommendation.iconName)
                        .font(.title2)
                        .foregroundColor(recommendation.color)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recommendation.title)
                    .font(EnhancedTypography.cardTitle)
                    .fontWeight(.bold)
                    .foregroundColor(RefinedColors.charcoal)
                
                Text(recommendation.description)
                    .font(EnhancedTypography.caption)
                    .foregroundColor(RefinedColors.mediumGray)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(width: 180, height: 160, alignment: .topLeading)
    }
}
