//
//  MultiLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import ChartMath
import SwiftUI

/// View for drawing a multi-line, line chart.
///
/// Uses ``MultiLineChartData`` data model.
///
/// # Declaration
///
/// ```swift
/// MultiLineChart(chartData: data)
/// ```
///
/// # View Modifiers
///
/// The order of the view modifiers is some what important
/// as the modifiers are various types for stacks that wrap
/// around the previous views.
public struct MultiLineChart: View {
    
    public var chartData: MultiLineChartData
    private let minValue: Double
    private let range: Double
    
    public init(chartData: MultiLineChartData) {
        self.chartData = chartData
        self.minValue = ChartMath.minValue(dataPoints: chartData.dataSets.dataSets.map(\.dataPoints))
        self.range = chartData.range()
    }
        
    public var body: some View {
            ZStack {
                chartData.getAccessibility()
                ForEach(chartData.dataSets.dataSets, id: \.id) { dataSet in
                    SingleLineChartSubView(chartData: chartData,
                                           dataSet: dataSet,
                                           colour: dataSet.style.lineColour,
                                           minValue: minValue,
                                           range: range)
                }
            }
    }
}

internal struct SingleLineChartSubView<ChartData>: View where ChartData: MultiLineChartData {
    @ObservedObject private var chartData: ChartData
    private let dataSet: LineDataSet
    private let colour: ChartColour
    private let minValue: Double
    private let range: Double
    
    internal init(
        chartData: ChartData,
        dataSet: LineDataSet,
        colour: ChartColour,
        minValue: Double,
        range: Double
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.colour = colour
        self.minValue = minValue
        self.range = range
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        LineShape(dataPoints: dataSet.dataPoints,
                  lineType: dataSet.style.lineType,
                  minValue: minValue,
                  range: range)
            .trim(to: animationValue)
            .stroke(colour, strokeStyle: dataSet.style.strokeStyle)
        
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
