//
//  StackedBarChart.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI

// MARK: - Chart
public struct StackedBarChart<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject private var chartData: ChartData
        
    /// Initialises a stacked bar chart view.
    /// - Parameters:
    ///   - chartData: Must be StackedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(chartData.dataSets.dataSets.indices, id: \.self) { index in
                StackSubView(chartData: chartData,
                             dataSet: chartData.dataSets.dataSets[index],
                             index: index)
            }
        }
//        .modifier(ChartSizeUpdating(chartData: chartData))
    }
}

// MARK: Sub View
internal struct StackSubView<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataSet: StackedBarDataSet
    private let animations = BarElementAnimation()
    private let index: Double
    
    @State private var heightAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        dataSet: StackedBarDataSet,
        index: Int
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.index = Double(index)
        
        let shouldAnimate = chartData.shouldAnimate ? false : true
        self._heightAnimation = State<Bool>(initialValue: shouldAnimate)
    }
    
    var body: some View {
        GeometryReader { section in
            StackSingleBarView(dataSet: dataSet,
                               animations: animations,
                               index: index)
                .clipShape(RoundedRectangleBarShape(chartData.barStyle.cornerRadius))
            
                // Width
                .frame(width: BarLayout.barWidth(section.size.width, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index),
                           value: chartData.barStyle.barWidth)
            
                // Height
                .frame(height: heightAnimation ?
                       BarLayout.barHeight(section.size.height, dataSet.totalSetValue, chartData.maxValue) : 0)
                .offset(heightAnimation ?
                        BarLayout.barOffset(section.size, chartData.barStyle.barWidth, dataSet.totalSetValue, chartData.maxValue) :
                            BarLayout.barOffset(section.size, chartData.barStyle.barWidth, 0, 0))
                .animation(animations.heightAnimation(index),
                           value: dataSet.totalSetValue)
                .animateOnAppear(using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
        }
        .onDisappear {
            self.heightAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityLabel(chartData.accessibilityTitle)
        .id(chartData.id)
    }
}

// MARK: - Single Bar
internal struct StackSingleBarView: View {
    
    private let dataSet: StackedBarDataSet
    private let animations: BarElementAnimation
    private let index: Double
    
    internal init(
        dataSet: StackedBarDataSet,
        animations: BarElementAnimation,
        index: Double
    ) {
        self.dataSet = dataSet
        self.animations = animations
        self.index = index
    }
    
    internal var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(dataSet.dataPoints.reversed()) { dataPoint in
                    StackBarElement(fill: dataPoint.group.colour,
                                    height: elementHeight(height: geo.size.height,
                                                          dataSet: dataSet,
                                                          dataPoint: dataPoint),
                                    animations: animations,
                                    index: index)
//                        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                }
            }
        }
    }

    private func elementHeight(
        height: CGFloat,
        dataSet: StackedBarDataSet,
        dataPoint: StackedBarDataPoint
    ) -> CGFloat {
        let value = dataPoint.value
        let sum = dataSet.dataPoints
            .map(\.value)
            .reduce(0, +)
        return height * CGFloat(value / sum)
    }
}

// MARK: Stacked Element
internal struct StackBarElement: View {
    
    private let fill: ChartColour
    private let height: CGFloat
    private let animations: BarElementAnimation
    private let index: Double
    
    @State private var fillAnimation: Bool = false
    
    internal init(
        fill: ChartColour,
        height: CGFloat,
        animations: BarElementAnimation,
        index: Double
    ) {
        self.fill = fill
        self.height = height
        self.animations = animations
        self.index = index
    }
    
    internal var body: some View {
        Rectangle()
            // Fill
            .fill(fillAnimation ? fill : animations.fill.startState)
            .animation(animations.fillAnimation(index),
                       value: fill)
            .animateOnAppear(using: animations.fillAnimationStart(index)) {
                self.fillAnimation = true
            }

            // Height
            .frame(height: height)
    }
}
