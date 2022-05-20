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
    @State private var timer: Timer?
    
    /// Initialises a stacked bar chart view.
    /// - Parameters:
    ///   - chartData: Must be StackedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation: Bool = false
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    GeometryReader { geo in
                    StackElementSubView(dataSet: dataSet,
                                        specifier: chartData.infoView.touchSpecifier,
                                        formatter: chartData.infoView.touchFormatter)
                        .clipShape(RoundedRectangleBarShape(chartData.barStyle.cornerRadius))
                        
                        .frame(width: BarLayout.barWidth(geo.size.width, chartData.barStyle.barWidth))
                        .frame(height: frameAnimationValue(dataSet.maxValue(), height: geo.size.height))
                        .offset(offsetAnimationValue(dataSet.maxValue(), size: geo.size))
                        
                        .animation(.default, value: chartData.dataSets)
                        .background(Color(.gray).opacity(0.000000001))
                        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                        .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                    }
                }
            }
            .layoutNotifier(timer)
        } else { CustomNoDataView(chartData: chartData) }
    }
    
    func animationValue(_ dsMax: Double, _ dataMax: Double) -> CGFloat {
        let value = divideByZeroProtection(CGFloat.self, dsMax, dataMax)
        if chartData.disableAnimation {
            return value
        } else {
            return startAnimation ? value : 0
        }
    }
    
    func frameAnimationValue(_ value: Double, height: CGFloat) -> CGFloat {
        let value = BarLayout.barHeight(height, value, chartData.maxValue)
        if chartData.disableAnimation {
            return value
        } else {
            return startAnimation ? value : 0
        }
    }
    
    func offsetAnimationValue(_ value: Double, size: CGSize) -> CGSize {
        let value = BarLayout.barOffset(size, chartData.barStyle.barWidth, value, chartData.maxValue)
        let zero = BarLayout.barOffset(size, chartData.barStyle.barWidth, 0, 0)
        if chartData.disableAnimation {
            return value
        } else {
            return startAnimation ? value : zero
        }
    }
}
