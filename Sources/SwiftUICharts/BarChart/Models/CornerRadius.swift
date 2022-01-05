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
    
    public let topLeft: CGFloat
    public let topRight: CGFloat
    public let bottomLeft: CGFloat
    public let bottomRight: CGFloat
    
    /// Set the coner radius for the bar shapes for top and bottom
    public init(
        top: CGFloat = 15.0,
        bottom: CGFloat = 0.0
    ) {
        self.topLeft = top
        self.topRight = top
        self.bottomLeft = bottom
        self.bottomRight = bottom
    }
    
    /// Set the coner radius for the bar shapes for left and right
    public init(
        left: CGFloat = 0.0,
        right: CGFloat = 0.0
    ) {
        self.topLeft = left
        self.topRight = right
        self.bottomLeft = left
        self.bottomRight = right
    }
    
    /// Set the coner radius for the bar shapes for all corners
    public init(
        topLeft: CGFloat = 0,
        topRight: CGFloat = 0,
        bottomLeft: CGFloat = 0,
        bottomRight: CGFloat = 0
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
}
