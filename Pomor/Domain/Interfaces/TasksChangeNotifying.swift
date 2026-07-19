import Combine

/// Sinaliza que a lista de tasks mudou fora da UI (ex.: mutação vinda do Watch).
protocol TasksChangeNotifying: AnyObject {
    var tasksDidChange: AnyPublisher<Void, Never> { get }
    func notifyTasksDidChange()
}
