//
//  Baseline.swift
//  
//
//  Created by Will Dale on 12/05/2024.
//

import Foundation

/// Where to start drawing the line chart from.
///
/// ```
/// case minimumValue // Lowest value in the data set(s)
/// case minimumWithMaximum(of: Double) // Set a custom baseline
/// case zero // Set 0 as the lowest value
/// ```
public enum Baseline: Hashable {
    /// Lowest value in the data set(s)
    case minimumValue
    /// Set a custom baseline
    case minimumWithMaximum(of: Double)
    /// Set 0 as the lowest value
    case zero
}
