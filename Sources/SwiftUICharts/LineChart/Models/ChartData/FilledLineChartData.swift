//
//  FilledLineChartData.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI
import Combine
import ChartMath


/// Data for drawing and styling a single line, line chart.
///
/// This model contains the data and styling information for a single line, line chart.
public final class FilledLineChartData: CTChartData, Publishable, Touchable {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: FilledLineDataSet
    public var disableAnimation = false
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .filledLine
    
    public var markerData = MarkerData()
    
    // MARK: Publishable
    public var touchedData = TouchedData<DataPoint>()
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Initializer
    
    /// Initialises a Single Line Chart
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart
    ///   - baseline: Lowest point of the chart
    ///   - topLine: Highest point on the chart
    public init(
        dataSets: FilledLineDataSet,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
    }    
    
    internal func range() -> Double {
        let (minValue, maxValue) = ChartMath.minAndMaxValue(dataPoints: dataSets.dataPoints)
        return ChartMath.calculateRange(baseline: self.baseline, topLine: self.topLine, minValue: minValue, maxValue: maxValue)
    }

    // MARK: Touch
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        
        let (minValue, maxValue) = ChartMath.minAndMaxValue(dataPoints: dataSets.dataPoints)
        let range = ChartMath.calculateRange(baseline: self.baseline, topLine: self.topLine, minValue: minValue, maxValue: maxValue)
        
        let xSection = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection = chartSize.height / CGFloat(range)
        
        let index = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
                let location = CGPoint(x: CGFloat(index) * xSection,
                                       y: (CGFloat(datapoint.value - minValue) * -ySection) + chartSize.height)
                values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
        }
        markerData = MarkerData(lineMarkerData: values.map {
            return LineMarkerData(markerType: dataSets.markerType,
                                  location: $0.location,
                                  dataPoints: dataSets.dataPoints,
                                  lineType: dataSets.style.lineType,
                                  lineSpacing: .line,
                                  minValue: minValue,
                                  range: range)
        })
    }
    
    public func touchDidFinish() {
        touchedData.touchPointData = []
    }
    
    public typealias SetType = FilledLineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias Marker = LineMarkerType
}
