//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers<T>: ViewModifier where T: LineAndBarChartData & LineChartProtocol {
        
    @ObservedObject var chartData: T
        
    private let maxValue : Double
    private let minValue : Double
    private let range    : Double
    
    internal init(chartData : T) {
        self.chartData  = chartData
        
        self.maxValue   = chartData.getMaxValue()
        self.minValue   = chartData.getMinValue()
        self.range      = chartData.getRange()
    }
    internal func body(content: Content) -> some View {
        
        ZStack {
            content
            if chartData.chartType.dataSetType == .single {
                
                let data = chartData as! LineChartData
                PointsSubView(dataSets: data.dataSets, maxValue: maxValue, minValue: minValue, range: range)
                
            } else if chartData.chartType.dataSetType == .multi {
                
                let data = chartData as! MultiLineChartData
                ForEach(data.dataSets.dataSets, id: \.self) { dataSet in
//                    if chartData.isGreaterThanTwo {
                    PointsSubView(dataSets: dataSet, maxValue: maxValue, minValue: minValue, range: range)
//                    }
                }
            }
        }
    }
}

extension View {
    /// Lays out markers over each of the data point.
    ///
    /// The style of the markers is set in the PointStyle data model as parameter in ChartData
    public func pointMarkers<T: LineAndBarChartData & LineChartProtocol>(chartData: T) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}

struct PointsSubView: View {
    
    let dataSets: LineDataSet
    let maxValue : Double
    let minValue : Double
    let range    : Double
    
    var body: some View {
        switch dataSets.pointStyle.pointType {
        case .filled:
            Point(dataSet   : dataSets,
                  maxValue  : maxValue,
                  minValue  : minValue,
                  range     : range)
                .fill(dataSets.pointStyle.fillColour)
        case .outline:
            Point(dataSet   : dataSets,
                  maxValue  : maxValue,
                  minValue  : minValue,
                  range     : range)
                .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
        case .filledOutLine:
            Point(dataSet   : dataSets,
                  maxValue  : maxValue,
                  minValue  : minValue,
                  range     : range)
                .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                .background(Point(dataSet   : dataSets,
                                  maxValue  : maxValue,
                                  minValue  : minValue,
                                  range     : range)
                                .foregroundColor(dataSets.pointStyle.fillColour)
                )
        }
    }
    
}
