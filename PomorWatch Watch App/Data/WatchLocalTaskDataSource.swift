import Foundation
import PomorCore

protocol WatchTaskDataSource {
    func fetchTasks() -> Result<[PomTask], Error>
    func saveTask(_ task: PomTask) -> Result<Void, Error>
    func deleteTask(_ task: PomTask) -> Result<Void, Error>
    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error>
}

final class WatchLocalTaskDataSource: WatchTaskDataSource {
    private let key = "watch_tasks"
    private var tasks: [PomTask] = []

    init() {
        if case .success(let loaded) = load() { tasks = loaded }
    }

    func fetchTasks() -> Result<[PomTask], Error> {
        .success(tasks)
    }

    func saveTask(_ task: PomTask) -> Result<Void, Error> {
        tasks.append(task)
        return persist()
    }

    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        tasks.removeAll { $0.id == task.id }
        return persist()
    }

    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error> {
        self.tasks = tasks
        return persist()
    }

    private func persist() -> Result<Void, Error> {
        guard let data = try? JSONEncoder().encode(tasks) else {
            return .failure(DataSourceError.encodingFailed)
        }
        UserDefaults.standard.set(data, forKey: key)
        return .success(())
    }

    private func load() -> Result<[PomTask], Error> {
        guard let data = UserDefaults.standard.data(forKey: key) else { return .success([]) }
        guard let decoded = try? JSONDecoder().decode([PomTask].self, from: data) else {
            return .failure(DataSourceError.decodingFailed)
        }
        return .success(decoded)
    }
}
