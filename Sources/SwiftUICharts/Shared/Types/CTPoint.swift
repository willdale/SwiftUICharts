//
//  CTPoint.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import SwiftUI

struct CTPoint: Hashable {
    let x: CGFloat
    let y: CGFloat
    
    init(
        x: CGFloat,
        y: CGFloat
    ) {
        self.x = x
        self.y = y
    }
    
    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    var converted: CGPoint {
        CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    var convert: CTPoint {
        CTPoint(self)
    }
}
