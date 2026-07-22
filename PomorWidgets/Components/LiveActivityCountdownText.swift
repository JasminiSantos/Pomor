import SwiftUI

struct LiveActivityCountdownText: View {
    let endDate: Date
    let secondsRemaining: Int
    let phaseDuration: Int
    let isRunning: Bool

    var body: some View {
        Group {
            if isRunning {
                Text(
                    timerInterval: phaseInterval,
                    countsDown: true,
                    showsHours: false
                )
            } else {
                Text(PomodoroLiveActivityPresentation.formattedTime(secondsRemaining))
            }
        }
        .monospacedDigit()
    }

    private var phaseInterval: ClosedRange<Date> {
        let duration = TimeInterval(max(phaseDuration, 1))
        let start = endDate.addingTimeInterval(-duration)
        if start < endDate {
            return start...endDate
        }
        return endDate...endDate.addingTimeInterval(1)
    }
}
