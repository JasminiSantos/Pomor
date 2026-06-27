import Foundation
import WatchConnectivity
import PomorCore

final class PhoneConnectivityManager: NSObject {

    static let shared = PhoneConnectivityManager()

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func syncTasks(_ tasks: [PomTask]) {
        guard WCSession.isSupported(),
              WCSession.default.activationState == .activated,
              WCSession.default.isPaired,
              WCSession.default.isWatchAppInstalled else { return }

        guard let data = try? JSONEncoder().encode(tasks) else { return }
        try? WCSession.default.updateApplicationContext(["tasks": data])
    }
}

extension PhoneConnectivityManager: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
