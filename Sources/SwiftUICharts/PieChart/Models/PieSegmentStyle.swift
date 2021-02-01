//
//  PieSegmentStyle.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

public struct PieSegmentStyle: CTColourStyle, Hashable {

    public var colourType   : ColourType
    public var colour       : Color?
    public var colours      : [Color]?
    public var stops        : [GradientStop]?
    public var startPoint   : UnitPoint?
    public var endPoint     : UnitPoint?
    
    public init(colour      : Color?          = nil,
                colours     : [Color]?        = nil,
                stops       : [GradientStop]? = nil,
                startPoint  : UnitPoint?      = nil,
                endPoint    : UnitPoint?      = nil
    ) {
        self.colourType     = .colour
        self.colour         = colour
        self.colours        = colours
        self.stops          = stops
        self.startPoint     = startPoint
        self.endPoint       = endPoint
    }
}
