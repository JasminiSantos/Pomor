import Foundation
import PomorCore
@testable import Pomor

final class NoOpLiveActivityManager: LiveActivityManaging {
    var activeTaskId: UUID? { nil }

    func start(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    ) {}

    func update(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    ) {}

    func end() {}

    func currentSession(for taskId: UUID) -> TimerSessionSnapshot? { nil }

    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot> {
        AsyncStream { $0.finish() }
    }
}
