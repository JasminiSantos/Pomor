import PomorCore

final class WatchTaskRepositoryImpl: WatchTaskRepository {
    private let dataSource: WatchTaskDataSource

    init(dataSource: WatchTaskDataSource) {
        self.dataSource = dataSource
    }

    func getTasks() -> Result<[PomTask], Error> { dataSource.fetchTasks() }
    func addTask(_ task: PomTask) -> Result<Void, Error> { dataSource.saveTask(task) }
    func deleteTask(_ task: PomTask) -> Result<Void, Error> { dataSource.deleteTask(task) }
    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error> { dataSource.replaceTasks(tasks) }
}
