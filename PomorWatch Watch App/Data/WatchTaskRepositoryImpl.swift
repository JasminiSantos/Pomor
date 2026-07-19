import PomorCore

final class WatchTaskRepositoryImpl: WatchTaskRepository {
    private let dataSource: WatchTaskDataSource
    private let outboundSync: WatchTaskOutboundSync

    init(
        dataSource: WatchTaskDataSource,
        outboundSync: WatchTaskOutboundSync
    ) {
        self.dataSource = dataSource
        self.outboundSync = outboundSync
    }

    var hasSyncedFromPhone: Bool { dataSource.hasSyncedFromPhone }

    func getTasks() -> Result<[PomTask], Error> {
        dataSource.fetchTasks()
    }

    func addTask(_ task: PomTask) -> Result<Void, Error> {
        let result = dataSource.saveTask(task)
        if case .success = result {
            outboundSync.sendMutation(.add(task))
        }
        return result
    }

    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        let result = dataSource.deleteTask(task)
        if case .success = result {
            outboundSync.sendMutation(.delete(task.id))
        }
        return result
    }

    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error> {
        dataSource.replaceTasks(tasks)
    }
}
