//
//  Topline.swift
//  
//
//  Created by Will Dale on 12/05/2024.
//

import Foundation

/// Where to end drawing the chart.
///
/// ```
/// case maximumValue // Highest value in the data set(s)
/// case maximum(of: Double) // Set a custom topline
/// ```
public enum Topline: Hashable {
    /// Highest value in the data set(s)
    case maximumValue
    /// Set a custom topline
    case maximum(of: Double)
}
