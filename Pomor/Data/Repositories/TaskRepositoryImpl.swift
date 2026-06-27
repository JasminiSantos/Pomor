import PomorCore
import Foundation

class TaskRepositoryImpl: TaskRepository {

    private let dataSource: TaskDataSource
    private let connectivityManager: PhoneConnectivityManager

    init(
        dataSource: TaskDataSource,
        connectivityManager: PhoneConnectivityManager = .shared
    ) {
        self.dataSource = dataSource
        self.connectivityManager = connectivityManager
    }

    func getTasks() -> Result<[PomTask], Error> {
        dataSource.fetchTasks()
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
            connectivityManager.syncTasks(tasks)
        }
    }
}
