import Foundation

public protocol Service {}

public final class DIStore {
    
    static var services = [String: Any]()
    
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
    
    func clear() {
        DIStore.services = [String: Any]()
    }

}
