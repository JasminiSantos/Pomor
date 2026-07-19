import Foundation
import PomorCore

final class PhoneWatchMutationHandler: WatchMutationHandling {
    private let dataSource: TaskDataSource
    private let repository: TaskRepository
    private let changeNotifier: TasksChangeNotifying

    init(
        dataSource: TaskDataSource,
        repository: TaskRepository,
        changeNotifier: TasksChangeNotifying
    ) {
        self.dataSource = dataSource
        self.repository = repository
        self.changeNotifier = changeNotifier
    }

    func handleWatchMutation(_ mutation: TaskSyncMutation) {
        switch mutation {
        case .add(let task):
            upsert(task)
        case .delete(let id):
            delete(id: id)
        }
        changeNotifier.notifyTasksDidChange()
    }

    private func upsert(_ task: PomTask) {
        guard case .success(let tasks) = dataSource.fetchTasks() else { return }
        if tasks.contains(where: { $0.id == task.id }) {
            _ = repository.updateTask(task)
        } else {
            _ = repository.addTask(task)
        }
    }

    private func delete(id: UUID) {
        guard case .success(let tasks) = dataSource.fetchTasks(),
              let task = tasks.first(where: { $0.id == id }) else { return }
        _ = repository.deleteTask(task)
    }
}
