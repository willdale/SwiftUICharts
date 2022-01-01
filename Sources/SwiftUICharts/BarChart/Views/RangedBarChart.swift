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
        GeometryReader { geo in
            HStack(spacing: 0) {
                RangedBarSubView(chartData: chartData)
                    .accessibilityLabel(chartData.accessibilityTitle)
            }
            .onAppear { // Needed for axes label frames
                self.chartData.chartSize = geo.frame(in: .local)
            }
        }
    }
}

// MARK: - Sub View
internal struct RangedBarSubView<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    var body: some View {
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
internal struct RangedBarElement<ChartData>: View where ChartData: RangedBarChartData {

    @ObservedObject private var chartData: ChartData
    private let dataPoint: RangedBarDataPoint
    private let fill: ChartColour
    private let animations = BarElementAnimation()
    private let index: Double
    private let barSize: CGRect

    @State private var fillAnimation: Bool = false
    @State private var heightAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        dataPoint: RangedBarDataPoint,
        fill: ChartColour,
        index: Int,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.index = Double(index)
        self.barSize = barSize
        
        let shouldAnimate = chartData.shouldAnimate ? false : true
        self._heightAnimation = State<Bool>(initialValue: shouldAnimate)
        self._fillAnimation = State<Bool>(initialValue: shouldAnimate)
    }

    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                // Fill
                .fill(fillAnimation ? fill : animations.fill.startState)
                .animation(animations.fillAnimation(index),
                           value: fill)
                .animateOnAppear(using: animations.fillAnimationStart(index)) {
                    self.fillAnimation = true
                }

                // Width
                .frame(width: BarLayout.barWidth(section.size.width, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index),
                        value: chartData.barStyle.barWidth)
    
                // Height
                .frame(height: heightAnimation ?
                       BarLayout.barHeight(section.size.height, dataPoint.value, chartData.range) : 0)
                .animation(animations.heightAnimation(index),
                           value: dataPoint.value)
                .animateOnAppear(using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
                // Position
                .position(x: barSize.midX,
                          y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))
        }
        .onDisappear {
            self.fillAnimation = false
            self.heightAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        .id(chartData.id)
    }
}
