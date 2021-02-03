//
//  ChartMetadata.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import Foundation

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
    var title       : String?
    /// The charts subtitle
    var subtitle    : String?
    
    /// Model to hold the metadata for the chart.
    /// - Parameters:
    ///   - title: The charts title
    ///   - subtitle: The charts subtitle
    public init(title       : String? = nil,
                subtitle    : String? = nil
    ) {
        self.title      = title
        self.subtitle   = subtitle        
    }
}
