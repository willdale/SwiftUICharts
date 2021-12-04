//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

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

// MARK: - Standard
internal struct BarElement<CD: CTBarChartDataProtocol & GetDataProtocol,
                           DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    @ObservedObject var chartData: CD
    var dataPoint: DP
    var fill: BarColour
    var animations = BarElementAnimation()
    var index: Double
    
    @State private var heightAnimation: Bool = false
    @State private var widthAnimation: Bool = false
    @State private var fillAnimation: Bool = false
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        fill: BarColour,
        index: Int
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.index = Double(index)
        
        let shouldAnimate = chartData.shouldAnimate ? false : true
        self._heightAnimation = State<Bool>(initialValue: shouldAnimate)
        self._widthAnimation = State<Bool>(initialValue: shouldAnimate)
        self._fillAnimation = State<Bool>(initialValue: shouldAnimate)
    }
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                // MARK: Fill
                .fill(fillAnimation ? fill : animations.fill.startState)
                .animation(animations.fillAnimation(index),
                           value: fill)
                .animateOnAppear(using: animations.fillAnimationStart(index)) {
                    self.fillAnimation = true
                }

                // MARK: Width
                .frame(width: chartData.barWidth(section.size.width, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index),
                           value: chartData.barStyle.barWidth)
            
                // MARK: Height
                .frame(height: heightAnimation ?
                       chartData.barHeight(section.size.height, dataPoint.value, chartData.maxValue) :
                       chartData.barHeight(section.size.height, 0, 0))
                .offset(heightAnimation ?
                        chartData.barOffset(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                        chartData.barOffset(section.size, chartData.barStyle.barWidth, 0, 0))
                .animation(animations.heightAnimation(index),
                           value: dataPoint.value)
                .animateOnAppear(using: animations.heightAnimationStart(index)) {
                    self.heightAnimation = true
                }
        }
        // MARK: General
        .onDisappear {
            self.heightAnimation = false
            self.fillAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        .id(chartData.id)
    }
}

// MARK: - Horizontal
internal struct HorizontalBarElement<CD: CTBarChartDataProtocol & GetDataProtocol,
                                     DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    private let chartData: CD
    private let fill: BarColour
    private let dataPoint: DP
    @State private var startAnimation: Bool
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        fill: BarColour
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                .fill(fill)
                .frame(startAnimation ?
                        chartData.barHorizontalFrame(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                        chartData.barHorizontalFrame(section.size, chartData.barStyle.barWidth, 0, 0))
                .offset(startAnimation ?
                            chartData.barHorizontalOffset(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                            chartData.barHorizontalOffset(section.size, chartData.barStyle.barWidth, 0, 0))
                .background(Color(.gray).opacity(0.000000001))
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = false
                }
                .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        }
    }
}

// MARK: - Stacked
internal struct StackElementSubView: View {
    
    private let dataSet: StackedBarDataSet
    private let specifier: String
    
    internal init(
        dataSet: StackedBarDataSet,
        specifier: String
    ) {
        self.dataSet = dataSet
        self.specifier = specifier
    }
    
    internal var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(dataSet.dataPoints.reversed()) { dataPoint in
                    StackBarElement(dataPoint.group.colour, elementHeight(height: geo.size.height,
                                                                          dataSet: dataSet,
                                                                          dataPoint: dataPoint))
                        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                }
            }
        }
    }
    
    /// Sets the height of each element.
    /// - Parameters:
    ///   - height: Height of the whole bar.
    ///   - dataSet: Which data set the bar comes from.
    ///   - dataPoint: Data point to draw.
    /// - Returns: Height of the element.
    private func elementHeight(
        height: CGFloat,
        dataSet: StackedBarDataSet,
        dataPoint: StackedBarDataPoint
    ) -> CGFloat {
        let value = dataPoint.value
        let sum = dataSet.dataPoints
            .lazy
            .map(\.value)
            .reduce(0, +)
        return height * CGFloat(value / sum)
    }
}

// MARK: Stacked Element
internal struct StackBarElement: View {
    
    private let fill: BarColour
    private let height: CGFloat
    
    internal init(
        _ fill: BarColour,
        _ height: CGFloat
    ) {
        self.fill = fill
        self.height = height
    }
    
    internal var body: some View {
        Rectangle()
            .fill(fill)
            .frame(height: height)
    }
}

// MARK: - Ranged
internal struct RangedBarCell<CD>: View where CD: RangedBarChartData {
    
    private let chartData: CD
    private let dataPoint: CD.SetType.DataPoint
    private let fill: BarColour
    private let barSize: CGRect
    @State private var startAnimation: Bool
    
    internal init(
        chartData: CD,
        dataPoint: CD.SetType.DataPoint,
        fill: BarColour,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.barSize = barSize
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                .fill(fill)
                .frame(startAnimation ?
                        chartData.barFrame(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.range) :
                        chartData.barFrame(section.size, chartData.barStyle.barWidth, 0, 0))
                .position(x: barSize.midX,
                          y: chartData.getBarPositionX(dataPoint: dataPoint, height: barSize.height))
                .background(Color(.gray).opacity(0.000000001))
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = false
                }
                .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        }
    }
}
