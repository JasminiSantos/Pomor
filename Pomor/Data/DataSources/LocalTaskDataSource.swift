import Foundation

protocol TaskDataSource {
    func fetchTasks() -> Result<[Task], Error>
    func saveTask(_ task: Task) -> Result<Void, Error>
    func deleteTask(_ task: Task) -> Result<Void, Error>
    func updateTask(_ task: Task) -> Result<Void, Error>
}

class LocalTaskDataSource: TaskDataSource {
    private let key = "tasks_storage"
    private var tasks: [Task] = []
    

    init() {
        if case .success(let loadedTasks) = load() {
            self.tasks = loadedTasks
        }
    }
    
    func fetchTasks() -> Result<[Task], Error> {
        .success(tasks)
    }
    
    func saveTask(_ task: Task) -> Result<Void, Error> {
        tasks.append(task)
        return persist()
    }
    
    func deleteTask(_ task: Task) -> Result<Void, Error> {
        tasks.removeAll { $0.id == task.id }
        return persist()
    }
    
    func updateTask(_ task: Task) -> Result<Void, Error> {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return .failure(TaskError.notFound)
        }
        
        tasks[index] = task
        return persist()
    }
}

private extension LocalTaskDataSource {
    
    func persist() -> Result<Void, Error> {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: key)
            return .success(())
        } catch {
            return .failure(DataSourceError.persistenceFailed)
        }
    }
    
    func load() -> Result<[Task], Error> {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return .success([])
        }
        
        do {
            let decodedTasks = try JSONDecoder().decode([Task].self, from: data)
            return .success(decodedTasks)
        } catch {
            return .failure(DataSourceError.persistenceFailed)
        }
    }
}
