//
//  PointShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Draws point markers over the data point locations.
 */
internal struct Point<T>: Shape where T: CTLineChartDataSet,
                                      T.DataPoint: CTStandardDataPointProtocol  {
    
    private let dataSet     : T
    
    private let minValue : Double
    private let range    : Double
    
        
    internal init(dataSet   : T,
                  minValue  : Double,
                  range     : Double
    ) {
        self.dataSet    = dataSet
        self.minValue   = minValue
        self.range      = range
    }
   
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if dataSet.dataPoints.count >= 2 {
            
            let x = rect.width / CGFloat(dataSet.dataPoints.count-1)
            let y = rect.height / CGFloat(range)
            
            let firstPointX : CGFloat = (CGFloat(0) * x) -  dataSet.pointStyle.pointSize / CGFloat(2)
            let firstPointY : CGFloat = ((CGFloat(dataSet.dataPoints[0].value - minValue) * -y) + rect.height) -  dataSet.pointStyle.pointSize / CGFloat(2)
            let firstPoint  : CGRect  = CGRect(x     : firstPointX,
                                               y     : firstPointY,
                                               width :  dataSet.pointStyle.pointSize,
                                               height:  dataSet.pointStyle.pointSize)
            if !dataSet.style.ignoreZero {
                pointSwitch(&path, firstPoint)
            } else {
                if dataSet.dataPoints[0].value != 0 {
                    pointSwitch(&path, firstPoint)
                }
            }
            
            for index in 1 ..< dataSet.dataPoints.count - 1 {
                let pointX : CGFloat = (CGFloat(index) * x) -  dataSet.pointStyle.pointSize / CGFloat(2)
                let pointY : CGFloat = ((CGFloat(dataSet.dataPoints[index].value - minValue) * -y) + rect.height) -  dataSet.pointStyle.pointSize / CGFloat(2)
                let point  : CGRect  = CGRect(x     : pointX,
                                              y     : pointY,
                                              width :  dataSet.pointStyle.pointSize,
                                              height:  dataSet.pointStyle.pointSize)
                if !dataSet.style.ignoreZero {
                    pointSwitch(&path, point)
                } else {
                    if dataSet.dataPoints[index].value != 0 {
                        pointSwitch(&path, point)
                    }
                }
            }
            
            let lastPointX : CGFloat = (CGFloat(dataSet.dataPoints.count-1) * x) - dataSet.pointStyle.pointSize / CGFloat(2)
            let lastPointY : CGFloat = ((CGFloat(dataSet.dataPoints[dataSet.dataPoints.count-1].value - minValue) * -y) + rect.height) - dataSet.pointStyle.pointSize / CGFloat(2)
            let lastPoint  : CGRect  = CGRect(x     : lastPointX,
                                              y     : lastPointY,
                                              width :  dataSet.pointStyle.pointSize,
                                              height:  dataSet.pointStyle.pointSize)
            if !dataSet.style.ignoreZero {
                pointSwitch(&path, lastPoint)
            } else {
                if dataSet.dataPoints[dataSet.dataPoints.count-1].value != 0 {
                    pointSwitch(&path, lastPoint)
                }
            }
            
        }
        
        return path
    }
    
    /// Draws the points based on chosen parameters.
    /// - Parameters:
    ///   - path: Path to draw on.
    ///   - point: Position to draw the point.
    internal func pointSwitch(_ path: inout Path, _ point: CGRect) {
        switch dataSet.pointStyle.pointShape {
        case .circle:
            path.addEllipse(in: point)
        case .square:
            path.addRect(point)
        case .roundSquare:
            path.addRoundedRect(in: point, cornerSize: CGSize(width: 3, height: 3))
        }
    }
}
