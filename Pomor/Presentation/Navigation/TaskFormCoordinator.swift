import PomorDI
import SwiftUI

final class TaskFormCoordinator {

    private let mode: TaskFormMode
    private let resolver: DIContainer

    init(mode: TaskFormMode, resolver: DIContainer) {
        self.mode = mode
        self.resolver = resolver
    }

    func start() -> TaskFormView {
        let viewModel = resolver.resolve(TaskFormViewModel.self, arg: mode)
        return TaskFormView(viewModel: viewModel)
    }
}
