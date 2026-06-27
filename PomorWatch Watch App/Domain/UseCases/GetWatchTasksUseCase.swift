import PomorCore

final class GetWatchTasksUseCase {
    private let repository: WatchTaskRepository

    init(repository: WatchTaskRepository) {
        self.repository = repository
    }

    func execute() -> Result<[PomTask], Error> {
        repository.getTasks()
    }
}
