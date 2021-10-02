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
    
    public let topLeading: CGFloat
    public let topTrailing: CGFloat
    public let bottomLeading: CGFloat
    public let bottomTrailing: CGFloat
    
    public init(
        topLeading: CGFloat = 15.0,
        topTrailing: CGFloat = 15.0,
        bottomLeading: CGFloat = 0.0,
        bottomTrailing: CGFloat = 0.0
    ) {
        self.topLeading = topLeading
        self.topTrailing = topTrailing
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
    }
    
    public init(
        top: CGFloat = 15.0,
        bottom: CGFloat = 0.0
    ) {
        self.topLeading = top
        self.topTrailing = top
        self.bottomLeading = bottom
        self.bottomTrailing = bottom
    }
    
    public init(
        leading: CGFloat = 0.0,
        trailing: CGFloat = 15.0
    ) {
        self.topLeading = leading
        self.topTrailing = trailing
        self.bottomLeading = leading
        self.bottomTrailing = trailing
    }
    
    public init(
        cornerRadius: CGFloat = 15.0
    ) {
        self.topLeading = cornerRadius
        self.topTrailing = cornerRadius
        self.bottomLeading = cornerRadius
        self.bottomTrailing = cornerRadius
    }
}
