//
//  LegendLine.swift
//  LineChart
//
//  Created by Will Dale on 05/01/2021.
//

import SwiftUI

struct LegendLine : Shape {
    
    let width : CGFloat
    
    init(width : CGFloat = 20) {
        self.width = width
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        
        return path
    }
}
