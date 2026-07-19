import PomorDI
import PomorCore
import SwiftUI

final class TaskListCoordinator {

    private let resolver: DIContainer

    init(resolver: DIContainer) {
        self.resolver = resolver
    }

    func start(
        onTimer: @escaping (PomTask) -> Void,
        onAdd: @escaping () -> Void,
        onEdit: @escaping (PomTask) -> Void
    ) -> TaskListView {
        let viewModel = resolver.resolve(TaskListViewModel.self)
        viewModel.onOpenTimer = onTimer
        viewModel.onAddTask = onAdd
        viewModel.onEditTask = onEdit
        return TaskListView(viewModel: viewModel)
    }
}
