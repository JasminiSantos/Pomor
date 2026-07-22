import AppIntents
import PomorCore
import PomorDesignSystem
import SwiftUI

struct LiveActivityPlayPauseButton: View {
    let taskId: UUID
    let isRunning: Bool

    var body: some View {
        Button(intent: TogglePomodoroLiveActivityIntent(taskId: taskId)) {
            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(PomorColor.Brand.primary, in: Circle())
        }
        .buttonStyle(.plain)
    }
}
