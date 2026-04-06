import SwiftUI

final class TimerCoordinator: Coordinator {
    
    private let task: Task
    private let resolver: DIContainer
    
    init(task: Task, resolver: DIContainer) {
        self.task = task
        self.resolver = resolver
    }
    
    func start() -> AnyView {
        
        let viewModel = resolver.resolve(TimerViewModel.self, arg: task)
        
        return AnyView(
            TimerView(viewModel: viewModel)
        )
    }
}
