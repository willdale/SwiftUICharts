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
            
            chartData.getXAxidLabels()
            
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
    /**
     Labels for the X axis.
     
     The labels can either come from ChartData -->  xAxisLabels
     or ChartData --> DataSets --> DataPoints
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
          
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with labels marking the x axis.
     
     - Tag: XAxisLabels
     */
    public func xAxisLabels<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
