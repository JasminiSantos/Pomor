import PomorDesignSystem
import SwiftUI

struct SplashView: View {
    var duration: Duration = .seconds(2)
    var exitDuration: Duration = .seconds(0.35)
    let onFinished: () -> Void

    @State private var isVisible = false

    var body: some View {
        ZStack {
            Color.pomor(.background)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                TomatoMark(size: 96, isFloating: true)

                Text(TaskListStrings.Brand.name.uppercased())
                    .font(PomorFont.nunito(size: 28, weight: .extraBold))
                    .tracking(4)
                    .pomorForeground(.brand)
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.92)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                isVisible = true
            }
        }
        .task {
            try? await Task.sleep(for: duration)
            withAnimation(.easeInOut(duration: 0.35)) {
                isVisible = false
            }
            try? await Task.sleep(for: exitDuration)
            onFinished()
        }
    }
}
