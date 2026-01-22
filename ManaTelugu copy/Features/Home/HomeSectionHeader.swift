import SwiftUI

struct HomeSectionHeader: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) section")
    }
}
