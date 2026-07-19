import Foundation
import PomorCore

final class WatchLocalTaskDataSource: WatchTaskDataSource {
    private let tasksKey = "watch_tasks"
    private let syncedKey = "watch_tasks_has_synced"
    private var tasks: [PomTask] = []

    private(set) var hasSyncedFromPhone: Bool

    init() {
        hasSyncedFromPhone = UserDefaults.standard.bool(forKey: syncedKey)
        if case .success(let loaded) = load() { tasks = loaded }
    }

    func fetchTasks() -> Result<[PomTask], Error> {
        .success(tasks)
    }

    func saveTask(_ task: PomTask) -> Result<Void, Error> {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        return persist()
    }

    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        guard tasks.contains(where: { $0.id == task.id }) else {
            return .failure(TaskError.notFound)
        }
        tasks.removeAll { $0.id == task.id }
        return persist()
    }

    func replaceTasks(_ tasks: [PomTask]) -> Result<Void, Error> {
        self.tasks = tasks
        hasSyncedFromPhone = true
        UserDefaults.standard.set(true, forKey: syncedKey)
        return persist()
    }

    private func persist() -> Result<Void, Error> {
        guard let data = try? JSONEncoder().encode(tasks) else {
            return .failure(DataSourceError.encodingFailed)
        }
        UserDefaults.standard.set(data, forKey: tasksKey)
        return .success(())
    }

    private func load() -> Result<[PomTask], Error> {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else { return .success([]) }
        guard let decoded = try? JSONDecoder().decode([PomTask].self, from: data) else {
            return .failure(DataSourceError.decodingFailed)
        }
        return .success(decoded)
    }
}
