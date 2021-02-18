//
//  BarChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for a single data point.
 
 # Example
 ```
 BarChartDataPoint(value: 20,
                   xAxisLabel: "M",
                   pointLabel: "Monday",
                   date: Date())
 ```
 
 # Options
 Common to all.
 ```
 BarChartDataPoint(value: Double,
                   xAxisLabel: String?,
                   pointLabel: String?,
                   date: Date?,
                   ...)
 ```
 
 Single Colour.
 ```
 BarChartDataPoint(...
                   colour: Color?)
 ```
 
 Gradient Colours.
 ```
 BarChartDataPoint(...
                   colours: [Color]?,
                   startPoint: UnitPoint?,
                   endPoint: UnitPoint?)
 ```
 
 Gradient Colours with stop control.
 ```
 BarChartDataPoint(...
                   stops: [GradientStop]?,
                   startPoint: UnitPoint?,
                   endPoint: UnitPoint?)
 ```
 
 # Also See
 - [GradientStopt](x-source-tag://GradientStop)
 
 # Conforms to
 - CTLineAndBarDataPoint
 - CTChartDataPoint
 - Hashable
 - Identifiable
 - CTColourStyle
 
 - Tag: BarChartDataPoint
 */
public struct BarChartDataPoint: CTStandardBarDataPoint {
    
    public let id = UUID()

    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    
    public var colourType   : ColourType
    public var colour       : Color?
    public var colours      : [Color]?
    public var stops        : [GradientStop]?
    public var startPoint   : UnitPoint?
    public var endPoint     : UnitPoint?
    
    // MARK: - init: single colour
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour for use with a bar chart.
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                colour      : Color?    = nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
        self.colourType = .colour
    }
    
    // MARK: - init: gradient colour
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colours: Array of colours for use with a bar chart.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint : End point for Gradient.
    public init(value       : Double,
                xAxisLabel  : String? = nil,
                pointLabel  : String? = nil,
                date        : Date? = nil,
                
                colours     : [Color]?   =  nil,
                startPoint  : UnitPoint? =  nil,
                endPoint    : UnitPoint? =  nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        
        self.colour     = nil
        self.stops      = nil
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.colourType  = .gradientColour
    }
    
    // MARK: - init: gradient with stops
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - stops: Array of GradientStop for use with a bar chart.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint : End point for Gradient.
    public init(value       : Double,
                xAxisLabel  : String? = nil,
                pointLabel  : String? = nil,
                date        : Date? = nil,
                stops       : [GradientStop]? = nil,
                startPoint  : UnitPoint? =  nil,
                endPoint    : UnitPoint? =  nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.colourType  = .gradientStops
    }
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

// MARK: - Grouped
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
