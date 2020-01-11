import Foundation
import UIKit

protocol HasDefaultConfigValue: Codable {
    static func base() -> Self
}

struct ColorConfiguration: Codable, HasDefaultConfigValue {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    static func base() -> ColorConfiguration {
        let system = UIColor.label.rgb()
        return ColorConfiguration(red: system.red,
                                  green: system.green,
                                  blue: system.blue,
                                  alpha: system.alpha)
    }
    
    func uiColor() -> UIColor {
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
}

struct FontConfiguration: Codable, HasDefaultConfigValue {
    let name: String
    let size: CGFloat
    let rgbColor: ColorConfiguration
    
    static func base() -> FontConfiguration {
        return FontConfiguration(name: "Helvetica Neue",
                                 size: 25.0,
                                 rgbColor: ColorConfiguration.base())
    }
}

struct PositionConfiguration: Codable, HasDefaultConfigValue {
    let vertical: CGFloat
    let horizontal: CGFloat
    
    static func base() -> PositionConfiguration {
        return PositionConfiguration(vertical: 0, horizontal: 0)
    }
}
