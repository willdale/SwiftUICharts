//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

// MARK: Standard
/**
 Sub view of a single bar using a single colour.
 
 For Standard and Grouped Bar Charts.
 */
internal struct ColourBar<CD: CTBarChartDataProtocol,
                          DP: CTStandardDataPointProtocol & CTBarDataPoint>: View {
    
    private let chartData   : CD
    private let colour      : Color
    private let dataPoint   : DP
        
    internal init(chartData   : CD,
                  dataPoint   : DP,
                  colour      : Color
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.colour    = colour
    }
    
    @State private var startAnimation : Bool = false
    
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
            .accessibilityValue(chartData.getCellAccessibilityValue(dataPoint: dataPoint))
    }
}



/**
 Sub view of a single bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientColoursBar<CD: CTBarChartDataProtocol,
                                   DP: CTStandardDataPointProtocol & CTBarDataPoint>: View {
    
    private let chartData   : CD
    private let dataPoint   : DP
    private let colours     : [Color]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    
    internal init(chartData   : CD,
                  dataPoint   : DP,
                  colours     : [Color],
                  startPoint  : UnitPoint,
                  endPoint    : UnitPoint
    ) {
        self.chartData  = chartData
        self.dataPoint  = dataPoint
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
    
    @State private var startAnimation : Bool = false
    
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
            .accessibilityValue(chartData.getCellAccessibilityValue(dataPoint: dataPoint))
    }
}

/**
 Sub view of a single bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientStopsBar<CD: CTBarChartDataProtocol,
                                 DP: CTStandardDataPointProtocol & CTBarDataPoint>: View {
    
    private let chartData   : CD
    private let dataPoint   : DP
    private let stops       : [Gradient.Stop]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    
    internal init(chartData : CD,
                  dataPoint : DP,
                  stops     : [Gradient.Stop],
                  startPoint: UnitPoint,
                  endPoint  : UnitPoint
    ) {
        self.chartData  = chartData
        self.dataPoint  = dataPoint
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
    
    @State private var startAnimation : Bool = false
    
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
            .accessibilityValue(chartData.getCellAccessibilityValue(dataPoint: dataPoint))
    }
}

// MARK: - Stacked
/**
 Individual elements that make up a single bar.
 */
internal struct StackElementSubView: View {
    
    private let dataSet : MultiBarDataSet
    
    internal init(dataSet: MultiBarDataSet) {
        self.dataSet = dataSet
    }
    
    internal var body: some View {
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                ForEach(dataSet.dataPoints.reversed()) { dataPoint in
                    
                    if dataPoint.group.fillColour.colourType == .colour,
                       let colour = dataPoint.group.fillColour.colour
                    {
                        
                        ColourPartBar(colour, getHeight(height    : geo.size.height,
                                                        dataSet   : dataSet,
                                                        dataPoint : dataPoint))
                            .accessibilityValue(Text("\(dataPoint.value, specifier: "%.f"), \(dataPoint.pointDescription ?? "")"))
                        
                    } else if dataPoint.group.fillColour.colourType == .gradientColour,
                              let colours    = dataPoint.group.fillColour.colours,
                              let startPoint = dataPoint.group.fillColour.startPoint,
                              let endPoint   = dataPoint.group.fillColour.endPoint
                    {

                        GradientColoursPartBar(colours, startPoint, endPoint, getHeight(height: geo.size.height,
                                                                                        dataSet   : dataSet,
                                                                                        dataPoint : dataPoint))
                            .accessibilityValue(Text("\(dataPoint.value, specifier: "%.f") \(dataPoint.pointDescription ?? "")"))
                        
                    } else if dataPoint.group.fillColour.colourType == .gradientStops,
                              let stops      = dataPoint.group.fillColour.stops,
                              let startPoint = dataPoint.group.fillColour.startPoint,
                              let endPoint   = dataPoint.group.fillColour.endPoint
                    {

                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        
                        GradientStopsPartBar(safeStops, startPoint, endPoint, getHeight(height: geo.size.height,
                                                                                    dataSet   : dataSet,
                                                                                    dataPoint : dataPoint))
                            .accessibilityValue(Text("\(dataPoint.value, specifier: "%.f") \(dataPoint.pointDescription ?? "")"))
                    }
                    
                }
            }
        }
    }
    
    /// Sets the height of each element.
    /// - Parameters:
    ///   - height: Hiehgt of the whole bar.
    ///   - dataSet: Which data set the bar comes from.
    ///   - dataPoint: Data point to draw.
    /// - Returns: Height of the element.
    private func getHeight(height: CGFloat,
                           dataSet: MultiBarDataSet,
                           dataPoint: MultiBarChartDataPoint
    ) -> CGFloat {
        let value = dataPoint.value
        let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
        return height * CGFloat(value / sum)
    }
}


/**
 Sub view of an element of a bar using a single colour.
 
 For Stacked Bar Charts.
 */
internal struct ColourPartBar: View {
    
    private let colour  : Color
    private let height  : CGFloat
    
    internal init(_ colour  : Color,
                  _ height  : CGFloat
    ) {
        self.colour     = colour
        self.height     = height
    }
        
    internal var body: some View {
        Rectangle()
            .fill(colour)
            .frame(height: height)
    }
}

/**
 Sub view of an element of a bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientColoursPartBar: View {
    
    private let colours     : [Color]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    private let height      : CGFloat
    
    internal init(_ colours     : [Color],
                  _ startPoint  : UnitPoint,
                  _ endPoint    : UnitPoint,
                  _ height      : CGFloat
    ) {
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.height     = height
    }
        
    internal var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient   : Gradient(colors: colours),
                                 startPoint : startPoint,
                                 endPoint   : endPoint))
            .frame(height: height)
    }
}

/**
 Sub view of an element of a bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientStopsPartBar: View {
    
    private let stops       : [Gradient.Stop]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    private let height      : CGFloat
    
    internal init(_ stops       : [Gradient.Stop],
                  _ startPoint  : UnitPoint,
                  _ endPoint    : UnitPoint,
                  _ height      : CGFloat
    ) {
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.height     = height
    }
        
    internal var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient   : Gradient(stops: stops),
                                 startPoint : startPoint,
                                 endPoint   : endPoint))
            .frame(height: height)
    }
}
