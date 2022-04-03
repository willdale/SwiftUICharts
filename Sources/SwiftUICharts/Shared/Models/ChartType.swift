//
//  ChartType.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

/**
 The type of chart being used.
 ```
 case line // Line Chart Type
 case bar // Bar Chart Type
 case pie // Pie Chart Type
 case extraLine // Extra Line Type
 ```
 */
public enum ChartType {
    /// Line Chart Type
    case line
    /// Bar Chart Type
    case bar
    /// Pie Chart Type
    case pie
    /// Extra Line Type
    case extraLine
}

public struct AnyShape: Shape {
    private var base: (CGRect) -> Path
    
    public init<S: Shape>(shape: S) {
        base = shape.path(in:)
    }
    
    public func path(in rect: CGRect) -> Path {
        base(rect)
    }
}
