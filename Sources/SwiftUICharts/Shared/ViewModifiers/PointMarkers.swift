//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

//internal struct PointMarkers<T>: ViewModifier where T: ChartData {
//        
//    @ObservedObject var chartData: T
//    
//    private let maxValue : Double
//    private let minValue : Double
//    private let range    : Double
//    
//    internal init(chartData : T) {
//        self.chartData  = chartData
//        self.maxValue   = DataFunctions.dataSetMaxValue(from: chartData.dataSets)
//        self.minValue   = DataFunctions.dataSetMinValue(from: chartData.dataSets)
//        self.range      = DataFunctions.dataSetRange(from: chartData.dataSets)
//    }
//    internal func body(content: Content) -> some View {
//        
//        ZStack {
//            content
//            ForEach(chartData.dataSets, id: \.self) { dataSet in
////            if chartData.isGreaterThanTwo {
//                switch dataSet.pointStyle.pointType {
//                case .filled:
//                    Point(dataSet   : dataSet,
//                          pointSize : dataSet.pointStyle.pointSize,
//                          pointType : dataSet.pointStyle.pointShape,
//                          chartType : chartData.viewData.chartType,
//                          maxValue  : maxValue,
//                          minValue  : minValue,
//                          range     : range)
//                        .fill(dataSet.pointStyle.fillColour)
//                case .outline: Text("")
//                    Point(dataSet   : dataSet,
//                          pointSize : dataSet.pointStyle.pointSize,
//                          pointType : dataSet.pointStyle.pointShape,
//                          chartType : chartData.viewData.chartType,
//                          maxValue  : maxValue,
//                          minValue  : minValue,
//                          range     : range)
//                        .stroke(dataSet.pointStyle.borderColour, lineWidth: dataSet.pointStyle.lineWidth)
//                case .filledOutLine: Text("")
//                    Point(dataSet   : dataSet,
//                          pointSize : dataSet.pointStyle.pointSize,
//                          pointType : dataSet.pointStyle.pointShape,
//                          chartType : chartData.viewData.chartType,
//                          maxValue  : maxValue,
//                          minValue  : minValue,
//                          range     : range)
//                        .stroke(dataSet.pointStyle.borderColour, lineWidth: dataSet.pointStyle.lineWidth)
//                        .background(Point(dataSet   : dataSet,
//                                          pointSize : dataSet.pointStyle.pointSize,
//                                          pointType : dataSet.pointStyle.pointShape,
//                                          chartType : chartData.viewData.chartType,
//                                          maxValue  : maxValue,
//                                          minValue  : minValue,
//                                          range     : range)
//                                        .foregroundColor(dataSet.pointStyle.fillColour)
//                        )
//                }
////            }
//            }
//        }
//    }
//}
//extension View {
//    /// Lays out markers over each of the data point.
//    ///
//    /// The style of the markers is set in the PointStyle data model as parameter in ChartData
//    public func pointMarkers<T: ChartData>(chartData: T) -> some View {
//        self.modifier(PointMarkers(chartData: chartData))
//    }
//}
