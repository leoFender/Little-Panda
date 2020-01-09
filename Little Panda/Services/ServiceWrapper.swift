import UIKit

@propertyWrapper
class Injected<T> {
    private var _cached: T?
    
    var wrappedValue: T {
        if _cached != nil { return _cached! }
        
        _cached = DIStore().get(T.self)
        return _cached!
    }
}
