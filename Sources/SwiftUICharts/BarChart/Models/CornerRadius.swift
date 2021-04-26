//
//  CornerRadius.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Corner radius of the bar shape.
 */
public struct CornerRadius: Hashable {
    
    public let top: CGFloat
    public let bottom: CGFloat
    
    /// Set the coner radius for the bar shapes
    public init(
        top: CGFloat = 15.0,
        bottom: CGFloat = 0.0
    ) {
        self.top = top
        self.bottom = bottom
    }
}
