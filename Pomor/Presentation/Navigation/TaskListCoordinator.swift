import SwiftUI

final class TaskListCoordinator {
    
    private let resolver: DIContainer
    
    init(resolver: DIContainer) {
        self.resolver = resolver
    }
    
    func start(
        onTimer: @escaping (Task) -> Void,
        onAdd: @escaping () -> Void,
        onEdit: @escaping (Task) -> Void
    ) -> TaskListView {
        let viewModel = resolver.resolve(TaskListViewModel.self)
        return TaskListView(
            viewModel: viewModel,
            onTimer: onTimer,
            onAdd: onAdd,
            onEdit: onEdit
        )
    }
}
