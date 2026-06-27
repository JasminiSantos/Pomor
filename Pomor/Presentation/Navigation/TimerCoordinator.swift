import PomorDI
import PomorCore
import SwiftUI

final class TimerCoordinator {
    
    private let task: PomTask
    private let resolver: DIContainer
    
    init(task: PomTask, resolver: DIContainer) {
        self.task = task
        self.resolver = resolver
    }
    
    func start() -> TimerView {
        let viewModel = resolver.resolve(TimerViewModel.self, arg: task)
        return TimerView(viewModel: viewModel)
    }
}
