import PomorCore
import Foundation

final class TaskRepositoryImpl: TaskRepository {

    private let dataSource: TaskDataSource
    private let watchSyncService: WatchSyncService

    init(
        dataSource: TaskDataSource,
        watchSyncService: WatchSyncService
    ) {
        self.dataSource = dataSource
        self.watchSyncService = watchSyncService
    }

    func getTasks() -> Result<[PomTask], Error> {
        let result = dataSource.fetchTasks()
        if case .success(let tasks) = result { watchSyncService.syncTasks(tasks) }
        return result
    }

    func addTask(_ task: PomTask) -> Result<Void, Error> {
        let result = dataSource.saveTask(task)
        if case .success = result { syncToWatch() }
        return result
    }

    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        let result = dataSource.deleteTask(task)
        if case .success = result { syncToWatch() }
        return result
    }

    func updateTask(_ task: PomTask) -> Result<Void, Error> {
        let result = dataSource.updateTask(task)
        if case .success = result { syncToWatch() }
        return result
    }

    private func syncToWatch() {
        if case .success(let tasks) = dataSource.fetchTasks() {
            watchSyncService.syncTasks(tasks)
        }
    }
}
