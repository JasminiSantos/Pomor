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

    func handleDeepLink(_ url: URL) {
        guard let link = PomorDeepLink.parse(url) else { return }
        navigate(to: link)
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

    private func navigate(to link: PomorDeepLink) {
        prepareForNavigation()

        switch link {
        case .home:
            path = NavigationPath()
        case .timer(let taskId):
            openTimer(taskId: taskId)
        }
    }

    private func prepareForNavigation() {
        if root == .splash {
            root = .home
        }
    }

    private func openTimer(taskId: UUID) {
        let getTasks = container.resolve(GetTasksUseCase.self)
        guard case .success(let tasks) = getTasks.execute(),
              let task = tasks.first(where: { $0.id == taskId }) else {
            path = NavigationPath()
            return
        }

        var nextPath = NavigationPath()
        nextPath.append(AppRoute.timer(task))
        path = nextPath
    }
}
