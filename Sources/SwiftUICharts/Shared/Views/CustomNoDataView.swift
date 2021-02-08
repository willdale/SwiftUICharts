//
//  CustomNoDataView.swift
//  
//
//  Created by Will Dale on 17/01/2021.
//

import SwiftUI

public struct CustomNoDataView<T>: View where T: ChartData {
    
    let chartData : T
    
    init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        chartData.noDataText
    }
}
