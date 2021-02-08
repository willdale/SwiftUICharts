//
//  ChartMetadata.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

/**
 Data model for the chart's metadata
 
 Contains the Title, Subtitle and Title for Legend.
 
 # Example
 ```
 let metadata = ChartMetadata(title: "Some Data", subtitle: "A Week")
 ```
 
 - Tag: ChartMetadata
 */
public struct ChartMetadata {
    /// The charts title
    var title         : String
    /// The charts subtitle
    var subtitle      : String
    /// Color of the title
    var titleColour   : Color
    /// Color of the subtitle
    var subtitleColour: Color
    
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
