import Foundation

/// Sinal cross-process entre a Live Activity (extension) e o app.
public enum PomorLiveActivitySignal {
    nonisolated(unsafe) private static let sessionChanged = "pucpr.Pomor.liveActivity.sessionChanged" as CFString
    nonisolated(unsafe) private static let lock = NSLock()
    nonisolated(unsafe) private static var handlers: [UUID: () -> Void] = [:]
    nonisolated(unsafe) private static var isObserving = false

    public static func postSessionChanged() {
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName(sessionChanged),
            nil,
            nil,
            true
        )
    }

    public static func addObserver(_ handler: @escaping () -> Void) -> UUID {
        let id = UUID()
        lock.lock()
        handlers[id] = handler
        if !isObserving {
            isObserving = true
            CFNotificationCenterAddObserver(
                CFNotificationCenterGetDarwinNotifyCenter(),
                nil,
                { _, _, _, _, _ in
                    PomorLiveActivitySignal.notifyHandlers()
                },
                sessionChanged,
                nil,
                .deliverImmediately
            )
        }
        lock.unlock()
        return id
    }

    public static func removeObserver(_ id: UUID) {
        lock.lock()
        handlers[id] = nil
        lock.unlock()
    }

    private static func notifyHandlers() {
        lock.lock()
        let current = Array(handlers.values)
        lock.unlock()
        DispatchQueue.main.async {
            current.forEach { $0() }
        }
    }
}
