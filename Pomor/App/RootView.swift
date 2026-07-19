import PomorDI
import SwiftUI

struct RootView: View {

    @StateObject private var coordinator: AppCoordinator

    init(container: DIContainer) {
        _coordinator = StateObject(
            wrappedValue: AppCoordinator(container: container)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(coordinator.root)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route)
                }
        }
    }
}
