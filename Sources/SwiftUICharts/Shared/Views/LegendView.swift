//
//  LegendView.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
 Sub view to setup and display the legends.
 */
internal struct LegendView<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private let columns: [GridItem]
    private let width: CGFloat
    private let font: Font
    private let textColor: Color
    
    internal init(chartData: T,
                  columns: [GridItem],
                  width: CGFloat,
                  font: Font,
                  textColor: Color
    ) {
        self.chartData = chartData
        self.columns = columns
        self.width = width
        self.font = font
        self.textColor = textColor
    }
    
    internal var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(chartData.legends, id: \.id) { legend in
                legend.getLegend(width: width, font: font, textColor: textColor)
                    .if(scaleLegendBar(legend: legend)) { $0.scaleEffect(1.2, anchor: .leading) }
                    .if(scaleLegendPie(legend: legend)) { $0.scaleEffect(1.2, anchor: .leading) }
                    .accessibilityLabel(LocalizedStringKey(legend.accessibilityLegendLabel()))
                    .accessibilityValue(LocalizedStringKey(legend.legend))
            }
        }
    }
    
    /// Detects whether to run the scale effect on the legend.
    private func scaleLegendBar(legend: LegendData) -> Bool {
        if let chartData = chartData as? BarChartData,
           let datapoint = chartData.touchPointData.first {
            return chartData.infoView.isTouchCurrent && legend.id == datapoint.id
        }
        if let chartData = chartData as? GroupedBarChartData,
           let datapoint = chartData.touchPointData.first {
            return chartData.infoView.isTouchCurrent && legend.colour == datapoint.group.colour
        }
        if let chartData = chartData as? StackedBarChartData,
           let datapoint = chartData.touchPointData.first {
            return chartData.infoView.isTouchCurrent && legend.colour == datapoint.group.colour
        }
        return false
    }
    
    /// Detects whether to run the scale effect on the legend.
    private func scaleLegendPie(legend: LegendData) -> Bool {
        if let chartData = chartData as? PieChartData,
           let datapointID = chartData.touchPointData.first?.id {
            return chartData.infoView.isTouchCurrent && legend.id == datapointID
        } else if let chartData = chartData as? DoughnutChartData,
                  let datapointID = chartData.touchPointData.first?.id {
            return chartData.infoView.isTouchCurrent && legend.id == datapointID
        } else {
            return false
        }
    }
}

extension LegendData {
    internal func accessibilityLegendLabel() -> String {
        switch self.chartType {
        case .line:
            if self.prioity == 1 {
                return "Line Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        case .bar:
            if self.prioity == 1 {
                return "Bar Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        case .pie:
            if self.prioity == 1 {
                return "Pie Chart Legend"
            } else {
                return "P O I Marker Legend"
            }
        case .extraLine:
            return ""
        }
    }
}
