//
//  AccessibilityRectangle.swift
//  
//
//  Created by Will Dale on 31/03/2021.
//

import SwiftUI

/**
 Add rectangle overlay when in Voice Reader mode.
 */
internal struct AccessibilityRectangle: Shape {
    
    private let dataPointCount: Int
    private let dataPointNo: Int
    
    internal init(
        dataPointCount: Int,
        dataPointNo: Int
    ) {
        self.dataPointCount = dataPointCount
        self.dataPointNo = dataPointNo
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        let x = rect.width / CGFloat(dataPointCount-1)
        let pointX: CGFloat = (CGFloat(dataPointNo) * x) - x / CGFloat(2)
        let point: CGRect = CGRect(x: pointX,
                                   y: 0,
                                   width: x,
                                   height: rect.height)
        path.addRoundedRect(in: point, cornerSize: CGSize(width: 10, height: 10))
        return path
    }
}
