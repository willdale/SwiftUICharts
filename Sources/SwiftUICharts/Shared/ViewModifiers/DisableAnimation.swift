//
//  DisableAnimation.swift
//  
//
//  Created by Will Dale on 22/05/2022.
//

import SwiftUI

 extension View {
     public func disableAnimation<ChartData>(chartData: ChartData, _ value: Bool = true) -> some View where ChartData: CTChartData {
         chartData.disableAnimation = value
         return self
     }
 }
