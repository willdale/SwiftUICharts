//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

// MARK: - Standard
internal struct BarElement<CD: CTBarChartDataProtocol & GetDataProtocol,
                           DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol,
                           S: ShapeStyle>: View {
    
    private let chartData: CD
    private let fill: S
    private let dataPoint: DP
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        fill: S
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                .fill(fill)
                .frame(startAnimation ?
                        chartData.barFrame(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                        chartData.barFrame(section.size, chartData.barStyle.barWidth, 0, 0))
                .offset(startAnimation ?
                            chartData.barOffset(section.size, chartData.barStyle.barWidth, dataPoint.value, chartData.maxValue) :
                            chartData.barOffset(section.size, chartData.barStyle.barWidth, 0, 0))
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
                    if dataPoint.group.colour.colourType == .colour,
                       let colour = dataPoint.group.colour.colour
                    {
                        StackBarElement(colour, elementHeight(height: geo.size.height,
                                                              dataSet: dataSet,
                                                              dataPoint: dataPoint))
                            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                    } else if dataPoint.group.colour.colourType == .gradientColour,
                              let colours = dataPoint.group.colour.colours,
                              let startPoint = dataPoint.group.colour.startPoint,
                              let endPoint = dataPoint.group.colour.endPoint
                    {
                        StackBarElement(LinearGradient(gradient: Gradient(colors: colours),
                                                       startPoint: startPoint,
                                                       endPoint: endPoint),
                                        elementHeight(height: geo.size.height,
                                                      dataSet: dataSet,
                                                      dataPoint: dataPoint))
                            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                    } else if dataPoint.group.colour.colourType == .gradientStops,
                              let stops = dataPoint.group.colour.stops,
                              let startPoint = dataPoint.group.colour.startPoint,
                              let endPoint = dataPoint.group.colour.endPoint
                    {
                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        StackBarElement(LinearGradient(gradient: Gradient(stops: safeStops),
                                                       startPoint: startPoint,
                                                       endPoint: endPoint),
                                        elementHeight(height: geo.size.height,
                                                      dataSet: dataSet,
                                                      dataPoint: dataPoint))
                            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                    }
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
internal struct StackBarElement<S>: View where S: ShapeStyle {
    
    private let fill: S
    private let height: CGFloat
    
    internal init(
        _ fill: S,
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
internal struct RangedBarCell<CD, S>: View where CD: RangedBarChartData,
                                                 S: ShapeStyle {
    
    private let chartData: CD
    private let dataPoint: CD.SetType.DataPoint
    private let fill: S
    private let barSize: CGRect
    
    internal init(
        chartData: CD,
        dataPoint: CD.SetType.DataPoint,
        fill: S,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.barSize = barSize
    }
    
    @State private var startAnimation: Bool = false
    
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

// MARK: - Horizontal
internal struct HorizontalBarElement<CD: CTBarChartDataProtocol & GetDataProtocol,
                                     DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol,
                                     S: ShapeStyle>: View {
    private let chartData: CD
    private let fill: S
    private let dataPoint: DP
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        fill: S
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
    }
    
    @State private var startAnimation: Bool = false
    
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
