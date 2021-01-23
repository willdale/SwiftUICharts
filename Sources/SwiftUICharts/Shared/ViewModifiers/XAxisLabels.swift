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
                let lineChartData = chartData as! LineChartData
                HStack(spacing: 0) {
                    ForEach(lineChartData.dataSets[0].dataPoints, id: \.self) { data in
                        Text(data.xAxisLabel ?? "")
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        if data != lineChartData.dataSets[0].dataPoints[lineChartData.dataSets[0].dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
                .padding(.horizontal, -4)
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
            case .bar:
                let barChartData = chartData as! BarChartData
                HStack(spacing: 0) {
                    ForEach(barChartData.dataSets[0].dataPoints, id: \.self) { data in
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            Text(data.xAxisLabel ?? "")
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                    }
                }
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
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
                if let labelArray = chartData.xAxisLabels {
                HStack(spacing: 0) {
                    ForEach(labelArray, id: \.self) { data in
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            Text(data)
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                    }
                }
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
            }
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
