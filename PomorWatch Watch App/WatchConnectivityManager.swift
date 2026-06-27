import Foundation
import WatchConnectivity
import Combine
import PomorCore

@MainActor final class WatchConnectivityManager: NSObject {

    static let shared = WatchConnectivityManager()

    let tasksReceived = PassthroughSubject<[PomTask], Never>()

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    
}

extension WatchConnectivityManager: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        guard activationState == .activated else { return }
        handleApplicationContext(session.receivedApplicationContext)
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        handleApplicationContext(applicationContext)
    }
    
    private func handleApplicationContext(_ applicationContext: [String: Any]) {
        guard let data = applicationContext["tasks"] as? Data,
              let tasks = try? JSONDecoder().decode([PomTask].self, from: data) else {
            return
        }

        DispatchQueue.main.async {
            self.tasksReceived.send(tasks)
        }
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
}
