//
//  YAxisLabelStyle.swift
//  
//
//  Created by Will Dale on 13/03/2022.
//

import Foundation

public struct YAxisLabelStyle {
    public var font: Font
    public var colour: Color
    public var number: Int
    public var formatter: NumberFormatter
    public var padding: CGFloat

    public init(
        font: Font = .caption,
        colour: Color = .primary,
        number: Int = 10,
        formatter: NumberFormatter = .default,
        padding: CGFloat = 8
    ) {
        self.font = font
        self.colour = colour
        self.number = number
        self.formatter = formatter
        self.padding = padding
    }

    public enum Data {
        case generated
        case custom(labels: [String])
    }
    
    internal enum AxisOrientation {
        case vertical
        case horizontal
    }
}

extension YAxisLabelStyle {
    public static let standard = YAxisLabelStyle(font: .caption,
                                                 colour: .primary,
                                                 number: 10,
                                                 formatter: .default)
}
