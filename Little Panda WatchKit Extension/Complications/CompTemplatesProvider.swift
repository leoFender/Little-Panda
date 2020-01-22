import Foundation
import ClockKit

protocol ComplicationTemplatesProvider {
    func template(_ family: CLKComplicationFamily) -> CLKComplicationTemplate?
}

struct ComplicationTemplatesService: ComplicationTemplatesProvider {
    
    func template(_ family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        switch family {
            
        case .circularSmall:
            let tmpl = CLKComplicationTemplateCircularSmallRingImage()
            tmpl.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!)
            tmpl.ringStyle = .closed
            tmpl.fillFraction = 0.67
            return tmpl
            
        case .extraLarge:
            let tmpl = CLKComplicationTemplateExtraLargeRingImage()
            tmpl.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Extra Large")!)
            tmpl.ringStyle = .closed
            tmpl.fillFraction = 0.67
            return tmpl
        
        case .graphicBezel:
            let tmpl = CLKComplicationTemplateGraphicBezelCircularText()
            tmpl.textProvider = CLKSimpleTextProvider(text: "67%")
            let circle = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Graphic Bezel")!)
                circle.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!, tintedImageProvider: image)
            } else {
                circle.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!)
            }
            circle.gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                          gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                          gaugeColorLocations: [0, 0.5, 1.0],
                                                          fillFraction: 0.67)
            tmpl.circularTemplate = circle
            return tmpl
            
        case .graphicCircular:
            let tmpl = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Graphic Circular")!)
                tmpl.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!, tintedImageProvider: image)
            } else {
                tmpl.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            }
            tmpl.centerTextProvider = CLKSimpleTextProvider(text: "67%")
            tmpl.gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                        gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                        gaugeColorLocations: [0, 0.5, 1.0],
                                                        fillFraction: 0.67)
            return tmpl
            
        case .graphicCorner:
            let tmpl = CLKComplicationTemplateGraphicCornerGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Graphic Corner")!)
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!, tintedImageProvider: image)
            } else {
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            }
            tmpl.gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                        gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                        gaugeColorLocations: [0, 0.5, 1.0],
                                                        fillFraction: 0.67)
            return tmpl
            
        case .modularLarge:
            let tmpl = CLKComplicationTemplateModularLargeStandardBody()
            tmpl.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            tmpl.headerTextProvider = CLKSimpleTextProvider(text: "Panda info:")
            tmpl.body1TextProvider = CLKSimpleTextProvider(text: "10m 17d 15h")
            tmpl.body2TextProvider = CLKSimpleTextProvider(text: "Charge: 67%")
            return tmpl
            
        case .modularSmall:
            let tmpl = CLKComplicationTemplateModularSmallRingImage()
            tmpl.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            tmpl.ringStyle = .closed
            tmpl.fillFraction = 0.67
            return tmpl
            
        case .utilitarianLarge:
            let tmpl = CLKComplicationTemplateUtilitarianLargeFlat()
            tmpl.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            tmpl.textProvider = CLKSimpleTextProvider(text: "67%")
            return tmpl
        
        case .utilitarianSmall:
            let tmpl = CLKComplicationTemplateUtilitarianSmallRingImage()
            tmpl.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            tmpl.ringStyle = .closed
            tmpl.fillFraction = 0.67
            return tmpl
            
        case .utilitarianSmallFlat:
            let tmpl = CLKComplicationTemplateUtilitarianSmallFlat()
            tmpl.textProvider = CLKSimpleTextProvider(text: "Panda charge: 67%")
            return tmpl
            
        default:
            return nil
        }
    }
}
