import SwiftUI
import PomorCore

struct WatchTimerView: View {

    @StateObject private var viewModel: WatchTimerViewModel

    init(viewModel: WatchTimerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 8)

            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: viewModel.progress)

            VStack(spacing: 4) {
                Text(viewModel.stateTitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)

                Text(viewModel.formattedTime)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))

                HStack(spacing: 20) {
                    Button { viewModel.reset() } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 13))
                    }
                    .buttonStyle(.plain)

                    Button { viewModel.toggle() } label: {
                        Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(8)
        .navigationTitle(viewModel.task.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
