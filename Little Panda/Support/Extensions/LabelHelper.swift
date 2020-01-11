import UIKit

extension UILabel {
    
    func loadTimerConfig() {
        let font = Config.timerFont
        self.textColor = font.rgbColor.uiColor()
        self.font = UIFont(name: font.name, size: font.size)
    }
    
    func loadPandaConfig() {
        let font = Config.pandaFont
        self.textColor = font.rgbColor.uiColor()
        self.font = UIFont(name: font.name, size: font.size)
    }
}
