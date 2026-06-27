import SwiftUI

@main
struct PomorWatchApp: App {
    private let container: WatchDIContainer = {
        let c = WatchDIContainer()
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
