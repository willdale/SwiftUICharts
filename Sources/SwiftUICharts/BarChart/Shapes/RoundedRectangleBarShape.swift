//
//  RoundedRectangleBarShape.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

/**
 Round rectange used for the bar shapes
 
 [SO](https://stackoverflow.com/a/56763282)
 */
internal struct RoundedRectangleBarShape: Shape {
    
    private let tl: CGFloat
    private let tr: CGFloat
    private let bl: CGFloat
    private let br: CGFloat
    
    internal init(
        tl: CGFloat,
        tr: CGFloat,
        bl: CGFloat,
        br: CGFloat
    ) {
        self.tl = tl
        self.tr = tr
        self.bl = bl
        self.br = br
    }
    
    internal init(_ cornerRadius: CornerRadius) {
        self.tl = cornerRadius.topLeft
        self.tr = cornerRadius.topRight
        self.bl = cornerRadius.bottomLeft
        self.br = cornerRadius.bottomRight
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: tl, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}
