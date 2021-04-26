//
//  PosistionIndicator.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

/**
 A dot that follows the line on touch events.
 */
internal struct PosistionIndicator: View {
    
    private let fillColour: Color
    private let lineColour: Color
    private let lineWidth: CGFloat
    
    internal init(
        fillColour: Color = Color.primary,
        lineColour: Color = Color.blue,
        lineWidth: CGFloat = 3
    ) {
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth = lineWidth
    }
    
    internal var body: some View {
        ZStack {
            Circle()
                .foregroundColor(lineColour)
            Circle()
                .foregroundColor(fillColour)
                .padding(EdgeInsets(top: lineWidth, leading: lineWidth, bottom: lineWidth, trailing: lineWidth))
        }
    }
}

/**
 Styling of the dot that follows the line on touch events.
 */
public struct DotStyle {
    
    let size: CGFloat
    let fillColour: Color
    let lineColour: Color
    let lineWidth: CGFloat
    
    /// Sets the style of the Posistion Indicator
    /// - Parameters:
    ///   - size: Size of the Indicator.
    ///   - fillColour: Fill colour.
    ///   - lineColour: Border colour.
    ///   - lineWidth: Border width.
    public init(
        size: CGFloat = 15,
        fillColour: Color = Color.primary,
        lineColour: Color = Color.blue,
        lineWidth: CGFloat = 3
    ) {
        self.size = size
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth = lineWidth
    }
}
