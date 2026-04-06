import SwiftUI

final class TaskListCoordinator: Coordinator {
    
    private let resolver: DIContainer
    private let appCoordinator: AppCoordinator
    
    init(resolver: DIContainer, appCoordinator: AppCoordinator) {
        self.resolver = resolver
        self.appCoordinator = appCoordinator
    }
    
    func start() -> AnyView {
        
        let viewModel = resolver.resolve(TaskListViewModel.self)
        
        return AnyView(
            TaskListView(
                viewModel: viewModel,
                coordinator: appCoordinator
            )
        )
    }
}
