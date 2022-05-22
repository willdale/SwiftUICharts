//
//  GroupedBarChart.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

// MARK: Chart
/**
 View for creating a grouped bar chart.
 
 Uses `GroupedBarChartData` data model.
 
 # Declaration
 ```
 GroupedBarChart(chartData: data, groupSpacing: 25)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct GroupedBarChart<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let groupSpacing: CGFloat

    
    /// Initialises a grouped bar chart view.
    /// - Parameters:
    ///   - chartData: Must be GroupedBarChartData model.
    ///   - groupSpacing: Spacing between groups of bars.
    public init(
        chartData: ChartData,
        groupSpacing: CGFloat
    ) {
        self.chartData = chartData
        self.groupSpacing = groupSpacing
        self.chartData.groupSpacing = groupSpacing
    }
    
    public var body: some View {
//        GeometryReader { geo in
            HStack(spacing: groupSpacing) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    GroupedBarGroup(chartData: chartData, dataSet: dataSet)
                }
            }
//            .modifier(ChartSizeUpdating(chartData: chartData))
//            .onAppear { // Needed for axes label frames
//                self.chartData.chartSize = geo.frame(in: .local)
//            }
//        }
    }
}

internal struct GroupedBarGroup<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataSet: GroupedBarDataSet
    
    internal init(
        chartData: ChartData,
        dataSet: GroupedBarDataSet
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
    }
    
    internal var body: some View {
        HStack(spacing: 0) {
            ForEach(dataSet.dataPoints.indices, id: \.self) { index in
                GroupBarElement(chartData: chartData,
                                dataPoint: dataSet.dataPoints[index],
                                fill: dataSet.dataPoints[index].group.colour,
                                index: index)
                    .accessibilityLabel(chartData.accessibilityTitle)
            }
        }
    }
}

// MARK: - Element
internal struct GroupBarElement<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: GroupedBarDataPoint
    private let fill: ChartColour
    private let animations = BarElementAnimation()
    private let index: Double
    
    internal init(
        chartData: ChartData,
        dataPoint: GroupedBarDataPoint,
        fill: ChartColour,
        index: Int
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.index = Double(index)
    }
    
    @State private var fillAnimation: Bool = false
    @State private var heightAnimation: Bool = false

    internal var body: some View {
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
                .offset(offsetAnimationValue(size: section.size))
                .animation(animations.heightAnimation(index), value: dataPoint.value)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
        }
        .onDisappear {
            self.heightAnimation = false
            self.fillAnimation = false
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
        let value = BarLayout.barHeight(height, dataPoint.value, chartData.maxValue)
        if chartData.disableAnimation {
            return value
        } else {
            return heightAnimation ? value : 0
        }
    }
    
    func offsetAnimationValue(size: CGSize) -> CGSize {
        let endValue = BarLayout.barOffset(size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue)
        let startValue = BarLayout.barOffset(size, chartData.barStyle.barWidth, 0, 0)
        if chartData.disableAnimation {
            return endValue
        } else {
            return heightAnimation ? endValue : startValue
        }
    }
}
