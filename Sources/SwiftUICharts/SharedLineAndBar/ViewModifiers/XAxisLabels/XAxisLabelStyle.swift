//
//  XAxisLabelStyle.swift
//  
//
//  Created by Will Dale on 13/03/2022.
//

import SwiftUI

public struct XAxisLabelStyle {
    public var font: Font
    public var fontColour: Color
    public var rotation: Angle
    public var inBounds: Bool
    public var padding: CGFloat
    
    public init(
        font: Font = .caption,
        fontColour: Color = .primary,
        rotation: Angle = .degrees(0),
        inBounds: Bool = false,
        padding: CGFloat = 8
    ) {
        self.font = font
        self.fontColour = fontColour
        self.rotation = rotation
        self.inBounds = inBounds
        self.padding = padding
    }
    
    public enum Data {
        case datapoints
        case custom(labels: [String])
    }
    
    public struct XLabelData {

        public let chart: ChartName
        public let spacing: CGFloat?
        
        public init(
            chart: ChartName,
            spacing: CGFloat? = nil
        ) {
            self.chart = chart
            self.spacing = spacing
        }
    }

    internal enum AxisOrientation {
        case vertical
        case horizontal
    }
}

extension XAxisLabelStyle {
    public static let standard = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(0))
    
    public static let standard90 = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(90))
}
