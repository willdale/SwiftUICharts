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
fileprivate struct StackSubView<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataSet: StackedBarDataSet
    private let animations = BarElementAnimation()
    private let index: Double
    
    fileprivate init(
        chartData: ChartData,
        dataSet: StackedBarDataSet,
        index: Int
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.index = Double(index)
    }
    
    @State private var heightAnimation: Bool = false

    var body: some View {
        GeometryReader { section in
            StackSingleBarView(dataSet: dataSet,
                               animations: animations,
                               disableAnimation: chartData.disableAnimation,
                               index: index)
                .clipShape(RoundedRectangleBarShape(chartData.barStyle.cornerRadius))
            
                // Width
                .frame(width: BarLayout.barWidth(section.size.width, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index), value: chartData.barStyle.barWidth)
            
                // Height
                .frame(height: heightAnimationValue(height: section.size.height))
                .offset(offsetAnimationValue(size: section.size))
                .animation(animations.heightAnimation(index), value: dataSet.totalSetValue)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.heightAnimationStart(index)) {
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
    
    func heightAnimationValue(height: CGFloat) -> CGFloat {
        let value = BarLayout.barHeight(height, dataSet.totalSetValue, chartData.maxValue)
        if chartData.disableAnimation {
            return value
        } else {
            return heightAnimation ? value : 0
        }
    }
    
    func offsetAnimationValue(size: CGSize) -> CGSize {
        let endValue = BarLayout.barOffset(size, chartData.barStyle.barWidth, dataSet.totalSetValue, chartData.maxValue)
        let startValue = BarLayout.barOffset(size, chartData.barStyle.barWidth, 0, 0)
        if chartData.disableAnimation {
            return endValue
        } else {
            return heightAnimation ? endValue : startValue
        }
    }
}

// MARK: - Single Bar
fileprivate struct StackSingleBarView: View {
    
    private let dataSet: StackedBarDataSet
    private let animations: BarElementAnimation
    private let disableAnimation: Bool
    private let index: Double
    
    fileprivate init(
        dataSet: StackedBarDataSet,
        animations: BarElementAnimation,
        disableAnimation: Bool,
        index: Double
    ) {
        self.dataSet = dataSet
        self.animations = animations
        self.disableAnimation = disableAnimation
        self.index = index
    }
    
    fileprivate var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(dataSet.dataPoints.reversed()) { dataPoint in
                    StackBarElement(fill: dataPoint.group.colour,
                                    height: elementHeight(height: geo.size.height,
                                                          dataSet: dataSet,
                                                          dataPoint: dataPoint),
                                    animations: animations,
                                    disableAnimation: disableAnimation,
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
fileprivate struct StackBarElement: View {
    
    private let fill: ChartColour
    private let height: CGFloat
    private let animations: BarElementAnimation
    private let disableAnimation: Bool
    private let index: Double
    
    fileprivate init(
        fill: ChartColour,
        height: CGFloat,
        animations: BarElementAnimation,
        disableAnimation: Bool,
        index: Double
    ) {
        self.fill = fill
        self.height = height
        self.animations = animations
        self.disableAnimation = disableAnimation
        self.index = index
    }
    
    @State private var fillAnimation: Bool = false
    
    fileprivate var body: some View {
        Rectangle()
            // Fill
            .fill(fillAnimation ? fill : animations.fill.startState)
            .animation(animations.fillAnimation(index), value: fill)
            .animateOnAppear(disabled: disableAnimation, using: animations.fillAnimationStart(index)) {
                self.fillAnimation = true
            }

            // Height
            .frame(height: height)
    }
}
