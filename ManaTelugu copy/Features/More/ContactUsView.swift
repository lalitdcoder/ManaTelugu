import SwiftUI

struct ContactUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "envelope.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Contact Us")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("We'd love to hear from you!")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 16) {
                    Button {
                        if let url = URL(string: "mailto:manateluguhelp@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        ContactOption(
                            icon: "envelope.fill",
                            title: "Email Support",
                            value: "manateluguhelp@gmail.com",
                            color: .blue
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        if let url = URL(string: "https://manateluguwebsite.pages.dev") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        ContactOption(
                            icon: "globe",
                            title: "Website",
                            value: "manateluguwebsite.pages.dev",
                            color: .green
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 20)
            }
            .padding(24)
        }
        .navigationTitle("Contact Us")
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

struct ContactOption: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}
