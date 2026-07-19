import Combine
import PomorCore
import PomorDI
import SwiftUI

final class WatchCoordinator: ObservableObject {
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    @ViewBuilder
    func build(_ route: WatchRoute) -> some View {
        switch route {
        case .home:
            WatchTaskListView(
                viewModel: container.resolve(WatchTaskListViewModel.self)
            )
        case .timer(let task):
            WatchTimerView(
                viewModel: container.resolve(WatchTimerViewModel.self, arg: task)
            )
        case .addTask:
            let listViewModel = container.resolve(WatchTaskListViewModel.self)
            WatchAddTaskView { title, duration in
                listViewModel.add(title: title, duration: duration)
            }
        }
    }
}
