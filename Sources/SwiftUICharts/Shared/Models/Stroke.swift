//
//  Stroke.swift
//  
//
//  Created by Will Dale on 14/01/2021.
//

import SwiftUI

/// Replica of Apple's `StrokeStyle` that conforms to `Hashable`
public struct Stroke: Hashable {
    
    var lineWidth   : CGFloat
    var lineCap     : CGLineCap
    var lineJoin    : CGLineJoin
    var miterLimit  : CGFloat
    var dash        : [CGFloat]
    var dashPhase   : CGFloat
    
    public init(lineWidth : CGFloat      = 3,
                lineCap   : CGLineCap    = .round,
                lineJoin  : CGLineJoin   = .round,
                miterLimit: CGFloat      = 10,
                dash      : [CGFloat]    = [CGFloat](),
                dashPhase : CGFloat      = 0
    ) {
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        self.dash       = dash
        self.dashPhase  = dashPhase
    }
    
    /// Convert `StrokeStyle` to `Stroke`
    /// - Parameter strokeStyle: StrokeStyle
    /// - Returns: Stroke
    static internal func strokeStyleToStroke(strokeStyle: StrokeStyle) -> Stroke {
        return Stroke(lineWidth : strokeStyle.lineWidth,
                      lineCap   : strokeStyle.lineCap,
                      lineJoin  : strokeStyle.lineJoin,
                      miterLimit: strokeStyle.miterLimit,
                      dash      : strokeStyle.dash,
                      dashPhase : strokeStyle.dashPhase)
    }
    /// Convert `Stroke` to `StrokeStyle`
    /// - Parameter strokeStyle: StrokeStyle
    /// - Returns: Stroke
    static internal func strokeToStrokeStyle(stroke: Stroke) -> StrokeStyle {
        return StrokeStyle(lineWidth : stroke.lineWidth,
                           lineCap   : stroke.lineCap,
                           lineJoin  : stroke.lineJoin,
                           miterLimit: stroke.miterLimit,
                           dash      : stroke.dash,
                           dashPhase : stroke.dashPhase)
    }
    
}
