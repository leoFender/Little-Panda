import UIKit

extension UILabel {
    
    func loadTimerConfig() {
        let font = Config.timerFont
        textColor = font.rgbColor.uiColor()
        self.font = UIFont(name: font.name, size: font.size)
        
        dropShadow()
    }
    
    func loadPandaConfig() {
        let font = Config.pandaFont
        self.font = UIFont(name: font.name, size: font.size)
        
        dropShadow()
    }
    
    func dropShadow() {
        layer.shadowColor = UIColor(named: "TextShadowColor")?.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize.zero
    }
}
