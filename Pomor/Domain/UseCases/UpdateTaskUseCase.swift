import PomorCore
import Foundation

class UpdateTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute(task: PomTask) -> Result<Void, Error> {
        repository.updateTask(task)
    }
}
