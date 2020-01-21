import Foundation
import UIKit

enum TransferModel {
    case pandaAvailableDate(Date)
    case complicationIndex(Int)
    
    static let transferPandaKey = "TransferModelPandaKey"
    static let transferComplicationKey = "TransferModelComplicationKey"
    static let requestValue = "ValueHasBeenRequested"
    
    var key: String {
        switch self {
        case .pandaAvailableDate(_):
            return TransferModel.transferPandaKey
        case .complicationIndex(_):
            return TransferModel.transferComplicationKey
        }
    }
    
    func transferValue() -> Any {
        switch self {
        case .pandaAvailableDate(let date):
            return date as NSDate
        case .complicationIndex(let index):
            return NSNumber(integerLiteral: index)
        }
    }
}
