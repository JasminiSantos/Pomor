import PomorDesignSystem
import SwiftUI

struct LiveActivityProgressRing<Content: View>: View {
    let progress: Double
    var size: CGFloat = 72
    var lineWidth: CGFloat = 5
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: lineWidth)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    PomorColor.Brand.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)

            content()
        }
    }
}
