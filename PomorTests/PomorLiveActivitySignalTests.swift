import Foundation
import PomorCore
import Testing

struct PomorLiveActivitySignalTests {

    @Test @MainActor
    func postSessionChanged_notifiesObservers() async {
        var received = false
        let id = PomorLiveActivitySignal.addObserver {
            received = true
        }
        defer { PomorLiveActivitySignal.removeObserver(id) }

        PomorLiveActivitySignal.postSessionChanged()

        // Darwin notify é entregue de forma assíncrona no main.
        for _ in 0..<20 where !received {
            await Task.yield()
            try? await Task.sleep(nanoseconds: 10_000_000)
        }

        #expect(received)
    }

    @Test @MainActor
    func removeObserver_stopsNotifications() async {
        var count = 0
        let id = PomorLiveActivitySignal.addObserver {
            count += 1
        }
        PomorLiveActivitySignal.removeObserver(id)

        PomorLiveActivitySignal.postSessionChanged()
        try? await Task.sleep(nanoseconds: 50_000_000)

        #expect(count == 0)
    }
}
