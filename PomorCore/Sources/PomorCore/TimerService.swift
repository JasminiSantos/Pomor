import Combine
import Foundation

public protocol TimerService: AnyObject {
    func start(interval: TimeInterval, handler: @escaping () -> Void)
    func stop()
}

public final class DefaultTimerService: TimerService {

    private var cancellable: AnyCancellable?

    public init() {}

    public func start(interval: TimeInterval, handler: @escaping () -> Void) {
        cancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in handler() }
    }

    public func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
}
