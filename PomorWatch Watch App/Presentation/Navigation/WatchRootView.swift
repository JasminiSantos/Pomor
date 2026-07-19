import PomorDI
import SwiftUI

struct WatchRootView: View {
    @StateObject private var coordinator: WatchCoordinator

    init(container: DIContainer) {
        _coordinator = StateObject(
            wrappedValue: WatchCoordinator(container: container)
        )
    }

    var body: some View {
        NavigationStack {
            coordinator.build(.home)
                .navigationDestination(for: WatchRoute.self) { route in
                    coordinator.build(route)
                }
        }
    }
}
