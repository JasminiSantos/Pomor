import Foundation
@testable import Pomor

final class MockTaskRepository: TaskRepository {
    
    var tasks: [Task] = []
    
    var errorToReturn: Error?
    
    func getTasks() -> Result<[Task], Error> {
        if let error = errorToReturn {
            return .failure(error)
        }
        return .success(tasks)
    }
    
    func addTask(_ task: Task) -> Result<Void, Error> {
        if let error = errorToReturn {
            return .failure(error)
        }
        tasks.append(task)
        return .success(())
    }
    
    func deleteTask(_ task: Task) -> Result<Void, Error> {
        if let error = errorToReturn {
            return .failure(error)
        }
        tasks.removeAll { $0.id == task.id }
        return .success(())
    }
    
    func updateTask(_ task: Task) -> Result<Void, Error> {
        if let error = errorToReturn {
            return .failure(error)
        }
        
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return .failure(TaskError.notFound)
        }
        
        tasks[index] = task
        return .success(())
    }
}
