#if os(iOS)
#if canImport(ActivityKit) && canImport(AppIntents)
import ActivityKit
import AppIntents
import Foundation

@available(iOS 16.2, *)
public struct TogglePomodoroLiveActivityIntent: LiveActivityIntent {
    public static var title: LocalizedStringResource { "Toggle Timer" }
    public static var openAppWhenRun: Bool { false }

    @Parameter(title: "Task ID")
    public var taskId: String

    public init() {
        self.taskId = ""
    }

    public init(taskId: UUID) {
        self.taskId = taskId.uuidString
    }

    public func perform() async throws -> some IntentResult {
        guard
            let id = UUID(uuidString: taskId),
            let activity = Activity<PomodoroActivityAttributes>.activities.first(where: {
                $0.attributes.taskId == id
            })
        else {
            return .result()
        }

        let content = activity.content.state
        let remaining = content.isRunning
            ? max(0, Int(content.endDate.timeIntervalSinceNow.rounded()))
            : max(0, content.secondsRemaining)
        let nextRunning = !content.isRunning

        let updated = PomodoroActivityAttributes.ContentState(
            state: content.state,
            endDate: Date().addingTimeInterval(TimeInterval(remaining)),
            secondsRemaining: remaining,
            phaseDuration: content.phaseDuration,
            cycleCount: content.cycleCount,
            isRunning: nextRunning
        )

        await activity.update(.init(state: updated, staleDate: nil))
        PomorLiveActivitySignal.postSessionChanged()
        return .result()
    }
}
#endif
#endif
