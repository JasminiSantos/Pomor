import PomorCore
import SwiftUI

struct PomodoroExpandedLiveActivityView: View {
    let attributes: PomodoroActivityAttributes
    let state: PomodoroActivityAttributes.ContentState

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(attributes.taskTitle)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(PomodoroLiveActivityPresentation.stateTitle(for: state.state))
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.55))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            LiveActivityPlayPauseButton(
                taskId: attributes.taskId,
                isRunning: state.isRunning
            )
        }
    }
}
