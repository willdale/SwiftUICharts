//
//  Stroke.swift
//  
//
//  Created by Will Dale on 14/01/2021.
//

import SwiftUI

/**
 A hashable version of StrokeStyle
 
 StrokeStyle doesn't conform to Hashable.
 */
public struct Stroke: Hashable, Identifiable {
    
    public let id: UUID = UUID()
    
    private let lineWidth: CGFloat
    private let lineCap: CGLineCap
    private let lineJoin: CGLineJoin
    private let miterLimit: CGFloat
    private let dash: [CGFloat]
    private let dashPhase: CGFloat
    
    public init(
        lineWidth: CGFloat = 3,
        lineCap: CGLineCap = .round,
        lineJoin: CGLineJoin = .round,
        miterLimit: CGFloat = 10,
        dash: [CGFloat] = [CGFloat](),
        dashPhase: CGFloat = 0
    ) {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
    
    static let `default` = Stroke()
}

extension Stroke {
    /// Convert `Stroke` to `StrokeStyle`
    internal func strokeToStrokeStyle() -> StrokeStyle {
        StrokeStyle(lineWidth: self.lineWidth,
                    lineCap: self.lineCap,
                    lineJoin: self.lineJoin,
                    miterLimit: self.miterLimit,
                    dash: self.dash,
                    dashPhase: self.dashPhase)
    }
}

extension StrokeStyle {
    /// Convert `StrokeStyle` to `Stroke`
    internal func toStroke() -> Stroke {
        Stroke(lineWidth: self.lineWidth,
               lineCap: self.lineCap,
               lineJoin: self.lineJoin,
               miterLimit: self.miterLimit,
               dash: self.dash,
               dashPhase: self.dashPhase)
    }
}
