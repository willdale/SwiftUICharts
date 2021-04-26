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
    /// The charts title
    public var title: String
    /// Font of the title
    public var titleFont: Font
    /// Color of the title
    public var titleColour: Color
    
    /// The charts subtitle
    public var subtitle: String
    /// Font of the subtitle
    public var subtitleFont: Font
    /// Color of the subtitle
    public var subtitleColour: Color
    
    /// Model to hold the metadata for the chart.
    /// - Parameters:
    ///   - title: The charts title.
    ///   - subtitle: The charts subtitle.
    ///   - titleFont: Font of the title.
    ///   - titleColour: Color of the title.
    ///   - subtitleFont: Font of the subtitle.
    ///   - subtitleColour: Color of the subtitle.
    public init(
        title: String = "",
        subtitle: String = "",
        titleFont: Font = .title3,
        titleColour: Color = Color.primary,
        subtitleFont: Font = .subheadline,
        subtitleColour: Color = Color.primary
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleFont = titleFont
        self.titleColour = titleColour
        self.subtitleFont = subtitleFont
        self.subtitleColour = subtitleColour
    }
}
