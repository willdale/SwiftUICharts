//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import ChartMath
import SwiftUI

/// View for drawing a line chart.
///
/// Uses ``LineChartData`` data model.
///
/// # Declaration
///
/// ```swift
/// LineChart(chartData: data)
/// ```
///
/// # View Modifiers
///
/// The order of the view modifiers is some what important
/// as the modifiers are various types for stacks that wrap
/// around the previous views.
public struct LineChart: View {
    
    public var chartData: LineChartData
    
    public init(chartData: LineChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        LineSubView(chartData: chartData)
    }
}

internal struct LineSubView: View {
    @ObservedObject private var chartData: LineChartData
    private let minValue: Double
    private let range: Double
    @State private var startAnimation: Bool = false
    
    internal init(chartData: LineChartData) {
        self.chartData = chartData
        self.minValue = ChartMath.minValue(dataPoints: chartData.dataSets.dataPoints)
        self.range = chartData.range()
    }
    
    internal var body: some View {
        LineShape(dataPoints: chartData.dataSets.dataPoints,
                  lineType: chartData.dataSets.style.lineType,
                  minValue: minValue,
                  range: range)
            .trim(to: animationValue)
            .stroke(chartData.dataSets.style.lineColour, strokeStyle: chartData.dataSets.style.strokeStyle)
        
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
