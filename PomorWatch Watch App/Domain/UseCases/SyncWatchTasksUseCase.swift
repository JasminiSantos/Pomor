import PomorCore

final class SyncWatchTasksUseCase {
    private let repository: WatchTaskRepository

    init(repository: WatchTaskRepository) {
        self.repository = repository
    }

    func execute(_ tasks: [PomTask]) -> Result<Void, Error> {
        repository.replaceTasks(tasks)
    }
}
