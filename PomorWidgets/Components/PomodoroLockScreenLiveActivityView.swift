import PomorCore
import SwiftUI

struct PomodoroLockScreenLiveActivityView: View {
    let attributes: PomodoroActivityAttributes
    let state: PomodoroActivityAttributes.ContentState

    var body: some View {
        let progress = PomodoroLiveActivityPresentation.progress(for: state)
        let percent = PomodoroLiveActivityPresentation.percentComplete(for: state)

        HStack(alignment: .center, spacing: 14) {
            LiveActivityEditBadge(style: .square)

            VStack(alignment: .leading, spacing: 3) {
                Text(attributes.taskTitle)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("\(percent)% complete · \(attributes.sessionMinutes) min")
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.5))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            LiveActivityProgressRing(progress: progress, size: 72, lineWidth: 5) {
                VStack(spacing: 1) {
                    LiveActivityCountdownText(
                        endDate: state.endDate,
                        secondsRemaining: state.secondsRemaining,
                        phaseDuration: state.phaseDuration,
                        isRunning: state.isRunning
                    )
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                    Text("Left")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.6)
                        .foregroundStyle(Color.white.opacity(0.45))
                }
                .frame(width: 56)
            }
        }
    }
}
