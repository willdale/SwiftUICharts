//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

extension CTChartData where Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count > 2
    }
}

extension CTChartData where Set: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: Bool = true
        dataSets.dataSets.forEach { dataSet in
            returnValue = dataSet.dataPoints.count > 2
        }
        return returnValue
    }
}
// MARK: Touch
extension CTChartData where Self: TouchProtocol {
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }
}
