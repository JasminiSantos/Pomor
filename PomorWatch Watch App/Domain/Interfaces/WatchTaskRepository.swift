import PomorCore

protocol WatchTaskRepository {
    func getTasks() -> Result<[PomTask], Error>
    func addTask(_ task: PomTask) -> Result<Void, Error>
    func deleteTask(_ task: PomTask) -> Result<Void, Error>
    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error>
}
