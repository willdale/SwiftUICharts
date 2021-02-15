//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

// MARK: Standard
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
        self.colour     = colour
        self.dataPoint  = dataPoint
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




// MARK: - Multi Part
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
