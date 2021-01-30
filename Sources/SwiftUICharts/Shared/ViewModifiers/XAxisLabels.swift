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
        
        switch chartData.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            // ChartData -> DataPoints -> xAxisLabel
            switch chartData.viewData.chartType {
            case .line:
                HStack(spacing: 0) {
                    ForEach(chartData.dataPoints, id: \.self) { data in
                        if let label = data.xAxisLabel {
                        Text(label)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        }
                        if data != chartData.dataPoints[chartData.dataPoints.count - 1] {
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
                HStack(spacing: 0) {
                    ForEach(chartData.dataPoints, id: \.self) { data in
                        if let label = data.xAxisLabel {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)

                            Text(label)
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)

                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
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
    public func xAxisLabels() -> some View {
        self.modifier(XAxisLabels())
    }
}
