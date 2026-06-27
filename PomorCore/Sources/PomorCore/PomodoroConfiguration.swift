import Foundation

public struct PomodoroConfiguration: Sendable {
    public var shortBreakDuration: Int
    public var longBreakDuration: Int
    public var cyclesBeforeLongBreak: Int

    public init(
        shortBreakDuration: Int = 5,
        longBreakDuration: Int = 15,
        cyclesBeforeLongBreak: Int = 4
    ) {
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.cyclesBeforeLongBreak = cyclesBeforeLongBreak
    }
}
