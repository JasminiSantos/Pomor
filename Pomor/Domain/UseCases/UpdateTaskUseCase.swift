import SwiftUI

class UpdateTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute(task: Task) -> Result<Void, Error> {
        repository.updateTask(task)
    }
}
