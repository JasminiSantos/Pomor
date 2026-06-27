final class WatchDIContainer {
    private var factories: [WatchDIKey: Any] = [:]
    private var singletons: [WatchDIKey: Any] = [:]

    func register<Service>(
        _ type: Service.Type,
        factory: @escaping (WatchDIContainer) -> Service
    ) {
        factories[WatchDIKey(type)] = factory
    }

    func register<Service, Arg>(
        _ type: Service.Type,
        factory: @escaping (WatchDIContainer, Arg) -> Service
    ) {
        factories[WatchDIKey(type, argType: Arg.self)] = factory
    }

    func registerSingleton<Service>(
        _ type: Service.Type,
        factory: @escaping (WatchDIContainer) -> Service
    ) {
        let key = WatchDIKey(type)
        factories[key] = { [weak self] (container: WatchDIContainer) -> Service in
            guard let self else { fatalError("WatchDIContainer was deallocated before \(type) could be resolved.") }
            if let existing = self.singletons[key] as? Service { return existing }
            let instance = factory(container)
            self.singletons[key] = instance
            return instance
        }
    }

    func resolve<Service>(_ type: Service.Type) -> Service {
        guard let factory = factories[WatchDIKey(type)] as? (WatchDIContainer) -> Service else {
            fatalError("No registration found for \(type)")
        }
        return factory(self)
    }

    func resolve<Service, Arg>(_ type: Service.Type, arg: Arg) -> Service {
        guard let factory = factories[WatchDIKey(type, argType: Arg.self)] as? (WatchDIContainer, Arg) -> Service else {
            fatalError("No registration found for \(type) with arg \(Arg.self)")
        }
        return factory(self, arg)
    }
}

private struct WatchDIKey: Hashable {
    let serviceId: ObjectIdentifier
    let argId: ObjectIdentifier?

    init(_ type: Any.Type) {
        serviceId = ObjectIdentifier(type)
        argId = nil
    }

    init(_ type: Any.Type, argType: Any.Type) {
        serviceId = ObjectIdentifier(type)
        argId = ObjectIdentifier(argType)
    }
}
