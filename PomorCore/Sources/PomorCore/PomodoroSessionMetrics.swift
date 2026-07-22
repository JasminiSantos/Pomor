import Foundation

/// Cálculos compartilhados entre app, Live Activity e widgets.
public enum PomodoroSessionMetrics {
    public static func progress(
        isRunning: Bool,
        endDate: Date,
        secondsRemaining: Int,
        phaseDuration: Int,
        now: Date = Date()
    ) -> Double {
        let remaining: Double
        if isRunning {
            remaining = max(0, endDate.timeIntervalSince(now))
        } else {
            remaining = Double(max(secondsRemaining, 0))
        }
        let total = Double(max(phaseDuration, 1))
        return min(max(1 - (remaining / total), 0), 1)
    }

    public static func percentComplete(
        isRunning: Bool,
        endDate: Date,
        secondsRemaining: Int,
        phaseDuration: Int,
        now: Date = Date()
    ) -> Int {
        Int(
            (
                progress(
                    isRunning: isRunning,
                    endDate: endDate,
                    secondsRemaining: secondsRemaining,
                    phaseDuration: phaseDuration,
                    now: now
                ) * 100
            ).rounded()
        )
    }

    public static func stateTitle(for state: TimerState) -> String {
        switch state {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    public static func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}

public extension TimerSessionSnapshot {
    var progress: Double {
        PomodoroSessionMetrics.progress(
            isRunning: isRunning,
            endDate: Date().addingTimeInterval(TimeInterval(secondsRemaining)),
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration
        )
    }

    var percentComplete: Int {
        PomodoroSessionMetrics.percentComplete(
            isRunning: isRunning,
            endDate: Date().addingTimeInterval(TimeInterval(secondsRemaining)),
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration
        )
    }
}
