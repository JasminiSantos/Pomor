import Foundation
import PomorCore

protocol LiveActivityManaging {
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
    /// Emite quando a Live Activity muda (ex.: pause/play pelo Dynamic Island).
    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot>
}
