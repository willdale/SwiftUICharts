//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

// MARK: - Standard
//
//
//
// MARK: Colour
/**
 Sub view of a single bar using a single colour.
 
 For Standard and Grouped Bar Charts.
 */
internal struct ColourBar<CD: CTBarChartDataProtocol,
                          DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let colour: Color
    private let dataPoint: DP
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        colour: Color
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colour = colour
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(colour)
            .scaleEffect(y: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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


// MARK: Gradient
/**
 Sub view of a single bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientColoursBar<CD: CTBarChartDataProtocol,
                                   DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let dataPoint: DP
    private let colours: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        colours: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colours = colours
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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


// MARK: Gradient Stops
/**
 Sub view of a single bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientStopsBar<CD: CTBarChartDataProtocol,
                                 DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let dataPoint: DP
    private let stops: [Gradient.Stop]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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

// MARK: - Stacked
/**
 Individual elements that make up a single bar.
 */
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
                        ColourPartBar(colour, getHeight(height: geo.size.height,
                                                        dataSet: dataSet,
                                                        dataPoint: dataPoint))
                            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                    } else if dataPoint.group.colour.colourType == .gradientColour,
                              let colours = dataPoint.group.colour.colours,
                              let startPoint = dataPoint.group.colour.startPoint,
                              let endPoint = dataPoint.group.colour.endPoint
                    {
                        GradientColoursPartBar(colours, startPoint, endPoint, getHeight(height: geo.size.height,
                                                                                        dataSet: dataSet,
                                                                                        dataPoint: dataPoint))
                            .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: specifier))
                    } else if dataPoint.group.colour.colourType == .gradientStops,
                              let stops = dataPoint.group.colour.stops,
                              let startPoint = dataPoint.group.colour.startPoint,
                              let endPoint = dataPoint.group.colour.endPoint
                    {
                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        GradientStopsPartBar(safeStops, startPoint, endPoint, getHeight(height: geo.size.height,
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
    private func getHeight(
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

// MARK: Colour
/**
 Sub view of an element of a bar using a single colour.
 
 For Stacked Bar Charts.
 */
internal struct ColourPartBar: View {
    
    private let colour: Color
    private let height: CGFloat
    
    internal init(
        _ colour: Color,
        _ height: CGFloat
    ) {
        self.colour = colour
        self.height = height
    }
    
    internal var body: some View {
        Rectangle()
            .fill(colour)
            .frame(height: height)
    }
}

// MARK: Gradient
/**
 Sub view of an element of a bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientColoursPartBar: View {
    
    private let colours: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let height: CGFloat
    
    internal init(
        _ colours: [Color],
        _ startPoint: UnitPoint,
        _ endPoint: UnitPoint,
        _ height: CGFloat
    ) {
        self.colours = colours
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.height = height
    }
    
    internal var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .frame(height: height)
    }
}

// MARK: Gradient Stops
/**
 Sub view of an element of a bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientStopsPartBar: View {
    
    private let stops: [Gradient.Stop]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let height: CGFloat
    
    internal init(
        _ stops: [Gradient.Stop],
        _ startPoint: UnitPoint,
        _ endPoint: UnitPoint,
        _ height: CGFloat
    ) {
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.height = height
    }
    
    internal var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .frame(height: height)
    }
}

// MARK: - Ranged
//
//
//
// MARK: Colour
internal struct RangedBarChartColourCell<CD:RangedBarChartData>: View {
    
    private let chartData: CD
    private let dataPoint: CD.SetType.DataPoint
    private let colour: Color
    private let barSize: CGRect
    
    internal init(
        chartData: CD,
        dataPoint: CD.SetType.DataPoint,
        colour: Color,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colour = colour
        self.barSize = barSize
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(colour)
            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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

// MARK: Gradient
internal struct RangedBarChartColoursCell<CD:RangedBarChartData>: View {
    
    private let chartData: CD
    private let dataPoint: CD.SetType.DataPoint
    private let colours: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let barSize: CGRect
    
    internal init(
        chartData: CD,
        dataPoint: CD.SetType.DataPoint,
        colours: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colours = colours
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.barSize = barSize
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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

// MARK: Gradient Stops
internal struct RangedBarChartStopsCell<CD:RangedBarChartData>: View {
    
    private let chartData: CD
    private let dataPoint: CD.SetType.DataPoint
    private let stops: [Gradient.Stop]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let barSize: CGRect
    
    internal init(
        chartData: CD,
        dataPoint: CD.SetType.DataPoint,
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        barSize: CGRect
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.barSize = barSize
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.top,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat((dataPoint.upperValue - dataPoint.lowerValue) / chartData.range) : 0, anchor: .center)
            .scaleEffect(x: chartData.barStyle.barWidth, anchor: .center)
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

// MARK: - Horizontal
//
//
//
// MARK: Colour
/**
 Sub view of a single bar using a single colour.
 
 For Standard and Grouped Bar Charts.
 */
internal struct HorizontalColourBar<CD: CTBarChartDataProtocol,
                                    DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let colour: Color
    private let dataPoint: DP
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        colour: Color
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colour = colour
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.bottom,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.top)
            .fill(colour)
            .scaleEffect(x: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .leading)
            .scaleEffect(y: chartData.barStyle.barWidth, anchor: .center)
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


// MARK: Gradient
/**
 Sub view of a single bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct HorizontalGradientColoursBar<CD: CTBarChartDataProtocol,
                                             DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let dataPoint: DP
    private let colours: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        colours: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colours = colours
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.bottom,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.top)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(x: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .leading)
            .scaleEffect(y: chartData.barStyle.barWidth, anchor: .center)
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


// MARK: Gradient Stops
/**
 Sub view of a single bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct HorizontalGradientStopsBar<CD: CTBarChartDataProtocol,
                                           DP: CTStandardDataPointProtocol & CTBarDataPointBaseProtocol>: View {
    
    private let chartData: CD
    private let dataPoint: DP
    private let stops: [Gradient.Stop]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    
    internal init(
        chartData: CD,
        dataPoint: DP,
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: chartData.barStyle.cornerRadius.bottom,
                                 tr: chartData.barStyle.cornerRadius.top,
                                 bl: chartData.barStyle.cornerRadius.bottom,
                                 br: chartData.barStyle.cornerRadius.top)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(x: startAnimation ? CGFloat(dataPoint.value / chartData.maxValue) : 0, anchor: .leading)
            .scaleEffect(y: chartData.barStyle.barWidth, anchor: .center)
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
