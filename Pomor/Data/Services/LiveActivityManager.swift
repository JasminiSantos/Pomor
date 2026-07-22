import ActivityKit
import Foundation
import PomorCore

final class LiveActivityManager: LiveActivityManaging {

    private var activity: Activity<PomodoroActivityAttributes>?
    private var trackedTaskId: UUID?
    private var startTask: Task<Void, Never>?

    var activeTaskId: UUID? {
        Activity<PomodoroActivityAttributes>.activities.first?.attributes.taskId
            ?? trackedTaskId
    }

    func start(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        startTask?.cancel()
        startTask = Task { [weak self] in
            guard let self else { return }
            await self.startExclusively(
                task: task,
                state: state,
                secondsRemaining: secondsRemaining,
                phaseDuration: phaseDuration,
                cycleCount: cycleCount
            )
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
        startTask?.cancel()
        startTask = nil

        let toEnd = Activity<PomodoroActivityAttributes>.activities
        activity = nil
        trackedTaskId = nil

        Task {
            for existing in toEnd {
                await existing.end(nil, dismissalPolicy: .immediate)
            }
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

    private func startExclusively(
        task: PomTask,
        state: TimerState,
        secondsRemaining: Int,
        phaseDuration: Int,
        cycleCount: Int
    ) async {
        await endActivities(except: task.id)
        guard !Task.isCancelled else { return }

        let content = makeContentState(
            state: state,
            secondsRemaining: secondsRemaining,
            phaseDuration: phaseDuration,
            cycleCount: cycleCount,
            isRunning: true
        )

        if await resumeExisting(taskId: task.id, content: content) { return }
        requestNew(task: task, content: content)
    }

    private func endActivities(except taskId: UUID) async {
        let others = Activity<PomodoroActivityAttributes>.activities.filter {
            $0.attributes.taskId != taskId
        }
        for other in others {
            await other.end(nil, dismissalPolicy: .immediate)
        }
    }

    private func resumeExisting(
        taskId: UUID,
        content: PomodoroActivityAttributes.ContentState
    ) async -> Bool {
        guard let existing = Activity<PomodoroActivityAttributes>.activities.first(where: {
            $0.attributes.taskId == taskId
        }) else {
            return false
        }

        activity = existing
        trackedTaskId = taskId
        await existing.update(.init(state: content, staleDate: nil))
        PomorLiveActivitySignal.postSessionChanged()
        return true
    }

    private func requestNew(
        task: PomTask,
        content: PomodoroActivityAttributes.ContentState
    ) {
        let attributes = PomodoroActivityAttributes(
            taskTitle: task.title,
            taskId: task.id,
            sessionMinutes: task.duration
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: content, staleDate: nil)
            )
            trackedTaskId = task.id
            PomorLiveActivitySignal.postSessionChanged()
        } catch {
            activity = nil
            trackedTaskId = nil
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
