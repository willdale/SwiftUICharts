//
//  HashablePoint.swift
//  
//
//  Created by Will Dale on 03/02/2021.
//

import SwiftUI

/**
 A hashable version of CGPoint
 */
public struct HashablePoint: Hashable {

   public let x : CGFloat
   public let y : CGFloat

    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
