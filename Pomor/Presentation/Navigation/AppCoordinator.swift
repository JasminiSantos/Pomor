import SwiftUI
import Combine

enum AppRoute: Hashable {
    case home
    case timer(Task)
    case form(TaskFormMode)
}

final class AppCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func goToTimer(task: Task) {
        path.append(AppRoute.timer(task))
    }
    
    func goToAddTask() {
        path.append(AppRoute.form(.create))
    }
    
    func goToEditTask(task: Task) {
        path.append(AppRoute.form(.edit(task)))
    }
    
    
    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
        case .home:
            TaskListCoordinator(
                resolver: container,
                appCoordinator: self
            ).start()
        case .timer(let task):
            TimerCoordinator(
                task: task,
                resolver: container
            ).start()
            
        case .form(let mode):
            TaskFormCoordinator(
                mode: mode,
                resolver: container
            ).start()
        }
    }
}
