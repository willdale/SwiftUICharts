//
//  StackedBarChart.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI

/**
 View for creating a stacked bar chart.
 
 Uses `StackedBarChartData` data model.
 
 # Declaration
 
 ```
 StackedBarChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3,dash: [5,10]))
 .yAxisPOI(chartData: data,
           markerName: "50",
           markerValue: 50,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct StackedBarChart<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation = false
    
    /// Initialises a stacked bar chart view.
    /// - Parameters:
    ///   - chartData: Must be StackedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    GeometryReader { section in
                        StackElementSubView(dataSet: dataSet, specifier: chartData.infoView.touchSpecifier)
                            .clipShape(RoundedRectangleBarShape(chartData.barStyle.cornerRadius))
                            .frame(startAnimation ?
                                   chartData.barFrame(section.size, chartData.barStyle.barWidth, dataSet.totalSetValue, chartData.maxValue) :
                                    chartData.barFrame(section.size, chartData.barStyle.barWidth, 0, 0))
                            .offset(startAnimation ?
                                    chartData.barOffset(section.size, chartData.barStyle.barWidth, dataSet.totalSetValue, chartData.maxValue) :
                                        chartData.barOffset(section.size, chartData.barStyle.barWidth, 0, 0))
                            .background(Color(.gray).opacity(0.000000001))
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .accessibilityLabel(chartData.accessibilityTitle)
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
