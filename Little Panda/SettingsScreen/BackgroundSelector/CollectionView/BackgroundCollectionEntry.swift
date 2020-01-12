import UIKit
import Foundation

final class BackgroundCollectionEntry: Hashable {
    
    private let identifier: String = "BackgroundCollectionEntry"
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    static func == (lhs: BackgroundCollectionEntry, rhs: BackgroundCollectionEntry) -> Bool {
        return lhs.name == rhs.name && lhs.isSelected == rhs.isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
