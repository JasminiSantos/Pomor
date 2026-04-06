import Foundation

protocol TaskRepository {
    func getTasks() -> Result<[Task], Error>
    func addTask(_ task: Task) -> Result<Void, Error>
    func updateTask(_ task: Task) -> Result<Void, Error>
    func deleteTask(_ task: Task) -> Result<Void, Error>
}
