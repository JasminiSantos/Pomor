import SwiftUI

struct PlayPauseButton: View {
    let isRunning: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(.main)
                .clipShape(Circle())
        }
    }
}
