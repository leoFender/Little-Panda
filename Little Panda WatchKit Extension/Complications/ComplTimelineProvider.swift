import Foundation
import ClockKit

protocol ComplicationTimelineProvider {
    func current(_ complication: CLKComplication) -> CLKComplicationTimelineEntry
    func afterDate(_ complication: CLKComplication, afterDate: Date, limit: Int) -> [CLKComplicationTimelineEntry]
}

struct ComplicationTimelineService: ComplicationTimelineProvider {
    
    func current(_ complication: CLKComplication) -> CLKComplicationTimelineEntry {
        let entry = CLKComplicationTimelineEntry()
        entry.date = Date()
        entry.complicationTemplate = template(complication)
        return entry
    }
    
    func afterDate(_ complication: CLKComplication, afterDate: Date, limit: Int) -> [CLKComplicationTimelineEntry] {
        if WatchConfig.watchFaceTimerIndex == 0 {
            return [current(complication)]
        } else {
            var displayDates: [Date] = []
            for i in 1...limit {
                let interval = SharedConstants.onePercentTimeInterval * Double(i)
                displayDates.append(Date(timeInterval: interval, since: afterDate))
            }
            
            return displayDates.map { (date) -> CLKComplicationTimelineEntry in
                let entry = CLKComplicationTimelineEntry()
                entry.date = date
                entry.complicationTemplate = pandaTemplate(complication.family, date: date)
                return entry
            }
        }
    }
}

extension ComplicationTimelineService {
    
    
    
    private func template(_ comp: CLKComplication) -> CLKComplicationTemplate {
        if WatchConfig.watchFaceTimerIndex == 0 {
            return newYearTemplate(comp.family)
        } else {
            return pandaTemplate(comp.family)
        }
    }
    
    private func newYearTemplate(_ family: CLKComplicationFamily) -> CLKComplicationTemplate {
        let textProvider = newYearTextProvider()
        let fraction = Date.fractionToNewYear()
        let gaugeProvider = CLKSimpleGaugeProvider(style: .ring,
                                                   gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                   gaugeColorLocations: [0, 0.5, 1.0],
                                                   fillFraction: fraction)
        
        switch family {
            
        case .circularSmall:
            let tmpl = CLKComplicationTemplateCircularSmallSimpleText()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .extraLarge:
            let tmpl = CLKComplicationTemplateExtraLargeSimpleText()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .graphicBezel:
            let tmpl = CLKComplicationTemplateGraphicBezelCircularText()
            tmpl.textProvider = textProvider
            let circle = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            circle.gaugeProvider = gaugeProvider
            tmpl.circularTemplate = circle
            return tmpl
            
        case .graphicCircular:
            let tmpl = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            tmpl.centerTextProvider = textProvider
            tmpl.gaugeProvider = gaugeProvider
            return tmpl
            
        case .graphicCorner:
            let tmpl = CLKComplicationTemplateGraphicCornerGaugeText()
            tmpl.outerTextProvider = textProvider
            tmpl.gaugeProvider = gaugeProvider
            return tmpl
            
        case .modularLarge:
            let tmpl = CLKComplicationTemplateModularLargeStandardBody()
            tmpl.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            tmpl.headerTextProvider = CLKSimpleTextProvider(text: "Panda info:")
            tmpl.body1TextProvider = textProvider
            tmpl.body2TextProvider = pandaTextProvider()
            return tmpl
            
        case .modularSmall:
            let tmpl = CLKComplicationTemplateModularSmallSimpleText()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .utilitarianLarge:
            let tmpl = CLKComplicationTemplateUtilitarianLargeFlat()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .utilitarianSmall:
            let tmpl = CLKComplicationTemplateUtilitarianSmallRingText()
            tmpl.textProvider = textProvider
            tmpl.fillFraction = fraction
            return tmpl
            
        case .utilitarianSmallFlat:
            let tmpl = CLKComplicationTemplateUtilitarianSmallFlat()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .graphicRectangular:
            fatalError("It's disabled.")
        @unknown default:
            fatalError("Aha")
        }
    }
    
    private func pandaTemplate(_ family: CLKComplicationFamily, date: Date = Date()) -> CLKComplicationTemplate {
        let textProvider = pandaTextProvider()
        let fraction = date.fractionToDate(WatchConfig.pandaAvailable, fullInterval: SharedConstants.rechargeTime)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [UIColor.red, UIColor.orange, UIColor.green],
                                                   gaugeColorLocations: [0, 0.5, 1.0],
                                                   fillFraction: fraction)
        
        let imageProvider: (String) -> CLKImageProvider = { name in
            let image = UIImage(named: "Complication/\(name)")!
            return CLKImageProvider(onePieceImage: image)
        }
        
        switch family {
        case .circularSmall:
            let tmpl = CLKComplicationTemplateCircularSmallRingImage()
            tmpl.fillFraction = fraction
            tmpl.imageProvider = imageProvider("Circular")
            return tmpl
            
        case .extraLarge:
            let tmpl = CLKComplicationTemplateExtraLargeRingImage()
            tmpl.imageProvider = imageProvider("Extra Large")
            tmpl.fillFraction = fraction
            return tmpl
            
        case .graphicBezel:
            let tmpl = CLKComplicationTemplateGraphicBezelCircularText()
            tmpl.textProvider = textProvider
            let circle = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = imageProvider("Graphic Bezel")
                circle.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!, tintedImageProvider: image)
            } else {
                circle.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Bezel")!)
            }
            circle.gaugeProvider = gaugeProvider
            tmpl.circularTemplate = circle
            return tmpl
            
        case .graphicCircular:
            let tmpl = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
            tmpl.centerTextProvider = textProvider
            tmpl.gaugeProvider = gaugeProvider
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Graphic Circular")!)
                tmpl.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!, tintedImageProvider: image)
            } else {
                tmpl.bottomImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
            }
            return tmpl
            
        case .graphicCorner:
            let tmpl = CLKComplicationTemplateGraphicCornerGaugeImage()
            tmpl.gaugeProvider = gaugeProvider
            if #available(watchOSApplicationExtension 6.0, *) {
                let image = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Graphic Corner")!)
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!, tintedImageProvider: image)
            } else {
                tmpl.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            }
            return tmpl
            
        case .modularLarge:
            let tmpl = CLKComplicationTemplateModularLargeStandardBody()
            tmpl.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            tmpl.headerTextProvider = CLKSimpleTextProvider(text: "Panda info:")
            tmpl.body1TextProvider = newYearTextProvider()
            tmpl.body2TextProvider = pandaTextProvider(true)
            return tmpl

        case .modularSmall:
            let tmpl = CLKComplicationTemplateModularSmallRingImage()
            tmpl.fillFraction = fraction
            tmpl.imageProvider = imageProvider("Modular")
            return tmpl
            
        case .utilitarianLarge:
            let tmpl = CLKComplicationTemplateUtilitarianLargeFlat()
            tmpl.textProvider = pandaTextProvider(true)
            return tmpl
            
        case .utilitarianSmall:
            let tmpl = CLKComplicationTemplateUtilitarianSmallRingImage()
            tmpl.imageProvider = imageProvider("Utilitarian")
            tmpl.fillFraction = fraction
            return tmpl
            
        case .utilitarianSmallFlat:
            let tmpl = CLKComplicationTemplateUtilitarianSmallFlat()
            tmpl.textProvider = textProvider
            return tmpl
            
        case .graphicRectangular:
            fatalError("It's disabled.")
        @unknown default:
            fatalError("Aha")
        }
    }
    
    private func pandaTextProvider(_ long: Bool = false) -> CLKSimpleTextProvider {
        let nextPandaDate = WatchConfig.pandaAvailable
        let fraction = Date().fractionToDate(nextPandaDate, fullInterval: SharedConstants.rechargeTime)
        let percent = Int(fraction * 100)
        
        let text = long ? "Panda charge: \(percent)%" : "\(percent)"
        return CLKSimpleTextProvider(text: text, shortText: "\(percent)")
    }
    
    private func newYearTextProvider() -> CLKRelativeDateTextProvider {
        return CLKRelativeDateTextProvider(date: Date.findNewYear()!,
                                           style: .natural,
                                           units: Date.watchFaceUnitsTillNewYear())
    }
}
