import Foundation
import PomorCore
@testable import Pomor

final class StubLiveActivityManager: LiveActivityManaging {
    var session: TimerSessionSnapshot?
    private var continuation: AsyncStream<TimerSessionSnapshot>.Continuation?

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

    func currentSession(for taskId: UUID) -> TimerSessionSnapshot? { session }

    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    func emit(_ session: TimerSessionSnapshot) {
        self.session = session
        continuation?.yield(session)
    }
}
