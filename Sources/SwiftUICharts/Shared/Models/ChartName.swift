//
//  ChartName.swift
//  
//
//  Created by Will Dale on 23/01/2022.
//

import Foundation

public enum ChartName {
    case line
    case filledLine
    case multiLine
    case rangedLine
    
    case bar
    case groupedBar
    case rangedBar
    case stackedBar
    case horizontalBar
    
    case pie
    case doughnut
    
    var isBar: Bool {
        switch self {
        case .bar,
             .groupedBar,
             .rangedBar,
             .stackedBar,
             .horizontalBar:
            return true
        case .line,
             .filledLine,
             .multiLine,
             .rangedLine,
             .pie,
             .doughnut:
            return false
        }
    }
    
    enum Orientation {
        case vertical
        case horizontal
        case none
    }
}
