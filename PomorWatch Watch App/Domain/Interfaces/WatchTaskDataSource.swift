import PomorCore

protocol WatchTaskDataSource {
    var hasSyncedFromPhone: Bool { get }
    func fetchTasks() -> Result<[PomTask], Error>
    func saveTask(_ task: PomTask) -> Result<Void, Error>
    func deleteTask(_ task: PomTask) -> Result<Void, Error>
    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error>
}
