//
//  JFIndex.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 27/06/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

private let kWeekDaysCount = 7
private let kMonthDaysCount = 31
private let kYearDataPointCount = 365

enum JFIndexMultiplierType: Int, Codable {
    case jfIndex, friendly, dressing, iqLevel, communication, personality, behavior, cleanliness, punctuality, appearance
    
    var graphLineColor: UIColor {
        switch self {
        case .jfIndex: return .jfChooseWordsBlack
        case .friendly: return .friendly
        case .dressing: return .dressing
        case .iqLevel: return .iQLevel
        case .communication: return .talktive
        case .personality: return .personality
        case .behavior: return .height
        case .cleanliness: return .clean
        case .punctuality: return .punctuanlity
        case .appearance: return .appearance
        }
    }
    
    var graphLineWidth: CGFloat {
        switch self {
        case .jfIndex: return 3
        default: return 2
        }
    }
    
    var indexUI: (icon: UIImage, text: String) {
        switch self {
        case .friendly: return ( #imageLiteral(resourceName: "personality_icon_lightred"), "friendly")
        case .dressing: return ( #imageLiteral(resourceName: "dressing"), "dressing")
        case .iqLevel: return ( #imageLiteral(resourceName: "intelligence_bulb_icon_lightblue"), "iqLevel")
        case .communication: return ( #imageLiteral(resourceName: "talkative"), "communication")
        case .personality: return ( #imageLiteral(resourceName: "appearance_icon_yellow"), "personality")
        case .behavior: return ( #imageLiteral(resourceName: "personality_icon_lightred"), "behavior")
        case .cleanliness: return ( #imageLiteral(resourceName: "cleanliness"), "cleanliness")
        case .punctuality: return ( #imageLiteral(resourceName: "punctual"), "puctuality")
        case .appearance: return ( #imageLiteral(resourceName: "personality_icon_lightred"), "appearance")
        default:
            return (UIImage(), "")
        }
    }
}

class JFIndexInfo: Codable {
    private var value: Double = 0
    var multiplier: Double = 0
    private var rateOfChange: Double = 0
    
    var graphData: JFGraph?
    
    init() {
        value = 0.0
        multiplier = 0.0
        rateOfChange = 0.0
    }
    
    convenience init(withJFIndex jfIndexValue: Double?, jfMultiplier: Double?, jfRateOfChange: Double?) {
        self.init()
        
        value = jfIndexValue ?? 0.0
        multiplier = jfMultiplier ?? 0.0
        rateOfChange = jfRateOfChange ?? 0.0
    }
    
    var rateOFChangeString: String {
        let roundedOffValue = rateOfChange.rounded(toPlaces: 2)
        return "\(roundedOffValue > 0 ? "+" : "")\(roundedOffValue)%"
    }
    
    var indexValue: String {
        let jfimValue = (graphData?.values.last ?? value).rounded()
        
        return "\(Int(jfimValue))".leftPadding(toLength: 4, withPad: "0")
    }
    
    var jfimValue: String {
        let jfim = (graphData?.values.last ?? (value * multiplier)).rounded()
        
        return "\(Int(jfim))".leftPadding(toLength: 4, withPad: "0")
    }
}

class JFGraph: Codable {
    var type: JFIndexMultiplierType
    var values: [Double]
    var timelineDataPointsCount = 0
    lazy var recentProcessingDate = Date()
    lazy var originProcessingDate = Date()
    
    init(with graph_type: JFIndexMultiplierType, data_points: [Double], recent_processing_date: Date, origin_processing_date: Date) {
        type = graph_type
        values = [Double](repeating: 0.0, count: kYearDataPointCount)
        recentProcessingDate = recent_processing_date
        originProcessingDate = origin_processing_date
        
        let dataPointToProcess = data_points.suffix(kYearDataPointCount).reversed()
        
        for i in dataPointToProcess.enumerated() {
            values[(kYearDataPointCount - 1) - i.offset] = i.element
        }
        
        timelineDataPointsCount = dataPointToProcess.count
    }
    
    var weekData: [Double] {
        var lastWeekData = Array(values.suffix(kWeekDaysCount))
        lastWeekData.append(lastWeekData.last!)
        return lastWeekData
    }
    
    var monthData: [Double] {
        var lastMonthData = Array(values.suffix(kMonthDaysCount))
        lastMonthData.append(lastMonthData.last!)
        return lastMonthData
    }
    
    var yearData: [Double] {
        var yearValues = [Double]()
        for y : Int in stride(from: 1, to: kYearDataPointCount, by: 30) {
            yearValues.append(values[y])
        }
        
        return yearValues
    }
    
    var graphDataTimeline: [Double] {
        var timelineDataPoints = Array(values.suffix(timelineDataPointsCount))
        timelineDataPoints.append(timelineDataPoints.last!)
        return timelineDataPoints
    }
    
    func getDataPoints(for type: JFGraphXValueType) -> [Double] {
        switch type {
        case .month:
            return monthData
        case .week:
            return weekData
        case .year:
            return yearData
        case .graphDataTimeline:
            return graphDataTimeline
        }
    }
}
