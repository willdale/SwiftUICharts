//
//  BarChart.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

// MARK: - Chart
public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: 0) {
                    BarChartSubView(chartData: chartData)
                        .accessibilityLabel(chartData.accessibilityTitle)
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
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
internal struct BarElement<ChartData>: View where ChartData: CTBarChartDataProtocol & GetDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: BarChartDataPoint
    private let fill: BarColour
    private let animations = BarElementAnimation()
    private let index: Double
    
    @State private var fillAnimation: Bool = false
    @State private var heightAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        dataPoint: BarChartDataPoint,
        fill: BarColour,
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

// MARK: - Animation
public struct BarElementAnimation {

    public var fill = Fill()
    public var height = Height()
    public var width = Width()

    public struct Fill {
        var startState: BarColour = .colour(colour: .clear)
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
