import Foundation

public struct TimerSessionSnapshot: Equatable, Sendable {
    public let state: TimerState
    public let secondsRemaining: Int
    public let phaseDuration: Int
    public let cycleCount: Int
    public let isRunning: Bool

    public init(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    ) {
        self.state = state
        self.secondsRemaining = secondsRemaining
        self.phaseDuration = phaseDuration
        self.cycleCount = cycleCount
        self.isRunning = isRunning
    }
}
