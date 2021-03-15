//
//  ChartMetadata.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

/**
 Data model for the chart's metadata
 
 Contains the Title, Subtitle and colour information for them.
 */
public struct ChartMetadata {
<<<<<<< HEAD
    /// The charts Title
    public var title       : String?
    /// The charts subtitle
    public var subtitle    : String?
    /// The title for the legend
    public var lineLegend  : String?
=======
    /// The charts title
    public var title         : String
    /// The charts subtitle
    public var subtitle      : String
    /// Color of the title
    public var titleColour   : Color
    /// Color of the subtitle
    public var subtitleColour: Color
>>>>>>> version-2
    
    /// Model to hold the metadata for the chart.
    /// - Parameters:
    ///   - title: The charts title
    ///   - subtitle: The charts subtitle
    ///   - titleColour: Color of the title
    ///   - subtitleColour: Color of the subtitle
    public init(title         : String = "",
                subtitle      : String = "",
                titleColour   : Color = Color.primary,
                subtitleColour: Color = Color.primary
    ) {
        self.title          = title
        self.subtitle       = subtitle
        self.titleColour    = titleColour
        self.subtitleColour = subtitleColour
    }
}
