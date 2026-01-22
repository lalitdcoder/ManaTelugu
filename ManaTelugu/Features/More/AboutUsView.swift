import SwiftUI

struct AboutUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("About Mana Telugu")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Our Mission")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Mana Telugu is designed to help children and beginners learn the beautiful Telugu language through interactive games, stories, and activities.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Features")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "character.book.closed.fill", text: "Learn 36 Telugu letters")
                        FeatureRow(icon: "gamecontroller.fill", text: "Play interactive games")
                        FeatureRow(icon: "book.fill", text: "Read engaging stories")
                        FeatureRow(icon: "chart.bar.fill", text: "Track your progress")
                    }
                    
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
            }
            .padding(24)
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
