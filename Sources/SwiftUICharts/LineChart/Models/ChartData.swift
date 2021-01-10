//
//  ChartData.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class ChartData: ObservableObject {
    
    /// Data model containing the datapoints: Value, Label, Description and Date.
    @Published var dataPoints       : [ChartDataPoint]
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    @Published var metadata         : ChartMetadata?
    
    /// Array of strings for the labels on the X Axis instead of the the dataPoints labels.
    @Published var xAxisLabelArray  : [String]?
    /// Data model conatining the style data for the chart.
    @Published var chartStyle       : ChartStyle
    /// Data model containing the style data for the data point markers.
    @Published var pointStyle       : PointStyle?
    
    /// Array of data to populate the chart legend.
    @Published var legends          : [LegendData]
    /// Data model to hold data about the Views layout.
    @Published var viewData         : ChartViewData
    
    /// ChartData is the central model from which the chart is drawn.
    /// - Parameters:
    ///   - dataPoints: Array of ChartDataPoints.
    ///   - metadata: Data to fill in the metadata box above the chart.
    ///   - xAxisLabelArray: Array of Strings for when there are too many data points to show all xAxisLabels.
    ///   - chartStyle: The parameters for the aesthetic of the chart.
    ///   - pointStyle: The parameters for the aesthetic of the data point markers.
    ///   - useAverage: Display just the average of the data points.
    public init(dataPoints      : [ChartDataPoint],
                metadata        : ChartMetadata? = nil,
                xAxisLabelArray : [String]?      = nil,
                chartStyle      : ChartStyle,
                pointStyle      : PointStyle     = PointStyle(),
                useAverage      : Bool           = false
    ) {
        if !useAverage { self.dataPoints = dataPoints } else {
            self.dataPoints = Helper.monthlyAverage(dataPoints: dataPoints) ?? [ChartDataPoint(value: 0)]
        }
        self.metadata = metadata
        
        self.xAxisLabelArray    = xAxisLabelArray
        self.chartStyle         = chartStyle
        self.pointStyle         = pointStyle
        
        self.legends            = [LegendData]()
        self.viewData           = ChartViewData()
    }
    
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
}

struct Helper {
    /// Get an array of data points converted into and array of data points averaged by their calendar month.
    /// - Parameter dataPoints: Array of ChartDataPoint.
    /// - Returns: Array of ChartDataPoint averaged by their calendar month.
    static func monthlyAverage(dataPoints: [ChartDataPoint]) -> [ChartDataPoint]? {
        let calendar = Calendar.current
        
        let formatterForXAxisLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForXAxisLabel.setLocalizedDateFormatFromTemplate("MMM")
        let formatterForPointLabel      = DateFormatter()
        formatterForXAxisLabel.locale   = .current
        formatterForPointLabel.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        
        guard let firstDataPoint = dataPoints.first?.date else { return nil }
        guard let lastDataPoint  = dataPoints.last?.date else { return nil }
        
        guard let numberOfMonths = calendar.dateComponents([.month],
                                                           from: firstDataPoint,
                                                           to: lastDataPoint).month else { return nil }
        var outputData : [ChartDataPoint] = []
        for index in 0...numberOfMonths {
            if let date = calendar.date(byAdding: .month, value: index, to: firstDataPoint) {
                
                let requestedMonth = calendar.dateComponents([.year, .month], from: date)

                let monthOfData = dataPoints.filter { (dataPoint) -> Bool in
                    let month = calendar.dateComponents([.year, .month], from:  dataPoint.date ?? Date())
                    return month == requestedMonth
                }
                let sum = monthOfData.reduce(0) { $0 + $1.value }
                let average = sum / Double(monthOfData.count)

                outputData.append(ChartDataPoint(value: average,
                                                 xAxisLabel: formatterForXAxisLabel.string(from: date),
                                                 pointLabel: formatterForPointLabel.string(from: date)))
            }
        }
        return outputData
    }
}
