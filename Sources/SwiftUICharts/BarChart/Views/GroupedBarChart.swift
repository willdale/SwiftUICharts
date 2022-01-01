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
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: groupSpacing) {
                    ForEach(chartData.dataSets.dataSets) { dataSet in
                        GroupedBarGroup(chartData: chartData, dataSet: dataSet)
                    }
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
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
internal struct GroupBarElement<ChartData>: View where ChartData: CTBarChartDataProtocol & GetDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: GroupedBarDataPoint
    private let fill: ChartColour
    private let animations = BarElementAnimation()
    private let index: Double
    
    @State private var fillAnimation: Bool = false
    @State private var heightAnimation: Bool = false
    
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
                .frame(height: heightAnimation ? BarLayout.barHeight(section.size.height, dataPoint.value, chartData.maxValue) : 0)
                .offset(heightAnimation ?
                        BarLayout.barOffset(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                        BarLayout.barOffset(section.size, chartData.barStyle.barWidth, 0, 0))
                .animation(animations.heightAnimation(index),
                           value: dataPoint.value)
                .animateOnAppear(using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
        }
        .onDisappear {
            self.heightAnimation = false
            self.fillAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        .id(chartData.id)
    }
}
