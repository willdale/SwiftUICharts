//
//  BarStyle.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

/**
 Model for controlling the aesthetic of the bars.
 */
public struct BarStyle: CTBarStyle {
    
    public var barWidth: CGFloat
    public var cornerRadius: CornerRadius
    public var colourFrom: ColourFrom
    public var colour: ColourStyle
    
    // MARK: - Single colour
    /// Bar Chart with single colour
    /// - Parameters:
    ///   - barWidth: How much of the available width to use. 0...1
    ///   - cornerRadius: Corner radius of the bar shape.
    ///   - colourFrom: Where to get the colour data from.
    ///   - colour: Set up colour styling.
    public init(
        barWidth: CGFloat = 1,
        cornerRadius: CornerRadius = CornerRadius(top: 5.0, bottom: 0.0),
        colourFrom: ColourFrom = .barStyle,
        colour: ColourStyle = ColourStyle(colour: .red)
    ) {
        self.barWidth = barWidth
        self.cornerRadius = cornerRadius
        self.colourFrom = colourFrom
        self.colour = colour
    }
}
