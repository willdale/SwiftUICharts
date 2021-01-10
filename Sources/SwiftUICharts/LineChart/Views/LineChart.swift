//
//  LineChart.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

public struct LineChart: View {
    public var body: some View {
        LineChartView(isFilled: false)
    }
}

public struct FilledLineChart: View {
    public var body: some View {
        LineChartView(isFilled: true)
    }
}



