//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI
import Combine
import ChartMath

/// Data for drawing and styling a multi line, line chart.
///
/// This model contains all the data and styling information for a single line, line chart.
public final class MultiLineChartData: CTChartData, Publishable, Touchable {
    
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: MultiLineDataSet
    public var disableAnimation = false
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .multiLine
    
    public var markerData = MarkerData()
    
    // MARK: Publishable
    public var touchedData = TouchedData<DataPoint>()
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Initializers
    /// Initialises a Multi Line Chart
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart
    ///   - baseline: Lowest point of the chart
    ///   - topLine: Highest point on the chart
    public init(
        dataSets: MultiLineDataSet,
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
        let (minValue, maxValue) = ChartMath.minAndMaxValue(dataPoints: dataSets.dataSets.map(\.dataPoints))
        return ChartMath.calculateRange(baseline: self.baseline, topLine: self.topLine, minValue: minValue, maxValue: maxValue)
    }

    // MARK: Touch
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        let data: [PublishedTouchData<LineChartDataPoint>] = dataSets.dataSets.compactMap { dataSet in
            let (minValue, maxValue) = ChartMath.minAndMaxValue(dataPoints: dataSet.dataPoints)
            let range = ChartMath.calculateRange(baseline: self.baseline, topLine: self.topLine, minValue: minValue, maxValue: maxValue)
            
            let xSection = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection = chartSize.height / CGFloat(range)
            let index = Int((touchLocation.x + (xSection / 2)) / xSection)
            
            var location: CGPoint = .zero
            var datapoint: LineChartDataPoint = LineChartDataPoint(value: 0)
            
            if index >= 0 && index < dataSet.dataPoints.count {
                if !dataSet.dataPoints[index].ignore {
                    location = CGPoint(x: CGFloat(index) * xSection,
                                       y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                    datapoint = dataSet.dataPoints[index]
                } else {
                    return nil
                }
            }
            return PublishedTouchData(datapoint: datapoint, location: location, type: .line)
        }
        
        values.append(contentsOf: data)
        
        let (minValue, maxValue) = ChartMath.minAndMaxValue(dataPoints: dataSets.dataSets.map(\.dataPoints))
        let range = ChartMath.calculateRange(baseline: self.baseline, topLine: self.topLine, minValue: minValue, maxValue: maxValue)
        
        var lineMarkerData: [LineMarkerData] = []
        values.forEach { data in
            let location = data.location
            let lineData = self.dataSets.dataSets.compactMap { dataSet in
                return LineMarkerData(markerType: dataSet.markerType,
                                      location: location,
                                      dataPoints: dataSet.dataPoints,
                                      lineType: dataSet.style.lineType,
                                      lineSpacing: .line,
                                      minValue: minValue,
                                      range: range)
            }
            lineMarkerData.append(contentsOf: lineData)
            markerData = MarkerData(lineMarkerData: lineMarkerData)
        }
    }
    
    public func touchDidFinish() {
        touchedData.touchPointData = []
    }
    
    // MARK: Accessibility
    public func getAccessibility() -> some View {
        ForEach(self.dataSets.dataSets, id: \.self) { dataSet in
            ForEach(dataSet.dataPoints.indices, id: \.self) { point in
                AccessibilityRectangle(dataPointCount: dataSet.dataPoints.count,
                                       dataPointNo: point)
                    .foregroundColor(Color(.gray).opacity(0.000000001))
                    .accessibilityLabel(self.accessibilityTitle)
            }
        }
    }
    
    public typealias SetType = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias Marker = LineMarkerType
}
