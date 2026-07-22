import Foundation
import PomorCore
@testable import Pomor

final class StubLiveActivityManager: LiveActivityManaging {
    struct StartCall: Equatable {
        let taskId: UUID
        let state: TimerState
        let secondsRemaining: Int
        let phaseDuration: Int
        let cycleCount: Int
    }

    struct UpdateCall: Equatable {
        let state: TimerState
        let secondsRemaining: Int
        let phaseDuration: Int
        let cycleCount: Int
        let isRunning: Bool
    }

    var session: TimerSessionSnapshot?
    var sessionTaskId: UUID?
    var activeTaskId: UUID?

    private(set) var startCalls: [StartCall] = []
    private(set) var updateCalls: [UpdateCall] = []
    private(set) var endCallCount = 0

    private var continuation: AsyncStream<TimerSessionSnapshot>.Continuation?
    private var pendingSessions: [TimerSessionSnapshot] = []

    func start(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    ) {
        startCalls.append(
            StartCall(
                taskId: task.id,
                state: state,
                secondsRemaining: secondsRemaining,
                phaseDuration: phaseDuration,
                cycleCount: cycleCount
            )
        )
        activeTaskId = task.id
        sessionTaskId = task.id
        session = TimerSessionSnapshot(
            state: state,
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration,
            cycleCount: cycleCount,
            isRunning: true
        )
    }

    func update(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    ) {
        updateCalls.append(
            UpdateCall(
                state: state,
                secondsRemaining: secondsRemaining,
                phaseDuration: phaseDuration,
                cycleCount: cycleCount,
                isRunning: isRunning
            )
        )
        session = TimerSessionSnapshot(
            state: state,
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration,
            cycleCount: cycleCount,
            isRunning: isRunning
        )
    }

    func end() {
        endCallCount += 1
        activeTaskId = nil
        sessionTaskId = nil
        session = nil
    }

    func currentSession(for taskId: UUID) -> TimerSessionSnapshot? {
        if let sessionTaskId, sessionTaskId != taskId {
            return nil
        }
        return session
    }

    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot> {
        AsyncStream { continuation in
            self.continuation = continuation
            for pending in self.pendingSessions {
                continuation.yield(pending)
            }
            self.pendingSessions.removeAll()
            continuation.onTermination = { [weak self] _ in
                self?.continuation = nil
            }
        }
    }

    func emit(_ session: TimerSessionSnapshot) {
        self.session = session
        if let continuation {
            continuation.yield(session)
        } else {
            pendingSessions.append(session)
        }
    }
}
