import ActivityKit
import PomorCore
import SwiftUI
import WidgetKit

struct PomodoroLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroActivityAttributes.self) { context in
            PomodoroLockScreenLiveActivityView(
                attributes: context.attributes,
                state: context.state
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .activityBackgroundTint(Color.black.opacity(0.88))
            .widgetURL(PomorDeepLink.timer(taskId: context.attributes.taskId).url)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    PomodoroCompactLiveActivityViews.ExpandedLeading()
                }

                DynamicIslandExpandedRegion(.trailing) {
                    PomodoroCompactLiveActivityViews.ExpandedTrailing(state: context.state)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    PomodoroExpandedLiveActivityView(
                        attributes: context.attributes,
                        state: context.state
                    )
                }
            } compactLeading: {
                PomodoroCompactLiveActivityViews.Leading()
            } compactTrailing: {
                PomodoroCompactLiveActivityViews.Trailing(state: context.state)
            } minimal: {
                PomodoroCompactLiveActivityViews.Minimal()
            }
            .widgetURL(PomorDeepLink.timer(taskId: context.attributes.taskId).url)
            .contentMargins(.horizontal, 20, for: .expanded)
            .contentMargins(.trailing, 8, for: .compactTrailing)
        }
    }
}
