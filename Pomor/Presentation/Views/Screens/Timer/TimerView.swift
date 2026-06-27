import SwiftUI
import PomorCore

struct TimerView: View {
    
    @StateObject var viewModel: TimerViewModel
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            VStack {
                
                TimerCircle(
                    time: viewModel.formattedTime,
                    progress: viewModel.progress,
                    message: viewModel.stateTitle
                )
                
                HStack(spacing: 24) {
                    CircleButton(icon: "arrow.counterclockwise") {
                        viewModel.reset()
                    }
                    
                    PlayPauseButton(isRunning: viewModel.isRunning) {
                        viewModel.toggle()
                    }
                }
                
                Text(TimerStrings.Progress.complete(Int(viewModel.progress * 100)))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .navigationTitle(viewModel.task.title)
        }
    }
}
