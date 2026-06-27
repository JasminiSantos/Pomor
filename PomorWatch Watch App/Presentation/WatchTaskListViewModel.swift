import Foundation
import Combine
import PomorCore

@MainActor
final class WatchTaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [PomTask] = []

    private let getTasksUseCase: GetWatchTasksUseCase
    private let addTaskUseCase: AddWatchTaskUseCase
    private let deleteTaskUseCase: DeleteWatchTaskUseCase
    private let syncTasksUseCase: SyncWatchTasksUseCase
    private var cancellable: AnyCancellable?

    init(
        getTasksUseCase: GetWatchTasksUseCase,
        addTaskUseCase: AddWatchTaskUseCase,
        deleteTaskUseCase: DeleteWatchTaskUseCase,
        syncTasksUseCase: SyncWatchTasksUseCase
    ) {
        self.getTasksUseCase = getTasksUseCase
        self.addTaskUseCase = addTaskUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.syncTasksUseCase = syncTasksUseCase
        loadTasks()
        subscribeToSync()
    }

    func add(title: String, duration: Int) {
        _ = addTaskUseCase.execute(title: title, duration: duration)
        loadTasks()
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { _ = deleteTaskUseCase.execute(tasks[$0]) }
        loadTasks()
    }

    private func loadTasks() {
        if case .success(let loaded) = getTasksUseCase.execute() {
            tasks = loaded
        }
    }

    private func subscribeToSync() {
        cancellable = WatchConnectivityManager.shared.tasksReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] syncedTasks in
                _ = self?.syncTasksUseCase.execute(syncedTasks)
                self?.loadTasks()
            }
    }
}
