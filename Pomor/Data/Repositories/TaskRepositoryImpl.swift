import Foundation

class TaskRepositoryImpl: TaskRepository {
    
    private let dataSource: TaskDataSource
    
    init(dataSource: TaskDataSource) {
        self.dataSource = dataSource
    }
    
    func getTasks() -> Result<[Task], Error> {
        dataSource.fetchTasks()
    }
    
    func addTask(_ task: Task) -> Result<Void, Error> {
        dataSource.saveTask(task)
    }
    
    func deleteTask(_ task: Task) -> Result<Void, Error> {
        dataSource.deleteTask(task)
    }
    
    func updateTask(_ task: Task) -> Result<Void, Error> {
        dataSource.updateTask(task)
    }
}
