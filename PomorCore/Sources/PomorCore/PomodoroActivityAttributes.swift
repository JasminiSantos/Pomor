#if canImport(ActivityKit)
import ActivityKit
import Foundation

public struct PomodoroActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        public var state: TimerState
        public var endDate: Date
        public var secondsRemaining: Int
        public var phaseDuration: Int
        public var cycleCount: Int
        public var isRunning: Bool

        public init(
            state: TimerState,
            endDate: Date,
            secondsRemaining: Int,
            phaseDuration: Int,
            cycleCount: Int,
            isRunning: Bool
        ) {
            self.state = state
            self.endDate = endDate
            self.secondsRemaining = secondsRemaining
            self.phaseDuration = phaseDuration
            self.cycleCount = cycleCount
            self.isRunning = isRunning
        }
    }

    public var taskTitle: String
    public var taskId: UUID
    public var sessionMinutes: Int

    public init(taskTitle: String, taskId: UUID, sessionMinutes: Int) {
        self.taskTitle = taskTitle
        self.taskId = taskId
        self.sessionMinutes = sessionMinutes
    }
}
#endif
