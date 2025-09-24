import SwiftUI

struct StorySettingsView: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSettings: ReadingSettings
    
    init() {
        _tempSettings = State(initialValue: ReadingSettings())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Font Size Section
                Section("అక్షర పరిమాణం") {
                    Picker("అక్షర పరిమాణం", selection: $tempSettings.fontSize) {
                        ForEach(ReadingSettings.FontSize.allCases, id: \.self) { size in
                            Text(size.displayName)
                                .tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Background Theme Section
                Section("నేపథ్య రంగు") {
                    Picker("నేపథ్య రంగు", selection: $tempSettings.backgroundTheme) {
                        ForEach(ReadingSettings.BackgroundTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Reading Options Section
                Section("చదవడం ఎంపికలు") {
                    Toggle("ఆంగ్ల అనువాదం చూపించు", isOn: $tempSettings.showEnglishTranslation)
                    
                    Toggle("ఆడియో స్వయంచాలకంగా ప్లే చేయు", isOn: $tempSettings.autoPlayAudio)
                    
                    Toggle("సాంస్కృతిక గమనికలు చూపించు", isOn: $tempSettings.showCulturalNotes)
                    
                    Toggle("నిఘంటువు చూపించు", isOn: $tempSettings.showGlossary)
                }
                
                // Preview Section
                Section("మునుజూపు") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Telugu Story")
                            .font(.system(size: tempSettings.fontSize.size, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("ఇది ఒక చిన్న కథ. ఇది చాలా మంచిది.")
                            .font(.system(size: tempSettings.fontSize.size))
                            .foregroundColor(.primary)
                            .lineSpacing(8)
                        
                        if tempSettings.showEnglishTranslation {
                            Divider()
                            
                            Text("English Translation")
                                .font(.system(size: tempSettings.fontSize.size - 2, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text("This is a small story. It is very good.")
                                .font(.system(size: tempSettings.fontSize.size - 2))
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(backgroundView)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("చదవడం సెట్టింగులు")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("రద్దు చేయి") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("సేవ్ చేయి") {
                        saveSettings()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            tempSettings = session.storyService.settings
        }
    }
    
    private var backgroundView: some View {
        Group {
            switch tempSettings.backgroundTheme {
            case .light:
                Color(.systemBackground)
            case .sepia:
                Color(.systemBrown).opacity(0.1)
            case .dark:
                Color(.systemGray6)
            case .parchment:
                Color(.systemYellow).opacity(0.05)
            }
        }
    }
    
    private func saveSettings() {
        session.storyService.updateSettings(tempSettings)
        dismiss()
    }
}

#Preview {
    StorySettingsView()
        .environmentObject(AppSession())
}
