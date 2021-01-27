//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisLabels<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
        
        self.chartData.viewData.hasXAxisLabels = true
    }

    @ViewBuilder
    internal var labels: some View {
        
        switch chartData.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            // ChartData -> DataPoints -> xAxisLabel
            
            switch chartData.chartType {
            case (.line, .single):

                XLabelSingleLineDataSet(chartData: chartData as! LineChartData)

            case (.line, .multi):

                XLabelMultiLineDataSet(chartData: chartData as! MultiLineChartData)
                
            case (.bar, .single):
                
                XLabelSingleBarDataSet(chartData: chartData as! BarChartData)
                
            case (.bar, .multi):

                XLabelMultiBarDataSet(chartData: chartData as! MultiBarChartData)
                
            default:
                Text("Should not be here")
            }
            

            
        case .chartData:
            switch chartData.chartType.chartType {
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
                }
            case .pie:
                Text("Should not be here")
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
    public func xAxisLabels<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}


internal struct XLabelSingleLineDataSet<CD>: View where CD: LineChartData {
    
    let chartData: CD
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataPoints) { data in
                Text(data.xAxisLabel ?? "")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if data != chartData.dataSets.dataPoints[chartData.dataSets.dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }
    
}

internal struct XLabelMultiLineDataSet<CD>: View where CD: MultiLineChartData {
    
    let chartData: CD
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataSets[0].dataPoints) { data in
                Text(data.xAxisLabel ?? "")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if data != chartData.dataSets.dataSets[0].dataPoints[chartData.dataSets.dataSets[0].dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }

}
internal struct XLabelSingleBarDataSet<CD>: View where CD: BarChartData {
    
    let chartData: CD
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataPoints) { data in
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
    }
}

internal struct XLabelMultiBarDataSet<CD>: View where CD: MultiBarChartData {
    
    let chartData: CD
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataSets[0].dataPoints) { data in
                Text(data.xAxisLabel ?? "")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if data != chartData.dataSets.dataSets[0].dataPoints[chartData.dataSets.dataSets[0].dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }

}
