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
internal struct Point<DataPoint>: Shape where DataPoint: CTStandardDataPointProtocol & Ignorable {
    
    private let datapoint: DataPoint
    private let index: Int
    private let minValue: Double
    private let range: Double
    private let datapointCount: Int
    private let pointSize: CGFloat
    private let pointStyle: PointShape
    
    internal init(
        datapoint: DataPoint,
        index: Int,
        minValue: Double,
        range: Double,
        datapointCount: Int,
        pointSize: CGFloat,
        pointStyle: PointShape
    ) {
        self.datapoint = datapoint
        self.index = index
        self.minValue = minValue
        self.range = range
        self.datapointCount = datapointCount
        self.pointSize = pointSize
        self.pointStyle = pointStyle
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let x: CGFloat = rect.width / CGFloat(datapointCount-1)
        let y: CGFloat = rect.height / CGFloat(range)
        let offset: CGFloat = pointSize / CGFloat(2)
        
        let pointX: CGFloat = (CGFloat(index) * x) - offset
        let pointY: CGFloat = ((CGFloat(datapoint.value - minValue) * -y) + rect.height) - offset
        let point: CGRect = CGRect(x: pointX, y: pointY, width: pointSize, height: pointSize)
        if !datapoint.ignore {
            pointSwitch(&path, point)
        }
        return path
    }
    
    /// Draws the points based on chosen parameters.
    /// - Parameters:
    ///   - path: Path to draw on.
    ///   - point: Position to draw the point.
    internal func pointSwitch(_ path: inout Path, _ point: CGRect) {
        switch pointStyle {
        case .circle:
            path.addEllipse(in: point)
        case .square:
            path.addRect(point)
        case .roundSquare:
            path.addRoundedRect(in: point, cornerSize: CGSize(width: 3, height: 3))
        }
    }
}
