//
//  RangedLineChart.swift
//  
//
//  Created by Will Dale on 01/03/2021.
//

import ChartMath
import SwiftUI


/// View for drawing a line chart with upper and lower range values .
///
/// Uses `RangedLineChartData` data model.
///
/// # Declaration
///
/// ```
/// RangedLineChart(chartData: data)
/// ```
///
/// # View Modifiers
///
/// The order of the view modifiers is some what important
/// as the modifiers are various types for stacks that wrap
/// around the previous views.
public struct RangedLineChart<ChartData>: View where ChartData: RangedLineChartData {
    
    @ObservedObject private var chartData: ChartData
    private let minValue: Double
    private let range: Double
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be RangedLineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        
        self.minValue = ChartMath.minValue(dataPoints: chartData.dataSets.dataPoints)
        self.range = chartData.range()
    }
    
    public var body: some View {
        ZStack {
            RangedBoxSubView(chartData: chartData,
                             dataSet: chartData.dataSets,
                             minValue: minValue,
                             range: range,
                             colour: chartData.dataSets.style.fillColour)
            
            RangedLineSubView(chartData: chartData,
                              dataSet: chartData.dataSets,
                              minValue: minValue,
                              range: range,
                              colour: chartData.dataSets.style.lineColour)
        }
    }
}

// MARK: Box Sub View
internal struct RangedBoxSubView<ChartData>: View where ChartData: RangedLineChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataSet: RangedLineDataSet
    private let minValue: Double
    private let range: Double
    private let colour: ChartColour
    
    internal init(
        chartData: ChartData,
        dataSet: RangedLineDataSet,
        minValue: Double,
        range: Double,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.minValue = minValue
        self.range = range
        self.colour = colour
    }
    
    internal var body: some View {
        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                            lineType: chartData.dataSets.style.lineType,
                            minValue: minValue,
                            range: range)
            .fill(colour)
    }
}

// MARK: Line Sub View
internal struct RangedLineSubView<ChartData>: View where ChartData: RangedLineChartData {
    @ObservedObject private var chartData: ChartData
    private let dataSet: RangedLineDataSet
    private let minValue: Double
    private let range: Double
    private let colour: ChartColour
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        dataSet:RangedLineDataSet,
        minValue: Double,
        range: Double,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.minValue = minValue
        self.range = range
        self.colour = colour
    }
    
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
