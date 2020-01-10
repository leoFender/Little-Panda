import Foundation

@propertyWrapper
class ViewModel<T> {
    private var _cached: T?
    
    var wrappedValue: T {
        if _cached != nil { return _cached! }
        
        _cached = DIStore().viewModel(T.self)
        return _cached!
    }
}
