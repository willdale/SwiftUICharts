//
//  ChartViewData.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import Foundation

/// Data model to pass view information internally so the layout can configure its self.
internal struct ChartViewData {
    /// If the chart has labels on the X axis, the Y axis needs a different layout
    var hasXAxisLabels      : Bool = false
    /// Depending on where the X axis labels are, the Y axis needs a different layout
    var XAxisLabelsPosition : XAxisLabelPosistion = .bottom
    
    /// If the chart has labels on the Y axis, the X axis needs a different layout
    var hasYAxisLabels      : Bool = false
    /// Depending on where the Y axis labels are, the X axis needs a different layout
    var YAxisLabelsPosition : YAxisLabelPosistion = .leading
}
