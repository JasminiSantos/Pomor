import SwiftUI
import PomorDesignSystem

struct PlayPauseButton: View {
    let isRunning: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                .foregroundStyle(.pomor(.onBrand))
                .frame(width: 80, height: 80)
                .background(.pomor(.brand))
                .clipShape(Circle())
        }
    }
}
