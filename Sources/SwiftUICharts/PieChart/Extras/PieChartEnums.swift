//
//  PieChartEnums.swift
//  
//
//  Created by Will Dale on 21/04/2021.
//

import SwiftUI

/**
 Option to add overlays on top of the segment.
 
 ```
 case none // No overlay
 case barStyle // Text overlay
 case dataPoints // System icon overlay
 ```
 */
public enum OverlayType: Hashable {
    /// No overlay
    case none
    
    /**
     Text overlay
     
     # Parameters:
     - text: Text the use as label.
     - colour: Foreground colour.
     - font: System font.
     - rFactor: Distance the from center of chart.
     0 is center, 1 is perimeter. It can go beyond 1 to
     place it outside.
     */
    case label(text: String, colour: Color = .primary, font: Font = .caption, rFactor: CGFloat = 0.75)
    
    /**
     System icon overlay
     
     # Parameters:
     - systemName: SF Symbols name.
     - colour: Foreground colour.
     - size: Image frame size.
     - rFactor: Distance the from center of chart.
     0 is center, 1 is perimeter. It can go beyond 1 to
     place it outside.
     */
    case icon(systemName: String, colour: Color = .primary, size: CGFloat = 30, rFactor: CGFloat = 0.75)
}
