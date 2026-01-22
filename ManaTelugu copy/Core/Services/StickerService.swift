import Foundation

class StickerService: ObservableObject {
    @Published var allStickers: [Sticker] = []
    
    init() {
        loadStickers()
    }
    
    private func loadStickers() {
        // In a real app, this might come from a JSON file or an API.
        // For now, we'll use a static list.
        allStickers = [
            // Animals
            Sticker(id: "sticker_animal_peacock", name: "Peacock", imageName: "peacock"),
            Sticker(id: "sticker_animal_tiger", name: "Tiger", imageName: "tiger"),
            Sticker(id: "sticker_animal_elephant", name: "Elephant", imageName: "elephant"),
            
            // Gods
            Sticker(id: "sticker_god_ganesha", name: "Ganesha", imageName: "ganesha"),
            Sticker(id: "sticker_god_krishna", name: "Krishna", imageName: "krishna"),
            
            // Monuments
            Sticker(id: "sticker_monument_charminar", name: "Charminar", imageName: "charminar"),
            Sticker(id: "sticker_monument_temple", name: "Temple", imageName: "temple")
        ]
    }
}
