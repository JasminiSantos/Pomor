import SwiftUI

final class TaskFormCoordinator: Coordinator {
    
    private let mode: TaskFormMode
    private let resolver: DIContainer
    
    init(mode: TaskFormMode, resolver: DIContainer) {
        self.mode = mode
        self.resolver = resolver
    }
    
    func start() -> AnyView {
        
        let viewModel = resolver.resolve(TaskFormViewModel.self, arg: mode)
        
        return AnyView(
            TaskFormView(viewModel: viewModel)
        )
    }
}
