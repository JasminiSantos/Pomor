import PomorCore

final class DeleteWatchTaskUseCase {
    private let repository: WatchTaskRepository

    init(repository: WatchTaskRepository) {
        self.repository = repository
    }

    func execute(_ task: PomTask) -> Result<Void, Error> {
        repository.deleteTask(task)
    }
}
