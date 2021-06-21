//
//  PointStyle.swift
//  LineChart
//
//  Created by Will Dale on 04/01/2021.
//

import SwiftUI

/**
 Model for controlling the aesthetic of the point markers.
 
 Point markers are placed on top of the line, marking where the data points are.
 */
public struct PointStyle: Hashable {
    
    /// Overall size of the mark
    public var pointSize: CGFloat
    
    /// Outter ring colour
    public var borderColour: Color
    
    /// Center fill colour
    public var fillColour: Color
    
    /// Outter ring line width
    public var lineWidth: CGFloat
    
    /// Style of the point marks
    public var pointType: PointType
    
    /// Shape of the points
    public var pointShape: PointShape
    
    /// Styling for the point markers.
    /// - Parameters:
    ///   - pointSize: Overall size of the mark
    ///   - borderColour: Outter ring colour
    ///   - fillColour: Center fill colour
    ///   - lineWidth: Outter ring line width
    ///   - pointType: Style of the point marks
    ///   - pointShape: Shape of the points
    public init(
        pointSize: CGFloat = 9,
        borderColour: Color = .primary,
        fillColour: Color = Color(.gray),
        lineWidth: CGFloat = 3,
        pointType: PointType = .outline,
        pointShape: PointShape = .circle
    ) {
        self.pointSize = pointSize
        self.borderColour = borderColour
        self.fillColour = fillColour
        self.lineWidth = lineWidth
        self.pointType = pointType
        self.pointShape = pointShape
    }
}

public struct PointColour: Hashable {
    public let border: Color
    public let fill: Color
    
    public init(
        border: Color = .primary,
        fill: Color = .primary
    ) {
        self.border = border
        self.fill = fill
    }
}

