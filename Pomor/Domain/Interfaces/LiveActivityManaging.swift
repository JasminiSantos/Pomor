import Foundation
import PomorCore

protocol LiveActivityManaging {

    var activeTaskId: UUID? { get }

    func start(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    )
    func update(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    )
    func end()
    func currentSession(for taskId: UUID) -> TimerSessionSnapshot?
    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot>
}
