import PomorCore

protocol TaskDataSource {
    func fetchTasks() -> Result<[PomTask], Error>
    func saveTask(_ task: PomTask) -> Result<Void, Error>
    func deleteTask(_ task: PomTask) -> Result<Void, Error>
    func updateTask(_ task: PomTask) -> Result<Void, Error>
}
