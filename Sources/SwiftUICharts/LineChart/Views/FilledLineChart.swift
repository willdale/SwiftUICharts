//
//  FilledLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

// MARK: - Chart
/**
 View for creating a filled line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 FilledLineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct FilledLineChart<ChartData>: View where ChartData: FilledLineChartData {
    
    @ObservedObject private var chartData: ChartData
    private let minValue: Double
    private let range: Double
    
    /// Initialises a filled line chart
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self.minValue = chartData.minValue
        self.range = chartData.range
    }
    
    @State private var startAnimation: Bool = false
    
    public var body: some View {
            ZStack {
                TopLineSubView(chartData: chartData,
                               colour: chartData.dataSets.style.lineColour)
                FilledLineSubView(chartData: chartData,
                                  colour: chartData.dataSets.style.fillColour)
            }
        }
    }

 // MARK: - Top Line
internal struct TopLineSubView<ChartData>: View where ChartData: FilledLineChartData {
    @ObservedObject private var chartData: ChartData
    private let colour: ChartColour
    
    internal init(
        chartData: ChartData,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.colour = colour
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        LineShape(dataPoints: chartData.dataSets.dataPoints,
                  lineType: chartData.dataSets.style.lineType,
                  minValue: chartData.minValue,
                  range: chartData.range)
            .scale(y: animationValue, anchor: .bottom)
            .stroke(colour, strokeStyle: chartData.dataSets.style.strokeStyle)
        
            .animateOnAppear(disabled: chartData.disableAnimation, using: .linear) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
        }
    }
}

// MARK: - Fill
internal struct FilledLineSubView<ChartData>: View where ChartData: FilledLineChartData {
    
    @ObservedObject private var chartData: ChartData
    private let colour: ChartColour
    
    internal init(
        chartData: ChartData,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.colour = colour
    }

    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        FilledLine(dataPoints: chartData.dataSets.dataPoints,
                   lineType: chartData.dataSets.style.lineType,
                   minValue: chartData.minValue,
                   range: chartData.range)
            .scale(y: animationValue, anchor: .bottom)
            .fill(colour)
        
            .animateOnAppear(disabled: chartData.disableAnimation, using: .linear) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
        }
    }
}
