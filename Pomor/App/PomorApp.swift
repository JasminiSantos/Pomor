import PomorDesignSystem
import SwiftData
import SwiftUI

@main
struct PomorApp: App {
    private let dependencies: DependencyMap

    init() {
        FontRegistrar.register()
        dependencies = .live()
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: dependencies.container)
        }
        .modelContainer(dependencies.modelContainer)
    }
}
