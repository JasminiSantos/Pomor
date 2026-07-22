import ActivityKit
import Foundation
import PomorCore

final class LiveActivityManager: LiveActivityManaging {

    private var activity: Activity<PomodoroActivityAttributes>?
    private var trackedTaskId: UUID?

    func start(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        adopt(taskId: task.id)

        if activity != nil {
            update(
                state: state,
                secondsRemaining: secondsRemaining,
                phaseDuration: phaseDuration,
                cycleCount: cycleCount,
                isRunning: true
            )
            return
        }

        for orphan in Activity<PomodoroActivityAttributes>.activities {
            Task {
                await orphan.end(nil, dismissalPolicy: .immediate)
            }
        }

        let attributes = PomodoroActivityAttributes(
            taskTitle: task.title,
            taskId: task.id,
            sessionMinutes: task.duration
        )
        let contentState = makeContentState(
            state: state,
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration,
            cycleCount: cycleCount,
            isRunning: true
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil)
            )
            trackedTaskId = task.id
            PomorLiveActivitySignal.postSessionChanged()
        } catch {
            activity = nil
        }
    }

    func update(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    ) {
        if let trackedTaskId {
            adopt(taskId: trackedTaskId)
        }

        guard let activity else { return }

        let contentState = makeContentState(
            state: state,
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration,
            cycleCount: cycleCount,
            isRunning: isRunning
        )

        Task {
            await activity.update(.init(state: contentState, staleDate: nil))
            PomorLiveActivitySignal.postSessionChanged()
        }
    }

    func end() {
        if let trackedTaskId {
            adopt(taskId: trackedTaskId)
        }

        let current = activity
        activity = nil
        trackedTaskId = nil

        guard let current else {
            for existing in Activity<PomodoroActivityAttributes>.activities {
                Task {
                    await existing.end(nil, dismissalPolicy: .immediate)
                }
            }
            PomorLiveActivitySignal.postSessionChanged()
            return
        }

        Task {
            await current.end(nil, dismissalPolicy: .immediate)
            PomorLiveActivitySignal.postSessionChanged()
        }
    }

    func currentSession(for taskId: UUID) -> TimerSessionSnapshot? {
        adopt(taskId: taskId)
        guard let activity, activity.attributes.taskId == taskId else { return nil }
        return snapshot(from: activity.content.state)
    }

    func sessionUpdates(for taskId: UUID) -> AsyncStream<TimerSessionSnapshot> {
        AsyncStream { continuation in
            let yieldCurrent: () -> Void = { [weak self] in
                guard let self, let session = self.currentSession(for: taskId) else { return }
                continuation.yield(session)
            }

            let observerID = PomorLiveActivitySignal.addObserver(yieldCurrent)

            let task = Task { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }

                guard let activity = await self.resolveActivity(for: taskId) else {
                    continuation.finish()
                    return
                }

                for await content in activity.contentUpdates {
                    continuation.yield(self.snapshot(from: content.state))
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
                PomorLiveActivitySignal.removeObserver(observerID)
            }
        }
    }

    private func resolveActivity(
        for taskId: UUID
    ) async -> Activity<PomodoroActivityAttributes>? {
        if let existing = Activity<PomodoroActivityAttributes>.activities.first(where: {
            $0.attributes.taskId == taskId
        }) {
            return existing
        }

        for await activity in Activity<PomodoroActivityAttributes>.activityUpdates {
            if activity.attributes.taskId == taskId {
                return activity
            }
        }
        return nil
    }

    private func adopt(taskId: UUID) {
        trackedTaskId = taskId
        if activity?.attributes.taskId == taskId { return }
        activity = Activity<PomodoroActivityAttributes>.activities.first {
            $0.attributes.taskId == taskId
        }
    }

    private func snapshot(
        from content: PomodoroActivityAttributes.ContentState
    ) -> TimerSessionSnapshot {
        let remaining: Int
        if content.isRunning {
            remaining = max(0, Int(content.endDate.timeIntervalSinceNow.rounded()))
        } else {
            remaining = max(0, content.secondsRemaining)
        }

        return TimerSessionSnapshot(
            state: content.state,
            secondsRemaining: remaining,
            phaseDuration: max(content.phaseDuration, 1),
            cycleCount: content.cycleCount,
            isRunning: content.isRunning
        )
    }

    private func makeContentState(
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int,
        isRunning: Bool
    ) -> PomodoroActivityAttributes.ContentState {
        let remaining = max(secondsRemaining, 0)
        return PomodoroActivityAttributes.ContentState(
            state: state,
            endDate: Date().addingTimeInterval(TimeInterval(remaining)),
            secondsRemaining: remaining,
            phaseDuration: max(phaseDuration, 1),
            cycleCount: cycleCount,
            isRunning: isRunning
        )
    }
}
