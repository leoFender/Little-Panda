import Foundation

public protocol Service {}

public final class DIStore {
    
    static var services = [String: Any]()
    static var factories = [String: Any]()
    
    func get<T>(_ serviceType: T.Type) -> T {
        let key = String(describing: serviceType)
        if let service = DIStore.services[key] as? T {
            return service
        } else {
            fatalError("Service of type \(key) not registered")
        }
    }
    
    func register<T>(_ service: Any, type: T.Type) {
        let key = String(describing: type)
        DIStore.services[key] = service
    }
    
    func viewModel<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let factory = DIStore.factories[key] as? () -> T {
            return factory()
        } else {
            fatalError("Factory of type \(key) not registered")
        }
    }
    
    func registerFactory<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        DIStore.factories[key] = factory
    }
    
    func clear() {
        DIStore.services = [String: Any]()
        DIStore.factories = [String: Any]()
    }

}
