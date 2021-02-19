//
//  PosistionIndicator.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

internal struct PosistionIndicator: View {
    
    private let fillColour : Color
    private let lineColour : Color
    private let lineWidth  : CGFloat
    
    internal init(fillColour : Color   = Color.primary,
                  lineColour : Color   = Color.blue,
                  lineWidth  : CGFloat = 3
    ) {
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth  = lineWidth
    }
    
    internal var body: some View {
        Circle()
            .fill(fillColour)
            .overlay(Circle()
                        .strokeBorder(lineColour, lineWidth: lineWidth)
            )
    }
}

public struct DotStyle {
    
    let size       : CGFloat
    let fillColour : Color
    let lineColour : Color
    let lineWidth  : CGFloat

    public init(size       : CGFloat    = 15,
                fillColour : Color      = Color.primary,
                lineColour : Color      = Color.blue,
                lineWidth  : CGFloat    = 3
    ) {
        self.size       = size
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth  = lineWidth
    }
}
