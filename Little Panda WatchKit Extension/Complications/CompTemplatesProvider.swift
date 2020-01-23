import Foundation
import ClockKit

protocol ComplicationTemplatesProvider {
    func template(_ family: CLKComplicationFamily) -> CLKComplicationTemplate?
}

struct ComplicationTemplatesService: ComplicationTemplatesProvider {
    
    func template(_ family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        
        let imageProvider: (String) -> CLKImageProvider = { name in
            let image = UIImage(named: "Complication/\(name)")!
            return CLKImageProvider(onePieceImage: image)
        }
        let fraction: Float = 0.67
        let textProvider = CLKSimpleTextProvider(text: "67%")

        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                   gaugeColorLocations: [0, 0.5, 1.0],
                                                   fillFraction: fraction)
        
        switch family {
            
        case .circularSmall:
            let tmpl = CLKComplicationTemplateCircularSmallRingImage()
            tmpl.imageProvider = imageProvider("Circular")
            tmpl.ringStyle = .closed
            tmpl.fillFraction = fraction
            return tmpl
            
        case .extraLarge:
            let tmpl = CLKComplicationTemplateExtraLargeRingImage()
            tmpl.imageProvider = imageProvider("Extra Large")
            tmpl.ringStyle = .closed
            tmpl.fillFraction = fraction
            return tmpl
        
        case .graphicBezel:
            let tmpl = CLKComplicationTemplateGraphicBezelCircularText()
            tmpl.textProvider = textProvider
            let circle = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                circle.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!, tintedImageProvider: imageProvider("Graphic Bezel"))
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
            tmpl.centerTextProvider = CLKSimpleTextProvider(text: "67") // % does not fit
            tmpl.gaugeProvider = gaugeProvider
            return tmpl
            
        case .graphicCorner:
            let tmpl = CLKComplicationTemplateGraphicCornerGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!, tintedImageProvider: imageProvider("Graphic Corner"))
            } else {
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            }
            tmpl.gaugeProvider = gaugeProvider
            return tmpl
            
        case .modularLarge:
            let tmpl = CLKComplicationTemplateModularLargeStandardBody()
            tmpl.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            tmpl.headerTextProvider = CLKSimpleTextProvider(text: "Panda info:")
            tmpl.headerTextProvider.tintColor = UIColor.purple
            tmpl.body1TextProvider = CLKSimpleTextProvider(text: "10m 17d 15h")
            tmpl.body2TextProvider = CLKSimpleTextProvider(text: "Charge: 67%")
            return tmpl
            
        case .modularSmall:
            let tmpl = CLKComplicationTemplateModularSmallRingImage()
            tmpl.imageProvider = imageProvider("Modular")
            tmpl.ringStyle = .closed
            tmpl.fillFraction = fraction
            return tmpl
            
        case .utilitarianLarge:
            let tmpl = CLKComplicationTemplateUtilitarianLargeFlat()
            tmpl.textProvider = CLKSimpleTextProvider(text: "Panda charge: 67%")
            return tmpl
        
        case .utilitarianSmall:
            let tmpl = CLKComplicationTemplateUtilitarianSmallRingImage()
            tmpl.imageProvider = imageProvider("Utilitarian")
            tmpl.ringStyle = .closed
            tmpl.fillFraction = fraction
            return tmpl
            
        case .utilitarianSmallFlat:
            let tmpl = CLKComplicationTemplateUtilitarianSmallFlat()
            tmpl.textProvider = CLKSimpleTextProvider(text: "67%")
            return tmpl
            
        default:
            return nil
        }
    }
}
