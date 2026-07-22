import PomorCore
import PomorDesignSystem
import SwiftUI

enum PomodoroCompactLiveActivityViews {
    struct Leading: View {
        var body: some View {
            TomatoMark(size: 18)
        }
    }

    struct Trailing: View {
        let state: PomodoroActivityAttributes.ContentState

        var body: some View {
            LiveActivityCountdownText(
                endDate: state.endDate,
                secondsRemaining: state.secondsRemaining,
                phaseDuration: state.phaseDuration,
                isRunning: state.isRunning
            )
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.trailing)
        }
    }

    struct Minimal: View {
        var body: some View {
            TomatoMark(size: 16)
        }
    }

    struct ExpandedLeading: View {
        var body: some View {
            HStack(spacing: 5) {
                TomatoMark(size: 14)
                Text("Pomor")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.7))
            }
        }
    }

    struct ExpandedTrailing: View {
        let state: PomodoroActivityAttributes.ContentState

        var body: some View {
            LiveActivityCountdownText(
                endDate: state.endDate,
                secondsRemaining: state.secondsRemaining,
                phaseDuration: state.phaseDuration,
                isRunning: state.isRunning
            )
            .font(.title2.weight(.bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.trailing)
        }
    }
}
