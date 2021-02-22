//
//  GroupedBarChartDataPoint.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

public struct GroupedBarChartDataPoint: CTGroupedBarDataPoint {
    
    public let id = UUID()

    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?

    public var group     : GroupingData
    
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                group: GroupingData
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        
        self.group            = group

    }
    public typealias ID = UUID
}

public struct GroupingData: CTColourStyle, Hashable, Identifiable {
    
    public let id        : UUID = UUID()
    public var title     : String
    public var colourType: ColourType
    public var colour    : Color?
    public var colours   : [Color]?
    public var stops     : [GradientStop]?
    public var startPoint: UnitPoint?
    public var endPoint  : UnitPoint?
     
    public init(title   : String,
                colour  : Color
    ) {
        self.title      = title
        self.colourType = .colour
        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
    }
    
    public init(title       : String,
                colours     : [Color],
                startPoint  : UnitPoint,
                endPoint    : UnitPoint
    ) {
        self.title      = title
        self.colourType = .gradientColour
        self.colour     = nil
        self.colours    = colours
        self.stops      = nil
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
    
    public init(title       : String,
                stops       : [GradientStop],
                startPoint  : UnitPoint,
                endPoint    : UnitPoint
    ) {
        self.title      = title
        self.colourType = .gradientStops
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
}
