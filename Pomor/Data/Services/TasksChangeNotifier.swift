import Combine

final class TasksChangeNotifier: TasksChangeNotifying {
    private let subject = PassthroughSubject<Void, Never>()

    var tasksDidChange: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }

    func notifyTasksDidChange() {
        subject.send(())
    }
}
