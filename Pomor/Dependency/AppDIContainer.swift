final class DIContainer {

    private var factories: [DIKey: Any] = [:]
    private var singletons: [DIKey: Any] = [:]


    func register<Service>(
        _ type: Service.Type,
        factory: @escaping (DIContainer) -> Service
    ) {
        factories[DIKey(type)] = factory
    }

    func register<Service, Arg>(
        _ type: Service.Type,
        factory: @escaping (DIContainer, Arg) -> Service
    ) {
        factories[DIKey(type, argType: Arg.self)] = factory
    }


    func registerSingleton<Service>(
        _ type: Service.Type,
        factory: @escaping (DIContainer) -> Service
    ) {
        let key = DIKey(type)
        factories[key] = { [weak self] (container: DIContainer) -> Service in
            guard let self else { fatalError("DIContainer was deallocated before \(type) could be resolved.") }
            if let existing = self.singletons[key] as? Service { return existing }
            let instance = factory(container)
            self.singletons[key] = instance
            return instance
        }
    }


    func resolve<Service>(_ type: Service.Type) -> Service {
        guard let factory = factories[DIKey(type)] as? (DIContainer) -> Service else {
            fatalError("No registration found for \(type)")
        }
        return factory(self)
    }

    func resolve<Service, Arg>(_ type: Service.Type, arg: Arg) -> Service {
        guard let factory = factories[DIKey(type, argType: Arg.self)] as? (DIContainer, Arg) -> Service else {
            fatalError("No registration found for \(type) with arg \(Arg.self)")
        }
        return factory(self, arg)
    }
}

private struct DIKey: Hashable {
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
