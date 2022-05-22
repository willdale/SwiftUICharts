//
//  BarChart.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

// MARK: - Chart
public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    public var chartData: ChartData
    public var stateObject: ChartStateObject
    
    public init(
        chartData: ChartData,
        stateObject: ChartStateObject
    ) {
        self.chartData = chartData
        self.stateObject = stateObject
    }
    
    public var body: some View {
            HStack(spacing: 0) {
                BarChartSubView(chartData: chartData)
                    .accessibilityLabel(chartData.accessibilityTitle)
            }
            .modifier(ChartSizeUpdating(stateObject: stateObject))
    }
}

// MARK: - Sub View
internal struct BarChartSubView<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                BarElement(chartData: chartData,
                           dataPoint: chartData.dataSets.dataPoints[index],
                           fill: chartData.barStyle.colour,
                           index: index)
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                BarElement(chartData: chartData,
                           dataPoint: chartData.dataSets.dataPoints[index],
                           fill: chartData.dataSets.dataPoints[index].colour,
                           index: index)
            }
        }
    }
}

// MARK: - Element
internal struct BarElement<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: BarChartDataPoint
    private let fill: ChartColour
    private let animations = BarElementAnimation()
    private let index: Double
    
    internal init(
        chartData: ChartData,
        dataPoint: BarChartDataPoint,
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

// MARK: - Animation
public struct BarElementAnimation {

    public var fill = Fill()
    public var height = Height()
    public var width = Width()

    public struct Fill {
        var startState: ChartColour = .colour(colour: .clear)
        var start: Animation = .linear(duration: 0.0)
        var startDelay: Double = 0.0

        var transition: Animation = .linear(duration: 2.0)
        var transitionDelay: Double = 0.0
    }

    public struct Height {
        var start: Animation = .linear(duration: 2.0)
        var startDelay: Double = 0.0

        var transition: Animation = .linear(duration: 2.0)
        var transitionDelay: Double = 0.0
    }

    public struct Width {
        var transition: Animation = .linear(duration: 2.0)
        var transitionDelay: Double = 0.0
    }
    
    internal func fillAnimationStart(_ index: Double) -> Animation {
        fill.start.delay(index * fill.startDelay)
    }
    internal func fillAnimation(_ index: Double) -> Animation {
        fill.transition.delay(index * fill.transitionDelay)
    }
    
    internal func heightAnimationStart(_ index: Double) -> Animation {
        height.start.delay(index * height.startDelay)
    }
    internal func heightAnimation(_ index: Double) -> Animation {
        height.transition.delay(index * height.transitionDelay)
    }
    
    internal func widthAnimation(_ index: Double) -> Animation {
        width.transition.delay(index * width.transitionDelay)
    }
}
