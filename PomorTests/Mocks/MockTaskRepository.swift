import PomorCore
import Foundation
@testable import Pomor

final class MockTaskRepository: TaskRepository {
    
    var tasks: [PomTask] = []
    var errorToReturn: Error?
    
    private(set) var getTasksCallCount = 0
    private(set) var addTaskCallCount = 0
    private(set) var deleteTaskCallCount = 0
    private(set) var updateTaskCallCount = 0
    
    func getTasks() -> Result<[PomTask], Error> {
        getTasksCallCount += 1
        if let error = errorToReturn {
            return .failure(error)
        }
        return .success(tasks)
    }
    
    func addTask(_ task: PomTask) -> Result<Void, Error> {
        addTaskCallCount += 1
        if let error = errorToReturn {
            return .failure(error)
        }
        tasks.append(task)
        return .success(())
    }
    
    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        deleteTaskCallCount += 1
        if let error = errorToReturn {
            return .failure(error)
        }
        tasks.removeAll { $0.id == task.id }
        return .success(())
    }
    
    func updateTask(_ task: PomTask) -> Result<Void, Error> {
        updateTaskCallCount += 1
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
