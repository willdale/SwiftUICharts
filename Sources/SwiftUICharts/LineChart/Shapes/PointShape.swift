//
//  PointShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct Point: Shape {
    
    private let chartData   : ChartData
    private let pointSize   : CGFloat
    private let pointType   : PointShape
    private let cornerSize  : Int
    
    internal init(chartData: ChartData,
                  pointSize: CGFloat = 2,
                  pointType: PointShape,
                  cornerSize: Int = 3
    ) {
        self.chartData  = chartData
        self.pointSize  = pointSize
        self.pointType  = pointType
        self.cornerSize = cornerSize
    }
   
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        drawPoints(&path, rect, chartData.minValue(), chartData.range())

        return path
    }
    
    internal func drawPoints(_ path: inout Path, _ rect: CGRect, _ minValue: Double, _ range: Double) {
        let x = rect.width / CGFloat(chartData.dataPoints.count-1)
        let y = rect.height / CGFloat(range)
        
        let firstPointX : CGFloat = (CGFloat(0) * x) - pointSize / CGFloat(2)
        let firstPointY : CGFloat = ((CGFloat(chartData.dataPoints[0].value - minValue) * -y) + rect.height) - pointSize / CGFloat(2)
        let firstPoint  : CGRect  = CGRect(x        : firstPointX,
                                           y        : firstPointY,
                                           width    : pointSize,
                                           height   : pointSize)
        pointSwitch(&path, firstPoint)
        
        
        if !chartData.chartStyle.ignoreZero {
            for index in 1 ..< chartData.dataPoints.count - 1 {
                let pointX : CGFloat = (CGFloat(index) * x) - pointSize / CGFloat(2)
                let pointY : CGFloat = ((CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height) - pointSize / CGFloat(2)
                let point  : CGRect  = CGRect(x     : pointX,
                                              y     : pointY,
                                              width : pointSize,
                                              height: pointSize)
                pointSwitch(&path, point)
            }
        } else {
            for index in 1 ..< chartData.dataPoints.count - 1 {
                if chartData.dataPoints[index].value != 0 {
                    let pointX : CGFloat = (CGFloat(index) * x) - pointSize / CGFloat(2)
                    let pointY : CGFloat = ((CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height) - pointSize / CGFloat(2)
                    let point  : CGRect  = CGRect(x     : pointX,
                                                  y     : pointY,
                                                  width : pointSize,
                                                  height: pointSize)
                    pointSwitch(&path, point)
                }
            }
        }
        
        let lastPointX : CGFloat = (CGFloat(chartData.dataPoints.count-1) * x) - pointSize / CGFloat(2)
        let lastPointY : CGFloat = ((CGFloat(chartData.dataPoints[chartData.dataPoints.count-1].value - minValue) * -y) + rect.height) - pointSize / CGFloat(2)
        let lastPoint  : CGRect  = CGRect(x         : lastPointX,
                                          y         : lastPointY,
                                          width     : pointSize,
                                          height    : pointSize)
        pointSwitch(&path, lastPoint)
    }
    
    internal func pointSwitch(_ path: inout Path, _ point: CGRect) {
        switch pointType {
        case .circle:
            path.addEllipse(in: point)
        case .square:
            path.addRect(point)
        case .roundSquare:
            path.addRoundedRect(in: point, cornerSize: CGSize(width: cornerSize, height: cornerSize))
        }
    }
}
