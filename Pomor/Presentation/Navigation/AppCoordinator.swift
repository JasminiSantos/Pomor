import PomorDI
import PomorCore
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case splash
    case home
    case timer(PomTask)
    case form(TaskFormMode)
}

final class AppCoordinator: ObservableObject {

    @Published private(set) var root: AppRoute = .splash
    @Published var path = NavigationPath()

    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func finishSplash() {
        root = .home
    }

    func goToTimer(task: PomTask) {
        path.append(AppRoute.timer(task))
    }

    func goToAddTask() {
        path.append(AppRoute.form(.create))
    }

    func goToEditTask(task: PomTask) {
        path.append(AppRoute.form(.edit(task)))
    }

    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
        case .splash:
            SplashView(
                onFinished: { [weak self] in
                    self?.finishSplash()
                }
            )
        case .home:
            TaskListCoordinator(resolver: container).start(
                onTimer: { [weak self] task in self?.goToTimer(task: task) },
                onAdd: { [weak self] in self?.goToAddTask() },
                onEdit: { [weak self] task in self?.goToEditTask(task: task) }
            )
        case .timer(let task):
            TimerCoordinator(task: task, resolver: container).start()
        case .form(let mode):
            TaskFormCoordinator(mode: mode, resolver: container).start()
        }
    }
}
