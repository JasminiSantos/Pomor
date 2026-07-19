import PomorDesignSystem
import SwiftUI

@main
struct PomorWatchApp: App {
    private let dependencies: WatchDependencyMap

    init() {
        FontRegistrar.register()
        dependencies = .live()
    }

    var body: some Scene {
        WindowGroup {
            WatchRootView(container: dependencies.container)
        }
    }
}
