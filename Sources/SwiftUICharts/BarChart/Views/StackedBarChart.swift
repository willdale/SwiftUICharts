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
    .averageLine(chartData: data)
    .yAxisPOI(chartData: data)
    .xAxisGrid(chartData: data)
    .yAxisGrid(chartData: data)
    .xAxisLabels(chartData: data)
    .yAxisLabels(chartData: data)
    .infoBox(chartData: data)
    .headerBox(chartData: data)
    .legends(chartData: data)
 ```
 */
public struct StackedBarChart<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject var chartData: ChartData
          
    /// Initialises a stacked bar chart view.
    /// - Parameters:
    ///   - chartData: Must be StackedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation : Bool = false
    
    public var body: some View {
                
        if chartData.isGreaterThanTwo() {
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    
                    StackElementSubView(dataSet: dataSet)
                        .scaleEffect(y: startAnimation ? CGFloat(dataSet.maxValue() / chartData.maxValue) : 0, anchor: .bottom)
                        .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
                        .background(Color(.gray).opacity(0.000000001))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                        .accessibilityLabel( Text("\(chartData.metadata.title)"))
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
