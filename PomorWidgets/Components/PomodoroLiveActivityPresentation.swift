import Foundation
import PomorCore

enum PomodoroLiveActivityPresentation {
    static func progress(for content: PomodoroActivityAttributes.ContentState) -> Double {
        let remaining: Double
        if content.isRunning {
            remaining = max(0, content.endDate.timeIntervalSinceNow)
        } else {
            remaining = Double(max(content.secondsRemaining, 0))
        }
        let total = Double(max(content.phaseDuration, 1))
        return min(max(1 - (remaining/total), 0), 1)
    }

    static func percentComplete(for content: PomodoroActivityAttributes.ContentState) -> Int {
        Int((progress(for: content) * 100).rounded())
    }

    static func stateTitle(for state: TimerState) -> String {
        switch state {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    static func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds/60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}
