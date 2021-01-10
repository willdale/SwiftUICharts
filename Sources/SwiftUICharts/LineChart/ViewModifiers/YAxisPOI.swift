//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

internal struct YAxisPOI: ViewModifier {
        
    @EnvironmentObject var chartData: ChartData
    
    private let markerName  : String
    private let markerValue : Double
    private let lineColour  : Color
    private let lineWidth   : CGFloat
        
    private let lineCap     : CGLineCap
    private let lineJoin    : CGLineJoin
    private let miterLimit  : CGFloat
    private let dash        : [CGFloat]
    private let dashPhase   : CGFloat
    
    private let isAverage   : Bool
        
    internal init(markerName  : String,
                  markerValue : Double = 0,
                  lineColour  : Color,
                  lineWidth   : CGFloat,
                  
                  lineCap    : CGLineCap,
                  lineJoin   : CGLineJoin,
                  miterLimit : CGFloat,
                  dash       : [CGFloat],
                  dashPhase  : CGFloat,
                  
                  isAverage  : Bool
    ) {
        self.markerName  = markerName
        self.markerValue = markerValue
        self.lineColour  = lineColour
        self.lineWidth   = lineWidth
        
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        self.dash       = dash
        self.dashPhase  = dashPhase
        
        self.isAverage = isAverage
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            Marker(chartData: chartData, markerValue: markerValue, isAverage: isAverage)
                .stroke(lineColour, style: StrokeStyle(lineWidth    : lineWidth,
                                                       lineCap      : lineCap,
                                                       lineJoin     : lineJoin,
                                                       miterLimit   : miterLimit,
                                                       dash         : dash,
                                                       dashPhase    : dashPhase))
                .onAppear {
                    if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                        chartData.legends.append(LegendData(legend: markerName,
                                                            colour: lineColour,
                                                            lineWidth: lineWidth,
                                                            lineCap: lineCap,
                                                            lineJoin: lineJoin,
                                                            miterLimit: miterLimit,
                                                            dash: dash,
                                                            dashPhase: dashPhase))
                    }
                }
        }
    }
}

extension View {
    public func yAxisPOI(markerName  : String,
                         markerValue : Double,
                         lineColour  : Color       = Color(.systemBlue),
                         lineWidth   : CGFloat     = 3,
                         
                         lineCap    : CGLineCap    = .round,
                         lineJoin   : CGLineJoin   = .round,
                         miterLimit : CGFloat      = 10,
                         dash       : [CGFloat]    = [CGFloat](),
                         dashPhase  : CGFloat      = 0
    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
                               markerValue  : markerValue,
                               lineColour   : lineColour,
                               lineWidth    : lineWidth,
                               lineCap      : lineCap,
                               lineJoin     : lineJoin,
                               miterLimit   : miterLimit,
                               dash         : dash,
                               dashPhase    : dashPhase,
                               isAverage    : false))
    }
    
    public func averageLine(markerName  : String    = "Average",
                            lineColour  : Color     = Color.primary,
                            lineWidth   : CGFloat   = 3,
                            
                            lineCap     : CGLineCap  = .round,
                            lineJoin    : CGLineJoin = .round,
                            miterLimit  : CGFloat    = 10,
                            dash        : [CGFloat]  = [CGFloat](),
                            dashPhase   : CGFloat    = 0
    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
                               lineColour   : lineColour,
                               lineWidth    : lineWidth,
                               lineCap      : lineCap,
                               lineJoin     : lineJoin,
                               miterLimit   : miterLimit,
                               dash         : dash,
                               dashPhase    : dashPhase,
                               isAverage    : true))
    }
}
