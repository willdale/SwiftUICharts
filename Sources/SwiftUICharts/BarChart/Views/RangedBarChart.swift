//
//  RangedBarChart.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

// MARK: - Chart
/**
 View for creating a grouped bar chart.
 
 Uses `RangedBarChartData` data model.
 
 # Declaration
 
 ```
 RangedBarChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct RangedBarChart<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be RangedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
//        GeometryReader { geo in
            HStack(spacing: 0) {
                RangedBarSubView(chartData: chartData)
                    .accessibilityLabel(chartData.accessibilityTitle)
            }
//            .modifier(ChartSizeUpdating(chartData: chartData))
//            .onAppear { // Needed for axes label frames
//                self.chartData.chartSize = geo.frame(in: .local)
//            }
//        }
    }
}

// MARK: - Sub View
fileprivate struct RangedBarSubView<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    fileprivate init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    fileprivate var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                GeometryReader { geo in
                    RangedBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.barStyle.colour,
                                     index: index,
                                     barSize: geo.frame(in: .local))
                }
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                GeometryReader { geo in
                    RangedBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.dataSets.dataPoints[index].colour,
                                     index: index,
                                     barSize: geo.frame(in: .local))
                }
            }
        }
    }
}

// MARK: - Element
fileprivate struct RangedBarElement<ChartData>: View where ChartData: RangedBarChartData {

    @ObservedObject private var chartData: ChartData
    private let dataPoint: RangedBarDataPoint
    private let fill: ChartColour
    private let animations: BarElementAnimation
    private let index: Double
    private let barSize: CGRect

    fileprivate init(
        chartData: ChartData,
        dataPoint: RangedBarDataPoint,
        animations: BarElementAnimation = BarElementAnimation(),
        fill: ChartColour,
        index: Int,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.animations = animations
        self.fill = fill
        self.index = Double(index)
        self.barSize = barSize
    }

    @State private var fillAnimation: Bool = false
    @State private var heightAnimation: Bool = false

    fileprivate var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                // Fill
                .fill(fillAnimationValue)
                .animation(animations.fillAnimation(index), value: fill)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.fillAnimationStart(index)) {
                    self.fillAnimation = true
                }

                // Width
                .frame(width: BarLayout.barWidth(section.size.width, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index), value: chartData.barStyle.barWidth)
    
                // Height
                .frame(height: heightAnimationValue(height: section.size.height))
                .animation(animations.heightAnimation(index), value: dataPoint.value)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
                // Position
                .position(position)
        }
        .onDisappear {
            self.fillAnimation = false
            self.heightAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .id(chartData.id)
    }
    
    var fillAnimationValue: ChartColour {
        let endValue = fill
        let startValue = animations.fill.startState
        if chartData.disableAnimation {
            return endValue
        } else {
            return fillAnimation ? endValue : startValue
        }
    }
    
    func heightAnimationValue(height: CGFloat) -> CGFloat {
        let value = BarLayout.barHeight(height, dataPoint.value, chartData.range)
        if chartData.disableAnimation {
            return value
        } else {
            return heightAnimation ? value : 0
        }
    }
    
    var position: CGPoint {
        CGPoint(x: barSize.midX,
                y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))
    }
}
