import Foundation
import UIKit

extension UIColor {

    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            return (red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
