//
//  JFGraphCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum GraphCellState {
    case noData, loading, graphLoaded
}

enum JFGraphXValueType: Int {
    case week = 1, month, graphDataTimeline, year
    
    static var titles: [String] {
        return ["Week", "Month", "Year"]
    }
    
    var maxXValue: Double {
        
        switch self {
        case .month:
            return 30
        case .week:
            return 7
        case .year:
            return 12
        case .graphDataTimeline:
            return 365
        }
    }
}


class JFGraphCustomCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var graphValueIndicatorLabel: UILabel!
    @IBOutlet weak var jfIndexLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataSubtitleLabel: UILabel!
    @IBOutlet weak var jfPercentageLabel: JFPercentageLabel!
    @IBOutlet weak var jfGraphChart: Chart!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var xAxisLineView: UIView!
    @IBOutlet weak var yAxisLineView: UIView!
    @IBOutlet weak var emptyLabelContainerView: UIView!
    @IBOutlet weak var durationSegmentedControl: XMSegmentedControl!
    @IBOutlet weak var graphValueIndicatorLeadingConstraint: NSLayoutConstraint!

    //MARK:- Private properties
    private var selectedGraphDuration = JFGraphXValueType.week
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    //MARK:- Public properties
    var graphDataArray: [JFGraph]!
    
    //MARK:- Computed properties
    var cellState: GraphCellState = .loading {
        didSet {
            switch cellState {
            case .noData:
                emptyView.isHidden = false
                jfGraphChart.isHidden = true
                durationSegmentedControl.isHidden = true
                xAxisLineView.isHidden = true
                yAxisLineView.isHidden = true
                noDataSubtitleLabel.isHidden = false
                noDataLabel.text = "No Data Yet"
                
            case .graphLoaded:
                emptyView.isHidden = true
                jfGraphChart.isHidden = false
                durationSegmentedControl.isHidden = false
                xAxisLineView.isHidden = false
                yAxisLineView.isHidden = false
                
            case .loading:
                emptyView.isHidden = false
                jfGraphChart.isHidden = true
                durationSegmentedControl.isHidden = true
                xAxisLineView.isHidden = true
                yAxisLineView.isHidden = true
                noDataSubtitleLabel.isHidden = true
                noDataLabel.text = "Loading Graph..."
            }
            
        }
    }
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureChart()
        configureSegmentedView()
        labelLeadingMarginInitialConstant = graphValueIndicatorLeadingConstraint.constant
    }
    
    //MARK:- Helper methods
    func configureChart() {
        jfGraphChart.gridColor = .clear
        jfGraphChart.axesColor = .clear
        jfGraphChart.highlightLineWidth = 1
        jfGraphChart.bottomInset = 40
        jfGraphChart.delegate = self
        jfGraphChart.minX = 0
        jfGraphChart.minY = 0
        jfGraphChart.highlightLineColor = UIColor.jfDarkGray
    }
    
    func configureChartParameters() {
        jfGraphChart.lineWidth = 3
        jfGraphChart.maxX = selectedGraphDuration == .graphDataTimeline ? Double(self.graphDataArray.first?.timelineDataPointsCount ?? 1) : selectedGraphDuration.maxXValue
        jfGraphChart.maxY = graphDataArray.map({$0.getDataPoints(for: selectedGraphDuration).max() ?? 0}).max() ?? 50
        
        let midY = ceil((jfGraphChart.maxY ?? 0.0) / 2)
        let endY = ceil(jfGraphChart.maxY ?? 0.0)
        
        jfGraphChart.yLabels = [1, midY, endY]
        jfGraphChart.yLabelsFormatter = {" \(Int($1))"}
        
        jfGraphChart.xLabels = xLabels().0
        jfGraphChart.xLabelsFormatter =  { String(Int(round($1))).clear + "\(self.xLabels().1[$0])" }
    }
    
    func configureSegmentedView() {
        durationSegmentedControl.contentType = .text
        durationSegmentedControl.selectedItemHighlightStyle = .bottomEdge
        durationSegmentedControl.segmentTitle = JFGraphXValueType.titles
        durationSegmentedControl.backgroundColor = UIColor.clear
        durationSegmentedControl.highlightTint = .jfDarkBrown
        durationSegmentedControl.highlightColor = .jfDarkBrown
        durationSegmentedControl.tint = .jfLightBrown
        durationSegmentedControl.delegate = self
    }
    
    func xLabels() -> ([Double], [String]) {
        switch selectedGraphDuration {
        case .week:
            let weekXLabels = getxAxisWeekDayLabels()
            return ( Array(0 ..< 7).map({Double($0)}), weekXLabels)
        case .month:
            let monthXLabels = getxAxisMonthLabels()
            return ( [0, 4, 8, 12, 16, 20, 24].map({Double($0)}), monthXLabels)
        case .year:
            return ( [0, 3, 6, 9].map({Double($0)}), getxAxisYearLabels())
        case .graphDataTimeline:
            let maxTimeline = Double(self.graphDataArray.first?.timelineDataPointsCount ?? 365) * 0.7
            return ( [0, maxTimeline].map({Double($0)}), getxAxisTimelineLabels())
        }
    }
    
    func getxAxisWeekDayLabels() -> [String] {
        let xlabels = ["S", "M", "T", "W", "T", "F", "S"]
        
        guard let processingDate = self.graphDataArray.first?.recentProcessingDate else {return xlabels}
        guard let currentDayNumber = processingDate.component(.weekday) else {return xlabels}
        
        return xlabels.shift(withDistance: currentDayNumber)
    }
    
    func getxAxisMonthLabels() -> [String] {
         let defaultXLabels = ["5","10","15","20","25","30", "4"]
        guard let processingDate = self.graphDataArray.first?.recentProcessingDate else {return defaultXLabels}
        let numberOfDayInMonth = processingDate.numberOfDaysInMonth()
        var currentDay = processingDate.component(.day) ?? 1
        
        var xLabelValues = [currentDay]
        
        for _ in 0..<6 {
            currentDay += 4
            xLabelValues.append( currentDay % numberOfDayInMonth )
        }
        
        let xlabelsString = xLabelValues.shift(withDistance: 1).map{"\($0)"}
        print(xlabelsString)
        return xlabelsString
    }
    
    func getxAxisYearLabels() -> [String] {
        let defaultXLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        guard let processingDate = self.graphDataArray.first?.recentProcessingDate else {return defaultXLabels}
        var currentMonth = (processingDate.component(.month) ?? 1) - 1
        
        var xLabelValues = [currentMonth]
        
        for _ in 0..<3 {
            currentMonth += 3
            xLabelValues.append( ((currentMonth) % 12) )
        }
        
        let xlabelsString = xLabelValues.shift(withDistance: 1).map({defaultXLabels[$0]})
        print(xLabelValues)
        print(xlabelsString)
        return xlabelsString
    }
    
    func getxAxisTimelineLabels() -> [String] {
        let recentDateString = self.graphDataArray.first?.recentProcessingDate.toString(format: DateFormatType.custom("MMM d, yyyy")) ?? ""
        let originDateString = self.graphDataArray.first?.originProcessingDate.toString(format: DateFormatType.custom("MMM d, yyyy")) ?? ""
        
        return [originDateString, recentDateString]
    }
    
    func reloadGraph() {
        jfGraphChart.removeAllSeries()
        
        if graphDataArray.count > 1 {
            graphDataArray = graphDataArray.filter({$0.type != .jfIndex})
        }
        
        configureChartParameters()
        
        // Indicator Clear label
        graphValueIndicatorLabel.attributedText = NSAttributedString(string: "")
        
        var seriesToAdd = [ChartSeries]()
        
        for aGraph in graphDataArray {
            let seriesValues = aGraph.getDataPoints(for: selectedGraphDuration).enumerated().map({(x: Double($0.offset), y: $0.element)})
            let series = ChartSeries(data: seriesValues)
            series.color = aGraph.type.graphLineColor
            jfGraphChart.lineWidth = aGraph.type.graphLineWidth
            seriesToAdd.append(series)
        }
     
        jfGraphChart.add(seriesToAdd)
    }
    
    func updateCellState() {
        let hasData = graphDataArray.flatMap({$0.values}).filter({$0 > 0}).count > 0
        cellState = hasData ? .graphLoaded : .noData
    }
    
    func configure(with profileInfo: ProfileInfo, types: [JFIndexMultiplierType]) {
        graphDataArray = profileInfo.graphData.filter({ types.contains($0.type)})
        
        let hasData = graphDataArray.flatMap({$0.values}).filter({$0 > 0}).count > 0
        cellState = hasData ? .graphLoaded : .loading
        
        jfIndexLabel.text = profileInfo.indexMultiplier(forType: .jfIndex)?.jfimValue ?? "0000"
        jfPercentageLabel.text = profileInfo.indexMultiplier(forType: .jfIndex)?.rateOFChangeString ?? ""
        reloadGraph()
        
        if profileInfo.graphLoaded {
            updateCellState()
        }
    }
    
    func configure(with userPrfoile: JFProfile, types: [JFIndexMultiplierType]) {
        cellState = .loading
        self.graphDataArray = userPrfoile.graphData.filter({ types.contains($0.type)})
        self.jfIndexLabel.text = userPrfoile.indexMultiplier(forType: .jfIndex)?.jfimValue ?? "0000"
        self.jfPercentageLabel.text = userPrfoile.indexMultiplier(forType: .jfIndex)?.rateOFChangeString ?? ""
        reloadGraph()
        
        if userPrfoile.graphLoaded {
            updateCellState()
        }
    }
}

//MARK:- ChartDelegate
extension JFGraphCustomCell: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        print("indexes are \(indexes)")
        
        if indexes.filter({$0 == nil}).count > 0 {
            return
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        let value: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        for aCharData in self.graphDataArray.enumerated() {
            let chartPoint = aCharData.element.getDataPoints(for: selectedGraphDuration)[safe: indexes[aCharData.offset]!]
            var extendedValue = "\(Int(chartPoint?.rounded() ?? -1.0))"
            
            if aCharData.offset < self.graphDataArray.count - 1 {
                extendedValue += ", "
            }
            
            let extendedAttributesString = NSAttributedString(string: extendedValue, attributes: [.foregroundColor : aCharData.element.type.graphLineColor, .font: UIFont.semiBold(fontSize: 12)])
            
            value.append(extendedAttributesString)
        }
        
        graphValueIndicatorLabel.attributedText = value
        
        // Align the label to the touch left position, centered
        var constant = labelLeadingMarginInitialConstant + left - (graphValueIndicatorLabel.frame.width / 2)
        
        // Avoid placing the label on the left of the chart
        if constant < labelLeadingMarginInitialConstant {
            constant = labelLeadingMarginInitialConstant
        }
        
        // Avoid placing the label on the right of the chart
        let rightMargin = chart.frame.width - graphValueIndicatorLabel.frame.width
        if constant > rightMargin {
            constant = rightMargin
        }
        
        graphValueIndicatorLeadingConstraint.constant = constant
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        print(#function)
        graphValueIndicatorLabel.attributedText = NSAttributedString(string: "")
        graphValueIndicatorLeadingConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        print(#function)
    }
    
}

//MARK:- XMSegmentedControlDelegate
extension JFGraphCustomCell: XMSegmentedControlDelegate {

    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        
        if let type = JFGraphXValueType(rawValue: selectedSegment + 1) {
            selectedGraphDuration = type
            reloadGraph()
        }
    }
}

