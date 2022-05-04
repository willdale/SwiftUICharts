//
//  DisableAnimation.swift
//  
//
//  Created by Will Dale on 04/05/2022.
//

import SwiftUI

extension View {
    public func disableAnimation<ChartData>(chartData: ChartData) -> some View where ChartData: CTLineChartDataProtocol {
        chartData.disableAnimation = true
        return self
    }
}
