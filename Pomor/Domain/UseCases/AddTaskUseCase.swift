import PomorCore
import Foundation

class AddTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute(title: String, duration: Int, icon: String) -> Result<Void, Error> {
        let task = PomTask(id: UUID(), title: title, duration: duration, icon: icon)
        return repository.addTask(task)
    }
}
