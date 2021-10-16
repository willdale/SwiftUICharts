//
//  InfoBoxStyle.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public struct InfoBoxStyle {
    public var valueFont: Font
    public var valueColour: Color
    public var descriptionFont: Font
    public var descriptionColour: Color
    public var backgroundColour: Color
    public var borderColour: Color
    public var borderStyle: StrokeStyle
        
    public init(
        valueFont: Font,
        valueColour: Color,
        descriptionFont: Font,
        descriptionColour: Color,
        backgroundColour: Color,
        borderColour: Color,
        borderStyle: StrokeStyle
    ) {
        self.valueFont = valueFont
        self.valueColour = valueColour
        self.descriptionFont = descriptionFont
        self.descriptionColour = descriptionColour
        self.backgroundColour = backgroundColour
        self.borderColour = borderColour
        self.borderStyle = borderStyle
    }
}

extension InfoBoxStyle {
    public static let bordered = InfoBoxStyle(valueFont: .title3,
                                              valueColour: Color.primary,
                                              descriptionFont: .caption,
                                              descriptionColour: Color.primary,
                                              backgroundColour: Color.systemsBackground,
                                              borderColour: Color.primary,
                                              borderStyle: StrokeStyle(lineWidth: 1))
    
    public static let borderless = InfoBoxStyle(valueFont: .title3,
                                                valueColour: Color.primary,
                                                descriptionFont: .caption,
                                                descriptionColour: Color.primary,
                                                backgroundColour: Color.systemsBackground,
                                                borderColour: Color.primary,
                                                borderStyle: StrokeStyle(lineWidth: 0))
    
    public static let grey = InfoBoxStyle(valueFont: .title3,
                                          valueColour: Color.primary,
                                          descriptionFont: .caption,
                                          descriptionColour: Color.primary,
                                          backgroundColour: Color.gray,
                                          borderColour: Color.primary,
                                          borderStyle: StrokeStyle(lineWidth: 0))
}
