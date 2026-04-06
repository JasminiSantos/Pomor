import Combine
import SwiftUI

protocol TimerService {
    func start(interval: TimeInterval, handler: @escaping () -> Void)
    func stop()
}

final class DefaultTimerService: TimerService {
    
    private var cancellable: AnyCancellable?
    
    func start(interval: TimeInterval, handler: @escaping () -> Void) {
        cancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in handler() }
    }
    
    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
}
