//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisLabels: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    /// Whether the labels are on the bottom or top of the chart.
    let labelPosition : XAxisLabelPosistion
    /// Whether the labels from the DataPoint data model or a custom array of strings
    let useDataPointLabels: LabelsFrom
    
    /// Setup labels on the X axis.
    /// - Parameters:
    ///   - labelPosition: Whether the labels are on the bottom or top of the chart.
    ///   - labelsFrom: Whether the labels from the DataPoint data model or a custom array of strings
    internal init(labelPosition: XAxisLabelPosistion, labelsFrom: LabelsFrom) {
        self.labelPosition      = labelPosition
        self.useDataPointLabels = labelsFrom
    }

    @ViewBuilder
    internal var labels: some View {
        
        switch useDataPointLabels {
        case .xAxisLabel:
            // ChartData -> DataPoints -> xAxisLabel
            HStack {
                ForEach(chartData.dataPoints, id: \.self) { data in
                    if data != chartData.dataPoints[chartData.dataPoints.count - 1] {
                        Text(data.xAxisLabel ?? "")
                        Spacer()
                    }
                }
                Text(chartData.dataPoints[chartData.dataPoints.count - 1].xAxisLabel ?? "")
            }
            .font(.caption)
            .padding(.horizontal, -4)
            .onAppear {
                chartData.viewData.hasXAxisLabels = true
                chartData.viewData.XAxisLabelsPosition = labelPosition
            }
        case .xAxisLabelArray:
            // ChartData -> xAxisLabelArray
            if let labelArray = chartData.xAxisLabelArray {
                HStack {
                    ForEach(labelArray, id: \.self) { data in
                        Text(data)
                        if data != labelArray[labelArray.count - 1] {
                            Spacer()
                        }
                    }
                }
                .font(.caption)
                .padding(.horizontal, -4)
                .onAppear {
                    chartData.viewData.hasXAxisLabels = true
                    chartData.viewData.XAxisLabelsPosition = labelPosition
                }
            } else { EmptyView() }
        }
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        switch labelPosition {
        case .top:
            VStack {
                labels
                content
            }
            
        case .bottom:
            VStack {
                content
                labels
            }
            
        }
    }
}

extension View {
    /**
    Labels for the X axis.
     - Parameters:
        - labelPosition: Whether the labels are on the bottom or top of the chart.
        - labelsFrom: Whether the labels from the DataPoint data model or a custom array of strings
     - Returns: HStack of labels
     
     - Note:
     If  `labelsFrom` is set to `xAxisLabel` the labels from the data point will be used.
     
     If `labelsFrom` is set to `xAxisLabelArray`  the labels from `xAxisLabelArray` in  ChartData will be used.
     */
    public func xAxisLabels(labelPosition   : XAxisLabelPosistion   = .bottom,
                            labelsFrom      : LabelsFrom            = .xAxisLabel
    ) -> some View {
        self.modifier(XAxisLabels(labelPosition : labelPosition,
                                  labelsFrom    : labelsFrom))
    }
}

/**
Location of the X axis labels
 ```
 case top
 case bottom
 ```
 */
public enum XAxisLabelPosistion {
    case top
    case bottom
}
/**
 Where the label data come from.
 
 xAxisLabel comes from  ChartData --> DataPoint model.
 
 xAxisLabelArray comes from ChartData --> xAxisLabelArray
 ```
 case xAxisLabel // ChartData --> DataPoint --> xAxisLabel
 case xAxisLabelArray // ChartData --> xAxisLabelArray
 ```
 */
public enum LabelsFrom {
    /// ChartData --> DataPoint --> xAxisLabel
    case xAxisLabel
    /// ChartData --> xAxisLabelArray
    case xAxisLabelArray
}
