import Foundation
import PomorCore

enum PomodoroLiveActivityPresentation {
    static func progress(for content: PomodoroActivityAttributes.ContentState) -> Double {
        PomodoroSessionMetrics.progress(
            isRunning: content.isRunning,
            endDate: content.endDate,
            secondsRemaining: content.secondsRemaining,
            phaseDuration: content.phaseDuration
        )
    }

    static func percentComplete(for content: PomodoroActivityAttributes.ContentState) -> Int {
        PomodoroSessionMetrics.percentComplete(
            isRunning: content.isRunning,
            endDate: content.endDate,
            secondsRemaining: content.secondsRemaining,
            phaseDuration: content.phaseDuration
        )
    }

    static func stateTitle(for state: TimerState) -> String {
        PomodoroSessionMetrics.stateTitle(for: state)
    }

    static func formattedTime(_ seconds: Int) -> String {
        PomodoroSessionMetrics.formattedTime(seconds)
    }
}
