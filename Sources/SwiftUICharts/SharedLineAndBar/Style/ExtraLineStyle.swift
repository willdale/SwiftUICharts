//
//  ExtraLineStyle.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

/**
  Control of the styling of the Extra Line.
 */
public struct ExtraLineStyle: Hashable {
    
    public var lineColour: ColourStyle
    public var lineType: LineType
    public var lineSpacing: SpacingType
    
    public var strokeStyle: Stroke
    
    public var pointStyle: PointStyle
    
    public var yAxisTitle: String?
    public var yAxisNumberOfLabels: Int
    
    public var animationType: AnimationType
    
    public var baseline: Baseline
    public var topLine: Topline

    public init(
        lineColour: ColourStyle = ColourStyle(colour: .red),
        lineType: LineType = .curvedLine,
        lineSpacing: SpacingType = .line,
        
        strokeStyle: Stroke = Stroke(),
        pointStyle: PointStyle = PointStyle(),
        
        yAxisTitle: String? = nil,
        yAxisNumberOfLabels: Int = 7,
        
        animationType: AnimationType = .draw,
        
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.lineColour = lineColour
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        
        self.strokeStyle = strokeStyle
        self.pointStyle = pointStyle
        
        self.yAxisTitle = yAxisTitle
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        
        self.animationType = animationType
        
        self.baseline = baseline
        self.topLine = topLine
    }
    
    /**
     Controls which animations will be used.
     
     When using a line chart `.draw` is probably the
     right one to choose.
     
     When using on a filled line chart or on bar charts
     `.raise` is probably the right one to choose.
     
     ```
     case draw // Draws the line using `.trim`.
     case raise // Animates using `.scale`.
     ```
     */
    public enum AnimationType: Hashable {
        /// Draws the line using `.trim`.
        case draw
        /// Animates using `.scale`.
        case raise
    }
    
    /**
     Sets what type of chart is being used.
     
     There is different spacing for line charts and bar charts,
     this sets that up.
     */
    public enum SpacingType: Hashable {
        case line
        case bar
    }
}
