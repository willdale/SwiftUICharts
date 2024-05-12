//
//  RangedLineChartData.swift
//  
//
//  Created by Will Dale on 01/03/2021.
//

import SwiftUI
import Combine
import ChartMath

/// Data for drawing and styling ranged line chart.
///
/// This model contains the data and styling information for a ranged line chart.
public final class RangedLineChartData: CTChartData, Publishable, Touchable {
    // MARK: Properties
    public let id: UUID  = UUID()
    @Published public var dataSets: RangedLineDataSet
    public var disableAnimation = false
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .rangedLine
    
    public var markerData = MarkerData()
    
    // MARK: Publishable
    public var touchedData = TouchedData<DataPoint>()
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Initializer
    
    /// Initialises a ranged line chart
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart
    ///   - baseline: Lowest point of the chart
    ///   - topLine: Highest point on the chart
    public init(
        dataSets: RangedLineDataSet,
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
            var location: CGPoint = .zero
            if !dataSets.style.ignoreZero {
                location = CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(dataSets.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
            } else {
                if dataSets.dataPoints[index].value != 0 {
                    location = CGPoint(x: CGFloat(index) * xSection,
                                       y: (CGFloat(dataSets.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                }
            }
            
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .line))
        }
        markerData = MarkerData(lineMarkerData: values.map {
            return LineMarkerData(markerType: dataSets.markerType,
                                  location: $0.location,
                                  dataPoints: dataSets.dataPoints.map { LineChartDataPoint($0) },
                                  lineType: dataSets.style.lineType,
                                  lineSpacing: .line,
                                  minValue: minValue,
                                  range: range)
        })
    }
    
    public func touchDidFinish() {
        touchedData.touchPointData = []
    }
    
    public typealias SetType = RangedLineDataSet
    public typealias DataPoint = RangedLineChartDataPoint
    public typealias MarkerType = LineMarkerType
}
