//
//  PointShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct Point<T>: Shape where T: SingleDataSet {
    
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
        lineChartDrawPoints(&path, rect, dataSet.dataPoints, minValue, range)
        return path
    }

    internal func lineChartDrawPoints<DP: CTChartDataPoint>(_ path: inout Path, _ rect: CGRect, _ dataPoints: [DP], _ minValue: Double, _ range: Double) {
                
        let x = rect.width / CGFloat(dataPoints.count-1)
        let y = rect.height / CGFloat(range)
        
        let firstPointX : CGFloat = (CGFloat(0) * x) -  dataSet.pointStyle.pointSize / CGFloat(2)
        let firstPointY : CGFloat = ((CGFloat(dataPoints[0].value - minValue) * -y) + rect.height) -  dataSet.pointStyle.pointSize / CGFloat(2)
        let firstPoint  : CGRect  = CGRect(x        : firstPointX,
                                           y        : firstPointY,
                                           width    :  dataSet.pointStyle.pointSize,
                                           height   :  dataSet.pointStyle.pointSize)
        pointSwitch(&path, firstPoint)
        
            for index in 1 ..< dataPoints.count - 1 {
                let pointX : CGFloat = (CGFloat(index) * x) -  dataSet.pointStyle.pointSize / CGFloat(2)
                let pointY : CGFloat = ((CGFloat(dataPoints[index].value - minValue) * -y) + rect.height) -  dataSet.pointStyle.pointSize / CGFloat(2)
                let point  : CGRect  = CGRect(x     : pointX,
                                              y     : pointY,
                                              width :  dataSet.pointStyle.pointSize,
                                              height:  dataSet.pointStyle.pointSize)
                pointSwitch(&path, point)
            }

        
        let lastPointX : CGFloat = (CGFloat(dataPoints.count-1) * x) -  dataSet.pointStyle.pointSize / CGFloat(2)
        let lastPointY : CGFloat = ((CGFloat(dataPoints[dataPoints.count-1].value - minValue) * -y) + rect.height) -  dataSet.pointStyle.pointSize / CGFloat(2)
        let lastPoint  : CGRect  = CGRect(x         : lastPointX,
                                          y         : lastPointY,
                                          width     :  dataSet.pointStyle.pointSize,
                                          height    :  dataSet.pointStyle.pointSize)
        pointSwitch(&path, lastPoint)
    }
    
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
