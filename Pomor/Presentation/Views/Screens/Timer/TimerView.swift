import SwiftUI
import PomorDesignSystem
import PomorCore

struct TimerView: View {

    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 0) {
            NavigationHeader(
                title: viewModel.task.title,
                titlePosition: .center
            )
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            VStack {
                Spacer()
                TimerCircle(
                    time: viewModel.formattedTime,
                    progress: viewModel.progress,
                    message: viewModel.stateTitle
                )
                
                Spacer()
                
                VStack {
                    
                    HStack(spacing: 24) {
                        CircleButton(icon: "arrow.counterclockwise") {
                            viewModel.reset()
                        }
                        
                        PlayPauseButton(isRunning: viewModel.isRunning) {
                            viewModel.toggle()
                        }
                    }
                    
                    Text(TimerStrings.Progress.complete(Int(viewModel.progress * 100)))
                        .pomorFont(.secondary)
                        .pomorForeground(.textTertiary)
                        .padding(.top, 8)
                }
                Spacer()
            }

            Spacer()
        }
        .background(Color.pomor(.background).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.syncFromLiveActivity()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.syncFromLiveActivity()
            }
        }
    }
}
