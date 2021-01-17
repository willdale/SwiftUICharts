//
//  ChartData.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class ChartData: ObservableObject, Identifiable {
    
    public let id = UUID()
    
    /// Data model containing the datapoints: Value, Label, Description and Date. Individual colouring for bar chart.
    @Published public var dataPoints    : [ChartDataPoint]
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    @Published public var metadata      : ChartMetadata?
    
    /// Array of strings for the labels on the X Axis instead of the the dataPoints labels.
    @Published public var xAxisLabels   : [String]?
    
    /// Data model conatining the style data for the chart.
    @Published public var chartStyle    : ChartStyle
    /// Data model conatining the style data for the line chart.
    @Published public var lineStyle     : LineStyle
    /// Data model conatining the style data for the line chart.
    @Published public var barStyle      : BarStyle
    /// Data model containing the style data for the data point markers.
    @Published public var pointStyle    : PointStyle
        
    /// Array of data to populate the chart legend.
    @Published var legends  : [LegendData]
    /// Data model to hold data about the Views layout.
    @Published var viewData : ChartViewData
    
    public var noDataText   : Text = Text("No Data")
    
    var isGreaterThanTwo: Bool = true
        
    // MARK: - init: Calculations
    /// ChartData is the central model from which the chart is drawn.
    /// - Parameters:
    ///   - dataPoints: Array of ChartDataPoints.
    ///   - metadata: Data to fill in the metadata box above the chart.
    ///   - xAxisLabels: Array of Strings for when there are too many data points to show all xAxisLabels.
    ///   - chartStyle : The parameters for the aesthetic of the chart.
    ///   - lineStyle: The parameters for the aesthetic of the line chart.
    ///   - barStyle: The parameters for the aesthetic of the bar chart.
    ///   - pointStyle: The parameters for the aesthetic of the data point markers.
    ///   - calculations: Choose whether to perform calculations on the data points. If so then by what means.
    public init(dataPoints  : [ChartDataPoint],
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : ChartStyle        = ChartStyle(),
                lineStyle   : LineStyle         = LineStyle(),
                barStyle    : BarStyle          = BarStyle(),
                pointStyle  : PointStyle        = PointStyle(),
                calculations: CalculationType   = .none
    ) {
        switch calculations {
        case .none:
            self.dataPoints = dataPoints
        case .averageMonth:
            self.dataPoints = Calculations.monthlyAverage(dataPoints: dataPoints) ?? [ChartDataPoint(value: 0)]
        case .averageWeek:
            self.dataPoints = Calculations.weeklyAverage(dataPoints: dataPoints) ?? [ChartDataPoint(value: 0)]
        case .averageDay:
            self.dataPoints = Calculations.dailyAverage(dataPoints: dataPoints) ?? [ChartDataPoint(value: 0)]
        }

        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.lineStyle      = lineStyle
        self.barStyle       = barStyle
        self.pointStyle     = pointStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        
        greaterThanTwo()
    }
    
    // MARK: - init: Custom Calculations
    /// ChartData is the central model from which the chart is drawn. This init has the option to add
    /// - Parameters:
    ///   - dataPoints: Array of ChartDataPoints.
    ///   - metadata: Data to fill in the metadata box above the chart.
    ///   - xAxisLabels: Array of Strings for when there are too many data points to show all xAxisLabels.
    ///   - chartStyle : The parameters for the aesthetic of the chart.
    ///   - lineStyle: The parameters for the aesthetic of the line chart.
    ///   - barStyle: The parameters for the aesthetic of the bar chart.
    ///   - pointStyle: The parameters for the aesthetic of the data point markers.
    ///   - customCalc: Allows for custom calculations to be performed on the input data points before the chart is drawn custom calculations.
    public init(dataPoints  : [ChartDataPoint],
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : ChartStyle        = ChartStyle(),
                lineStyle   : LineStyle         = LineStyle(),
                barStyle    : BarStyle          = BarStyle(),
                pointStyle  : PointStyle        = PointStyle(),
                customCalc  : @escaping ([ChartDataPoint]) -> [ChartDataPoint]?
    ) {
        self.dataPoints     = customCalc(dataPoints) ?? [ChartDataPoint(value: 0)]
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.lineStyle      = lineStyle
        self.barStyle       = barStyle
        self.pointStyle     = pointStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        
        greaterThanTwo()
    }
    
    // MARK: - Functions
    /// Get the highest value from dataPoints array.
    /// - Returns: Highest value.
    func maxValue() -> Double {
        return dataPoints.max { $0.value < $1.value }?.value ?? 0
    }
    /// Get the Lowest value from dataPoints array.
    /// - Returns: Lowest value.
    func minValue() -> Double {
        return dataPoints.min { $0.value < $1.value }?.value ?? 0
    }
    /// Get the average of all the dataPoints.
    /// - Returns: Average.
    func average() -> Double {
        let sum = dataPoints.reduce(0) { $0 + $1.value }
        return sum / Double(dataPoints.count)
    }
    /// Get the difference between the hightest and lowest value in the dataPoints array.
    /// - Returns: Difference.
    func range() -> Double {
        let maxValue = dataPoints.max { $0.value < $1.value }?.value ?? 0
        let minValue = dataPoints.min { $0.value < $1.value }?.value ?? 0
        
        /*
         Adding 0.001 stops the following error if there is no variation in value of the dataPoints
         2021-01-07 13:59:50.490962+0000 LineChart[4519:237208] [Unknown process name] Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
         */
        return (maxValue - minValue) + 0.001
    }
    func greaterThanTwo() {
        self.isGreaterThanTwo = dataPoints.count > 2
    }
    
    /// Sets the order the Legends are layed out in.
    /// - Returns: Ordered array of Legends.
    func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}



