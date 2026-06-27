import PomorCore
import Foundation

protocol TaskRepository {
    func getTasks() -> Result<[PomTask], Error>
    func addTask(_ task: PomTask) -> Result<Void, Error>
    func updateTask(_ task: PomTask) -> Result<Void, Error>
    func deleteTask(_ task: PomTask) -> Result<Void, Error>
}
