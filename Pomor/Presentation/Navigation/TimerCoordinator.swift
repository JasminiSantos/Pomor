import SwiftUI

final class TimerCoordinator {
    
    private let task: Task
    private let resolver: DIContainer
    
    init(task: Task, resolver: DIContainer) {
        self.task = task
        self.resolver = resolver
    }
    
    func start() -> TimerView {
        let viewModel = resolver.resolve(TimerViewModel.self, arg: task)
        return TimerView(viewModel: viewModel)
    }
}
