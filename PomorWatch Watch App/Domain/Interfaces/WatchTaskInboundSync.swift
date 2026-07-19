import Combine
import PomorCore

protocol WatchTaskInboundSync: AnyObject {
    var tasksReceived: AnyPublisher<[PomTask], Never> { get }
    func replayCachedTasksIfAvailable()
}
