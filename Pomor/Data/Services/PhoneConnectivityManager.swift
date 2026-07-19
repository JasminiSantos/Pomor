import Foundation
import WatchConnectivity
import PomorCore

final class PhoneConnectivityManager: NSObject, WatchSyncService {

    static let shared = PhoneConnectivityManager()

    /// Handler das mutações vindas do Watch (injetado após o DI estar pronto).
    weak var mutationHandler: WatchMutationHandling?

    /// Último snapshot a enviar — reenviado quando a sessão ativar.
    private var pendingTasks: [PomTask]?
    private let lock = NSLock()

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func syncTasks(_ tasks: [PomTask]) {
        lock.lock()
        pendingTasks = tasks
        lock.unlock()
        pushPendingIfPossible()
    }

    private func pushPendingIfPossible() {
        lock.lock()
        guard let tasks = pendingTasks else {
            lock.unlock()
            return
        }
        lock.unlock()

        guard WCSession.isSupported(),
              WCSession.default.activationState == .activated else { return }

        #if !targetEnvironment(simulator)
        guard WCSession.default.isPaired,
              WCSession.default.isWatchAppInstalled else { return }
        #endif

        guard let data = try? JSONEncoder().encode(tasks) else { return }

        do {
            try WCSession.default.updateApplicationContext([
                WatchConnectivityPayload.tasks: data
            ])
        } catch {
            #if DEBUG
            print("⚠️ PhoneConnectivityManager sync failed: \(error.localizedDescription)")
            #endif
        }
    }

    private func handleIncomingMutation(from payload: [String: Any]) {
        guard let data = payload[WatchConnectivityPayload.mutation] as? Data,
              let mutation = try? JSONDecoder().decode(TaskSyncMutation.self, from: data) else {
            #if DEBUG
            print("⚠️ PhoneConnectivityManager: invalid watch mutation payload")
            #endif
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.mutationHandler?.handleWatchMutation(mutation)
        }
    }
}

extension PhoneConnectivityManager: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        #if DEBUG
        if let error {
            print("⚠️ Phone WCSession activation error: \(error.localizedDescription)")
        } else {
            print("✅ Phone WCSession activated (\(activationState.rawValue)), reachable=\(session.isReachable)")
        }
        #endif
        guard activationState == .activated else { return }
        pushPendingIfPossible()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        #if DEBUG
        print("📡 Phone reachability → \(session.isReachable)")
        #endif
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        #if DEBUG
        print("📥 Phone received userInfo mutation from Watch")
        #endif
        handleIncomingMutation(from: userInfo)
    }

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        #if DEBUG
        print("📥 Phone received message mutation from Watch")
        #endif
        handleIncomingMutation(from: message)
        replyHandler(["ok": true])
    }
}
