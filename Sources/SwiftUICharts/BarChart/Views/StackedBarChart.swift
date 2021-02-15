////
////  StackedBarChart.swift
////  
////
////  Created by Will Dale on 12/02/2021.
////
//
//import SwiftUI
//
//
//public struct StackedBarChart<ChartData>: View where ChartData: StackedBarChartData {
//    
//    @ObservedObject var chartData: ChartData
//            
//    public init(chartData: ChartData) {
//        self.chartData = chartData
//    }
//    
//    @State private var startAnimation : Bool = false
//    
//    public var body: some View {
//                
//        if chartData.isGreaterThanTwo() {
//            
//            HStack(alignment: .bottom, spacing: 0) {
//                ForEach(chartData.dataSets.dataSets) { dataSet in
//                    
//                    MultiPartBarSubView(dataSet: dataSet)
//                        .scaleEffect(y: startAnimation ? CGFloat(DataFunctions.dataSetMaxValue(from: dataSet) / chartData.getMaxValue()) : 0, anchor: .bottom)
//                        .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
//                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = true
//                        }
//                        .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
//                            self.startAnimation = false
//                        }
//                }
//            }
//
//        } else { CustomNoDataView(chartData: chartData) }
//    }
//}
//
///**
// 
// */
//internal struct MultiPartBarSubView: View {
//    
//    private let dataSet : MultiBarDataSet
//    
//    internal init(dataSet: MultiBarDataSet) {
//        self.dataSet = dataSet
//    }
//    
//    internal var body: some View {
//        GeometryReader { geo in
//            
//            VStack(spacing: 0) {
//                ForEach(dataSet.dataPoints.reversed()) { dataPoint in
//                    
//                    if dataPoint.colourType == .colour,
//                       let colour = dataPoint.colour
//                    {
//                        
//                        ColourPartBar(colour, getHeight(height    : geo.size.height,
//                                                        dataSet   : dataSet,
//                                                        dataPoint : dataPoint))
//                    
//                    } else if dataPoint.colourType == .gradientColour,
//                              let colours    = dataPoint.colours,
//                              let startPoint = dataPoint.startPoint,
//                              let endPoint   = dataPoint.endPoint
//                    {
//
//                        GradientColoursPartBar(colours, startPoint, endPoint, getHeight(height: geo.size.height,
//                                                                                        dataSet   : dataSet,
//                                                                                        dataPoint : dataPoint))
//
//                    } else if dataPoint.colourType == .gradientStops,
//                              let stops      = dataPoint.stops,
//                              let startPoint = dataPoint.startPoint,
//                              let endPoint   = dataPoint.endPoint
//                    {
//
//                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
//                        
//                        GradientStopsPartBar(safeStops, startPoint, endPoint, getHeight(height: geo.size.height,
//                                                                                    dataSet   : dataSet,
//                                                                                    dataPoint : dataPoint))
//                    }
//                    
//                }
//            }
//        }
//    }
//    
//    
//    private func getHeight(height: CGFloat, dataSet: MultiBarDataSet, dataPoint: MultiPartBarChartDataPoint) -> CGFloat {
//        let value = dataPoint.value
//        let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
//        return height * CGFloat(value / sum)
//    }
//}
