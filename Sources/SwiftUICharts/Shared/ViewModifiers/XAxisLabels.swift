//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisLabels<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData: T

    @ViewBuilder
    internal var labels: some View {
        
        switch chartData.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            // ChartData -> DataPoints -> xAxisLabel
            switch chartData.viewData.chartType {
            case .line:
                Text("")
                if chartData.chartType == (.line, .multi) {
                    
                    let lineChartData = chartData as! MultiLineChartData
                    let dataSet = lineChartData.dataSets.dataSets
                    
                    HStack(spacing: 0) {
                        ForEach(dataSet[0].dataPoints) { data in
                            Text(data.xAxisLabel ?? "")
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            if data != dataSet[0].dataPoints[dataSet[0].dataPoints.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                    .onAppear {
                        chartData.viewData.hasXAxisLabels = true
                    }
                    
                } else if chartData.chartType == (.line, .single) {
                    
                    let lineChartData = chartData as! LineChartData
                    let dataSet = lineChartData.dataSets
                    
                    HStack(spacing: 0) {
                        ForEach(dataSet.dataPoints) { data in
                            Text(data.xAxisLabel ?? "")
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            if data != dataSet.dataPoints[dataSet.dataPoints.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                    .onAppear {
                        chartData.viewData.hasXAxisLabels = true
                    }
                }
                
                
            case .bar:
                Text("hello")
//                let barChartData = chartData as! BarChartData
//                HStack(spacing: 0) {
//                    ForEach(barChartData.dataSets[0].dataPoints, id: \.self) { data in
//                            Spacer()
//                                .frame(minWidth: 0, maxWidth: 500)
//                            Text(data.xAxisLabel ?? "")
//                                .font(.caption)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
//                            Spacer()
//                                .frame(minWidth: 0, maxWidth: 500)
//                    }
//                }
//                .onAppear {
//                    chartData.viewData.hasXAxisLabels = true
//                }
            }
            

            
        case .chartData:
            switch chartData.viewData.chartType {
            case .line:
                // ChartData -> xAxisLabels
                if let labelArray = chartData.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Text(data)
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            if data != labelArray[labelArray.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                    .onAppear {
                        chartData.viewData.hasXAxisLabels = true
                    }
                }
            case .bar:
                Text("Hello")
//                if let labelArray = chartData.xAxisLabels {
//                    HStack(spacing: 0) {
//                        ForEach(labelArray, id: \.self) { data in
//                            Spacer()
//                                .frame(minWidth: 0, maxWidth: 500)
//                            Text(data)
//                                .font(.caption)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
//                            Spacer()
//                                .frame(minWidth: 0, maxWidth: 500)
//                        }
//                    }
//                    .onAppear {
//                        chartData.viewData.hasXAxisLabels = true
//                    }
//                }
            }
        }
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        switch chartData.chartStyle.xAxisLabelPosition {
        case .top:
            VStack {
                labels
                content
            }
            
        case .bottom:
            VStack {
                content
                labels
            }
        }
    }
}

extension View {
    /// Labels for the X axis.
    public func xAxisLabels<T: ChartData>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
