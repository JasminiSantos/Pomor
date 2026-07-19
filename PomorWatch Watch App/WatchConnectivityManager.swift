import Foundation
import WatchConnectivity
import Combine
import PomorCore

final class WatchConnectivityManager: NSObject, WatchTaskInboundSync, WatchTaskOutboundSync {

    static let shared = WatchConnectivityManager()

    private let tasksSubject = PassthroughSubject<[PomTask], Never>()
    private let lock = NSLock()

    private struct OutboundItem {
        let id: UUID
        let data: Data
    }

    private var pendingItems: [OutboundItem] = []
    private var transferFIFO: [UUID] = []
    private var deferredPhoneSnapshot: [PomTask]?

    var tasksReceived: AnyPublisher<[PomTask], Never> {
        tasksSubject.eraseToAnyPublisher()
    }

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func sendMutation(_ mutation: TaskSyncMutation) {
        guard WCSession.isSupported(),
              let data = try? JSONEncoder().encode(mutation) else { return }

        let item = OutboundItem(id: UUID(), data: data)
        lock.lock()
        pendingItems.append(item)
        lock.unlock()

        deliver(item)
    }

    func cachedTasksFromPhone() -> [PomTask]? {
        decodeTasks(from: WCSession.default.receivedApplicationContext)
    }

    func replayCachedTasksIfAvailable() {
        guard let tasks = cachedTasksFromPhone() else { return }
        applyPhoneSnapshot(tasks)
    }

    private func deliver(_ item: OutboundItem) {
        let session = WCSession.default
        guard session.activationState == .activated else { return }

        let payload: [String: Any] = [WatchConnectivityPayload.mutation: item.data]

        if session.isReachable {
            #if DEBUG
            print("📤 Watch sendMessage mutation (\(item.id))")
            #endif
            session.sendMessage(
                payload,
                replyHandler: { [weak self] _ in
                    self?.completeOutbound(id: item.id)
                },
                errorHandler: { [weak self] error in
                    #if DEBUG
                    print("⚠️ Watch sendMessage failed: \(error.localizedDescription) → transferUserInfo")
                    #endif
                    self?.enqueueTransfer(item, payload: payload)
                }
            )
        } else {
            #if DEBUG
            print("📤 Watch transferUserInfo (not reachable) (\(item.id))")
            #endif
            enqueueTransfer(item, payload: payload)
        }
    }

    private func enqueueTransfer(_ item: OutboundItem, payload: [String: Any]) {
        lock.lock()
        transferFIFO.append(item.id)
        lock.unlock()
        _ = WCSession.default.transferUserInfo(payload)
    }

    private func flushPendingIfReachable() {
        let session = WCSession.default
        guard session.activationState == .activated, session.isReachable else { return }

        lock.lock()
        let items = pendingItems
        lock.unlock()

        guard !items.isEmpty else { return }
        #if DEBUG
        print("📡 Watch reachable — retrying \(items.count) pending mutation(s) via sendMessage")
        #endif
        items.forEach(deliver)
    }

    private func completeOutbound(id: UUID) {
        lock.lock()
        guard let index = pendingItems.firstIndex(where: { $0.id == id }) else {
            lock.unlock()
            return
        }
        pendingItems.remove(at: index)
        transferFIFO.removeAll { $0 == id }

        let shouldFlush = pendingItems.isEmpty
        let deferred = shouldFlush ? deferredPhoneSnapshot : nil
        if shouldFlush {
            deferredPhoneSnapshot = nil
        }
        lock.unlock()

        #if DEBUG
        print("✅ Watch mutation acknowledged (\(id))")
        #endif

        guard let deferred else { return }
        DispatchQueue.main.async {
            self.tasksSubject.send(deferred)
        }
    }

    private func decodeTasks(from applicationContext: [String: Any]) -> [PomTask]? {
        guard applicationContext.keys.contains(WatchConnectivityPayload.tasks) else { return nil }
        guard let data = applicationContext[WatchConnectivityPayload.tasks] as? Data else { return nil }
        return try? JSONDecoder().decode([PomTask].self, from: data)
    }

    private func handleApplicationContext(_ applicationContext: [String: Any]) {
        guard let tasks = decodeTasks(from: applicationContext) else {
            #if DEBUG
            print("ℹ️ Watch: no phone application context yet")
            #endif
            return
        }
        applyPhoneSnapshot(tasks)
    }

    private func applyPhoneSnapshot(_ tasks: [PomTask]) {
        lock.lock()
        if !pendingItems.isEmpty {
            deferredPhoneSnapshot = tasks
            lock.unlock()
            return
        }
        deferredPhoneSnapshot = nil
        lock.unlock()

        DispatchQueue.main.async {
            self.tasksSubject.send(tasks)
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        #if DEBUG
        if let error {
            print("⚠️ Watch WCSession activation error: \(error.localizedDescription)")
        } else {
            print("✅ Watch WCSession activated (\(activationState.rawValue)), reachable=\(session.isReachable)")
        }
        #endif
        guard activationState == .activated else { return }
        handleApplicationContext(session.receivedApplicationContext)
        flushPendingIfReachable()
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        handleApplicationContext(applicationContext)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        #if DEBUG
        print("📡 Watch reachability → \(session.isReachable)")
        #endif
        if session.isReachable {
            flushPendingIfReachable()
        }
    }

    func session(
        _ session: WCSession,
        didFinish userInfoTransfer: WCSessionUserInfoTransfer,
        error: Error?
    ) {
        lock.lock()
        let id = transferFIFO.isEmpty ? nil : transferFIFO.removeFirst()
        lock.unlock()

        #if DEBUG
        if let error {
            print("⚠️ Watch transferUserInfo finished with error: \(error.localizedDescription)")
        } else {
            print("✅ Watch transferUserInfo delivered")
        }
        #endif

        if let id {
            completeOutbound(id: id)
        }
    }
}
