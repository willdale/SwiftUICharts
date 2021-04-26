//
//  GroupingData.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

/**
 Model for grouping data points together so they can be drawn in the correct groupings.
 */
public struct GroupingData: CTBarColourProtocol, Hashable, Identifiable {
    
    public let id: UUID = UUID()
    public var title: String
    public var colour: ColourStyle
    
    /// Group with single colour
    /// - Parameters:
    ///   - title: Title for legends
    ///   - colour: Colour styling for the bars.
    public init(
        title: String,
        colour: ColourStyle
    ) {
        self.title = title
        self.colour = colour
    }
}
