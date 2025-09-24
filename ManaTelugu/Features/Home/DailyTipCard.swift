import SwiftUI

struct DailyTip: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let iconName: String
    let color: Color
}

struct DailyTipCard: View {
    let tip: DailyTip
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: tip.iconName)
                .font(.title2)
                .foregroundColor(tip.color)
                .frame(width: 44, height: 44)
                .background(tip.color.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(tip.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}
