//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers<T>: ViewModifier where T: LineChartDataProtocol {
        
    @ObservedObject var chartData: T
        
    private let minValue : Double
    private let range    : Double
    
    internal init(chartData : T) {
        self.chartData  = chartData
        
        switch chartData.chartStyle.baseline {
        case .minimumValue:
            self.minValue = chartData.getMinValue()
            self.range    = chartData.getRange()
        case .zero:
            self.minValue = 0
            self.range    = chartData.getMaxValue()
        }
        
        
    }
    internal func body(content: Content) -> some View {
        ZStack {
            content
            if chartData.chartType.dataSetType == .single {
                
                let data = chartData as! LineChartData
                PointsSubView(dataSets: data.dataSets, minValue: minValue, range: range)
                
            } else if chartData.chartType.dataSetType == .multi {
                
                let data = chartData as! MultiLineChartData
                ForEach(data.dataSets.dataSets, id: \.self) { dataSet in
                    PointsSubView(dataSets: dataSet, minValue: minValue, range: range)
                }
            }
        }
    }
}

extension View {
    /// Lays out markers over each of the data point.
    ///
    /// The style of the markers is set in the PointStyle data model as parameter in ChartData
    public func pointMarkers<T: LineChartDataProtocol>(chartData: T) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}

struct PointsSubView: View {
    
    let dataSets: LineDataSet
    let minValue : Double
    let range    : Double
    
    var body: some View {
        switch dataSets.pointStyle.pointType {
        case .filled:
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .fill(dataSets.pointStyle.fillColour)
        case .outline:
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
        case .filledOutLine:
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                .background(Point(dataSet   : dataSets,
                                  minValue  : minValue,
                                  range     : range)
                                .foregroundColor(dataSets.pointStyle.fillColour)
                )
        }
    }
    
}
