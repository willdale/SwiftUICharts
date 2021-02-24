//
//  BarChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

// Standard / Grouped / Stacked
extension LineAndBarChartData where Self: BarChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = self.maxValue
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
    }
}
