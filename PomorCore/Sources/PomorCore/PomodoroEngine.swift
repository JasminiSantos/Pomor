import Foundation

public enum TimerState: String, Codable, Hashable, Sendable {
    case focus
    case shortBreak
    case longBreak
}

public protocol PomodoroEngine: Sendable {
    func nextState(
        current: TimerState,
        cycleCount: Int,
        taskDuration: Int
    ) -> (state: TimerState, duration: Int, cycle: Int)
}

public final class DefaultPomodoroEngine: PomodoroEngine {

    private let config: PomodoroConfiguration

    public init(config: PomodoroConfiguration = PomodoroConfiguration()) {
        self.config = config
    }

    public func nextState(
        current: TimerState,
        cycleCount: Int,
        taskDuration: Int
    ) -> (state: TimerState, duration: Int, cycle: Int) {
        var cycle = cycleCount
        switch current {
        case .focus:
            cycle += 1
            if cycle % config.cyclesBeforeLongBreak == 0 {
                return (.longBreak, config.longBreakDuration * 60, cycle)
            } else {
                return (.shortBreak, config.shortBreakDuration * 60, cycle)
            }
        case .shortBreak, .longBreak:
            return (.focus, taskDuration * 60, cycle)
        }
    }
}
