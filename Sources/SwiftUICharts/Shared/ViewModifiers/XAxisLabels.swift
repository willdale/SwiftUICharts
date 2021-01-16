//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisLabels: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData

    @ViewBuilder
    internal var labels: some View {
        
        switch chartData.chartStyle.xAxisLabels.labelsFrom {
        case .dataPoint:
            // ChartData -> DataPoints -> xAxisLabel
            switch chartData.viewData.chartType {
            case .line:
                HStack {
                    ForEach(chartData.dataPoints, id: \.self) { data in
                        if data != chartData.dataPoints[chartData.dataPoints.count - 1] {
                            Text(data.xAxisLabel ?? "")
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    Text(chartData.dataPoints[chartData.dataPoints.count - 1].xAxisLabel ?? "")
                }
                .font(.caption)
                .padding(.horizontal, -4)
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
            
            case .bar:
                HStack(spacing: 0) {
                    ForEach(chartData.dataPoints, id: \.self) { data in
                        if data != chartData.dataPoints[chartData.dataPoints.count - 1] {
                            Spacer()
                            Text(data.xAxisLabel ?? "")
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    Spacer()
                    Text(chartData.dataPoints[chartData.dataPoints.count - 1].xAxisLabel ?? "")
                        .lineLimit(1)
                    Spacer()
                }
                .font(.caption)
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
            }
            

            
        case .chartData:
            // ChartData -> xAxisLabels
            if let labelArray = chartData.xAxisLabels {
                HStack {
                    ForEach(labelArray, id: \.self) { data in
                        Text(data)
                            .lineLimit(1)
                        if data != labelArray[labelArray.count - 1] {
                            Spacer()
                        }
                    }
                }
                .font(.caption)
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                }
            } else { EmptyView() }
        }
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        switch chartData.chartStyle.xAxisLabels.labelPosition {
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
    public func xAxisLabels() -> some View {
        self.modifier(XAxisLabels())
    }
}
