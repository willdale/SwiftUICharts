//
//  HorizontalBarChart.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

// MARK: - Chart
public struct HorizontalBarChart<ChartData>: View where ChartData: HorizontalBarChartData {
    
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
        VStack(spacing: 0) {
            HorizontalBarChartSubView(chartData: chartData)
                .accessibilityLabel(chartData.accessibilityTitle)
        }
        .modifier(ChartSizeUpdating(stateObject: stateObject))
    }
}

// MARK: - Sub View
internal struct HorizontalBarChartSubView<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.barStyle.colour,
                                     index: index)
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.dataSets.dataPoints[index].colour,
                                     index: index)
            }
        }
    }
}

// MARK: - Element
internal struct HorizontalBarElement<ChartData>: View where ChartData: CTChartData & CTBarChartDataProtocol & DataHelper {
    
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
    @State private var lengthAnimation: Bool = false    
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                // Fill
                .fill(fillAnimationValue)
                .animation(animations.fillAnimation(index), value: fill)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.fillAnimationStart(index)) {
                    self.fillAnimation = true
                }

                // Bredth
                .frame(height: BarLayout.barWidth(section.size.height, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index), value: chartData.barStyle.barWidth)
            
                // Length
                .frame(width: lengthAnimationValue(width: section.size.width))
                .offset(CGSize(width: 0,
                               height: BarLayout.barXOffset(section.size.height, chartData.barStyle.barWidth)))
                .animation(animations.heightAnimation(index), value: dataPoint.value)
                .animateOnAppear(disabled: chartData.disableAnimation, using: animations.heightAnimationStart(index)) {
                    self.lengthAnimation = true
                }
        }
        .onDisappear {
            self.fillAnimation = false
            self.lengthAnimation = false
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
    
    func lengthAnimationValue(width: CGFloat) -> CGFloat {
        let value = BarLayout.barHeight(width, dataPoint.value, chartData.maxValue)
        if chartData.disableAnimation {
            return value
        } else {
            return lengthAnimation ? value : 0
        }
    }
}
