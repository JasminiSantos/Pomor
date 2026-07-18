import SwiftUI
import PomorDesignSystem

struct TimerCircle: View {
    let time: String
    let progress: Double
    let message: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.pomor(.muted))
                .frame(width: 260, height: 260)

            Circle()
                .stroke(PomorColor.Border.muted, lineWidth: 12)
                .frame(width: 260, height: 260)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pomor(.brand),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 260, height: 260)
                .animation(.linear, value: progress)

            VStack(spacing: 8) {
                Text(time)
                    .pomorFont(.timer)
                    .pomorForeground(.textPrimary)

                Text(message)
                    .pomorFont(.secondary)
                    .pomorForeground(.textTertiary)
            }
        }
    }
}
