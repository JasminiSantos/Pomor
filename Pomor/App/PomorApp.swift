import PomorDI
import SwiftUI

@main
struct PomorApp: App {
    
    let container: DIContainer = {
        let c = DIContainer()
        DependencyMap.register(in: c)
        return c
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
