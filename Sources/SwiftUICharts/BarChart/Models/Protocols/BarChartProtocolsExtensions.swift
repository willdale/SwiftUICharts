//
//  BarChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

extension LineAndBarChartData where Self: BarChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = self.getMaxValue()
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
    }
}
