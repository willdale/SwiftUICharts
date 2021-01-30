//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

struct ColourBar: View {
    
    let colour      : Color
    let data        : ChartDataPoint
    let maxValue    : Double
    let chartStyle  : ChartStyle
    let style       : BarStyle
    
    init(_ colour      : Color,
         _ data        : ChartDataPoint,
         _ maxValue    : Double,
         _ chartStyle  : ChartStyle,
         _ style       : BarStyle
    ) {
        self.colour     = colour
        self.data       = data
        self.maxValue   = maxValue
        self.chartStyle = chartStyle
        self.style      = style
    }
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(colour)
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

struct GradientColoursBar: View {

    let colours     : [Color]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    let data        : ChartDataPoint
    let maxValue    : Double
    let chartStyle  : ChartStyle
    let style       : BarStyle
    
    init(_ colours     : [Color],
         _ startPoint  : UnitPoint,
         _ endPoint    : UnitPoint,
         _ data        : ChartDataPoint,
         _ maxValue    : Double,
         _ chartStyle  : ChartStyle,
         _ style       : BarStyle
    ) {
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.data       = data
        self.maxValue   = maxValue
        self.chartStyle = chartStyle
        self.style      = style
    }

    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}

struct GradientStopsBar: View {

    let stops       : [Gradient.Stop]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    let data        : ChartDataPoint
    let maxValue    : Double
    let chartStyle  : ChartStyle
    let style       : BarStyle
    
    init(_ stops       : [Gradient.Stop],
         _ startPoint  : UnitPoint,
         _ endPoint    : UnitPoint,
         _ data        : ChartDataPoint,
         _ maxValue    : Double,
         _ chartStyle  : ChartStyle,
         _ style       : BarStyle
    ) {
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.data       = data
        self.maxValue   = maxValue
        self.chartStyle = chartStyle
        self.style      = style
    }
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisAppear(using: chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}


