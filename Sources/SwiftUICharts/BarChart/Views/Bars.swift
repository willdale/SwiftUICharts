//
//  Bars.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

struct ColourBar: View {
    
    let colour  : Color
    let data    : ChartDataPoint
    let maxValue: Double
    let style   : BarStyle
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(colour)
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: .linear(duration: 1.0)) {
                self.startAnimation.toggle()
            }
    }
}

struct GradientColoursBar: View {

    let colours     : [Color]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    let data        : ChartDataPoint
    let maxValue    : Double
    let style       : BarStyle
    
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: Animation.linear(duration: 1.0)) {
                self.startAnimation.toggle()
            }
    }
}

struct GradientStopsBar: View {

    let stops       : [Gradient.Stop]
    let startPoint  : UnitPoint
    let endPoint    : UnitPoint
    let data        : ChartDataPoint
    let maxValue    : Double
    let style       : BarStyle
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        RoundedRectangleBarShape(tl: style.cornerRadius.top, tr: style.cornerRadius.top, bl: style.cornerRadius.bottom, br: style.cornerRadius.bottom)
            .fill(LinearGradient(gradient: Gradient(stops: stops),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .scaleEffect(y: startAnimation ? CGFloat(data.value / maxValue) : 0, anchor: .bottom)
            .scaleEffect(x: style.barWidth, anchor: .center)
            .animateOnAppear(using: .linear(duration: 1.0)) {
                self.startAnimation.toggle()
            }
    }
}


