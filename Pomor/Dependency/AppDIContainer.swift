final class DIContainer {
    
    private var factories: [String: Any] = [:]
    
    func register<Service>(
        _ type: Service.Type,
        factory: @escaping (DIContainer) -> Service
    ) {
        factories["\(type)"] = factory
    }
    
    func register<Service, Arg>(
        _ type: Service.Type,
        factory: @escaping (DIContainer, Arg) -> Service
    ) {
        factories["\(type)_\(Arg.self)"] = factory
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        guard let factory = factories["\(type)"] as? (DIContainer) -> Service else {
            fatalError("No registration for \(type)")
        }
        return factory(self)
    }
    
    func resolve<Service, Arg>(_ type: Service.Type, arg: Arg) -> Service {
        guard let factory = factories["\(type)_\(Arg.self)"] as? (DIContainer, Arg) -> Service else {
            fatalError("No registration for \(type) with arg")
        }
        return factory(self, arg)
    }
}
