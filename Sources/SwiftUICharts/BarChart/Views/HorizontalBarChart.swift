//
//  HorizontalBarChart.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

// MARK: - Chart
public struct HorizontalBarChart<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                VStack(spacing: 0) {
                    HorizontalBarChartSubView(chartData: chartData)
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
internal struct HorizontalBarChartSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
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
internal struct HorizontalBarElement<CD: CTBarChartDataProtocol & GetDataProtocol,
                                     DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    @ObservedObject private var chartData: CD
    private var dataPoint: DP
    private var fill: BarColour
    private var animations = HorizontalBarChartAnimation()
    private var index: Double
    
    @State private var fillAnimation: Bool = false
    @State private var lengthAnimation: Bool = false
    
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
        self._lengthAnimation = State<Bool>(initialValue: shouldAnimate)
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

                // Bredth
                .frame(height: BarLayout.barWidth(section.size.height, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index),
                           value: chartData.barStyle.barWidth)
            
                // Length
                .frame(width: lengthAnimation ?
                       BarLayout.barHeight(section.size.width, dataPoint.value, chartData.maxValue) :
                       0)
                .offset(CGSize(width: 0,
                               height: BarLayout.barXOffset(section.size.height, chartData.barStyle.barWidth)))
                .animation(animations.lengthAnimation(index),
                           value: dataPoint.value)
                .animateOnAppear(using: animations.lengthAnimationStart(index)) {
                    self.lengthAnimation = true
                }
        }
        .onDisappear {
            self.fillAnimation = false
            self.lengthAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        .id(chartData.id)
    }
}

// MARK: - Animation
public struct HorizontalBarChartAnimation {

    public var fill = Fill()
    public var length = Length()
    public var width = Width()

    public struct Fill {
        var startState: BarColour = .colour(colour: .clear)
        var start: Animation = .linear(duration: 0.0)
        var startDelay: Double = 0.0

        var transition: Animation = .linear(duration: 2.0)
        var transitionDelay: Double = 0.0
    }

    public struct Length {
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
    
    internal func lengthAnimationStart(_ index: Double) -> Animation {
        length.start.delay(index * length.startDelay)
    }
    internal func lengthAnimation(_ index: Double) -> Animation {
        length.transition.delay(index * length.transitionDelay)
    }
    
    internal func widthAnimation(_ index: Double) -> Animation {
        width.transition.delay(index * width.transitionDelay)
    }
}
