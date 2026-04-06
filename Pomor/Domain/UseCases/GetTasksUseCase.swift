import Foundation

class GetTasksUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute() -> Result<[Task], Error> {
        repository.getTasks()
    }
}
