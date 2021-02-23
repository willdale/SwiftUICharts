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
internal struct ColourBar<DP: CTBarDataPoint>: View {
    
    private let colour      : Color
    private let dataPoint   : DP
    private let maxValue    : Double
    private let chartStyle  : BarChartStyle
    
    private let cornerRadius: CornerRadius
    private let barWidth    : CGFloat
    
    internal init(_ colour      : Color,
                  _ dataPoint   : DP,
                  _ maxValue    : Double,
                  _ chartStyle  : BarChartStyle,
                  _ cornerRadius: CornerRadius,
                  _ barWidth    : CGFloat
    ) {
        self.colour       = colour
        self.dataPoint    = dataPoint
        self.maxValue     = maxValue
        self.chartStyle   = chartStyle
        self.cornerRadius = cornerRadius
        self.barWidth     = barWidth
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: cornerRadius.top,
                                 tr: cornerRadius.top,
                                 bl: cornerRadius.bottom,
                                 br: cornerRadius.bottom)
            .fill(colour)
            .scaleEffect(y: startAnimation ? CGFloat(dataPoint.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

/**
 Sub view of a single bar using colour gradient.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientColoursBar<DP: CTBarDataPoint>: View {
    
    private let colours     : [Color]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    private let data        : DP
    private let maxValue    : Double
    private let chartStyle  : BarChartStyle
    
    private let cornerRadius: CornerRadius
    private let barWidth    : CGFloat
    
    internal init(_ colours     : [Color],
                  _ startPoint  : UnitPoint,
                  _ endPoint    : UnitPoint,
                  _ data        : DP,
                  _ maxValue    : Double,
                  _ chartStyle  : BarChartStyle,
                  _ cornerRadius: CornerRadius,
                  _ barWidth    : CGFloat
    ) {
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.data       = data
        self.maxValue   = maxValue
        self.chartStyle = chartStyle
        self.cornerRadius = cornerRadius
        self.barWidth     = barWidth
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: cornerRadius.top,
                                 tr: cornerRadius.top,
                                 bl: cornerRadius.bottom,
                                 br: cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

/**
 Sub view of a single bar using colour gradient with stop control.
 
 For Standard and Grouped Bar Charts.
 */
internal struct GradientStopsBar<DP: CTBarDataPoint>: View {
    
    private let stops       : [Gradient.Stop]
    private let startPoint  : UnitPoint
    private let endPoint    : UnitPoint
    private let data        : DP
    private let maxValue    : Double
    private let chartStyle  : BarChartStyle
    
    private let cornerRadius: CornerRadius
    private let barWidth    : CGFloat
    
    internal init(_ stops       : [Gradient.Stop],
                  _ startPoint  : UnitPoint,
                  _ endPoint    : UnitPoint,
                  _ data        : DP,
                  _ maxValue    : Double,
                  _ chartStyle  : BarChartStyle,
                  _ cornerRadius: CornerRadius,
                  _ barWidth    : CGFloat
    ) {
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.data       = data
        self.maxValue   = maxValue
        self.chartStyle = chartStyle
        self.cornerRadius = cornerRadius
        self.barWidth     = barWidth
    }
    
    @State private var startAnimation : Bool = false
    
    internal var body: some View {
        RoundedRectangleBarShape(tl: cornerRadius.top,
                                 tr: cornerRadius.top,
                                 bl: cornerRadius.bottom,
                                 br: cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}




// MARK: - Grouped
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
                    
                    if dataPoint.group.colourType == .colour,
                       let colour = dataPoint.group.colour
                    {
                        
                        ColourPartBar(colour, getHeight(height    : geo.size.height,
                                                        dataSet   : dataSet,
                                                        dataPoint : dataPoint))
                    
                    } else if dataPoint.group.colourType == .gradientColour,
                              let colours    = dataPoint.group.colours,
                              let startPoint = dataPoint.group.startPoint,
                              let endPoint   = dataPoint.group.endPoint
                    {

                        GradientColoursPartBar(colours, startPoint, endPoint, getHeight(height: geo.size.height,
                                                                                        dataSet   : dataSet,
                                                                                        dataPoint : dataPoint))

                    } else if dataPoint.group.colourType == .gradientStops,
                              let stops      = dataPoint.group.stops,
                              let startPoint = dataPoint.group.startPoint,
                              let endPoint   = dataPoint.group.endPoint
                    {

                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        
                        GradientStopsPartBar(safeStops, startPoint, endPoint, getHeight(height: geo.size.height,
                                                                                    dataSet   : dataSet,
                                                                                    dataPoint : dataPoint))
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

