import Foundation
import PomorCore

final class AddWatchTaskUseCase {
    private let repository: WatchTaskRepository

    init(repository: WatchTaskRepository) {
        self.repository = repository
    }

    func execute(title: String, duration: Int) -> Result<Void, Error> {
        let task = PomTask(id: UUID(), title: title, duration: duration, icon: "target")
        return repository.addTask(task)
    }
}
