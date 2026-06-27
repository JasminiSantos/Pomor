import SwiftUI
import PomorDI

@main
struct PomorWatchApp: App {
    private let container: DIContainer = {
        let c = DIContainer()
        WatchDependencyMap.register(in: c)
        return c
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchTaskListView()
            }
            .environmentObject(container.resolve(WatchTaskListViewModel.self))
        }
    }
}
