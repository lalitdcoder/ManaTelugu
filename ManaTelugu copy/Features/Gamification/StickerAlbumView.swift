import SwiftUI

struct StickerAlbumView: View {
    @EnvironmentObject var session: AppSession
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        EnhancedScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(session.stickerService.allStickers) { sticker in
                    StickerView(
                        sticker: sticker,
                        isUnlocked: session.gamificationService.gamificationState.collectedStickerIDs.contains(sticker.id)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Sticker Album")
    }
}
