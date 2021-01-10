//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisLabels: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
            
    /// Whether the labels are on the leading or trailing edge of the chart.
    let labelPosition   : YAxisLabelPosistion
    let numberOfLabels  : Int
    let specifier       : String
    var labelsArray     : [Double] { getYLabels() }

    internal init(labelPosition: YAxisLabelPosistion, numberOfLabels: Int, specifier: String) {
        self.labelPosition  = labelPosition
        self.numberOfLabels = numberOfLabels - 1
        self.specifier      = specifier
    }

    internal var labels: some View {
        let labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.viewData.XAxisLabelsPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.viewData.XAxisLabelsPosition == .bottom
        return VStack {
            if labelsAndTop {
                Text("")
                    .font(.caption)
            }
            ForEach((0...numberOfLabels).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                if i != 0 {
                    Spacer()
                }
            }
            if labelsAndBottom {
                Text("")
                    .font(.caption)
            }
        }
        .if(labelsAndBottom) { $0.padding(.top, -6) }
        .if(labelsAndTop) { $0.padding(.bottom, -6) }
        .onAppear {
            chartData.viewData.hasYAxisLabels = true
            chartData.viewData.YAxisLabelsPosition = labelPosition
        }
    }
    
    @ViewBuilder
    internal  func body(content: Content) -> some View {
        switch labelPosition {
        case .leading:
            HStack {
                labels
                content
            }
        case .trailing:
            HStack {
                content
                labels
            }
        }
    }

    internal func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = chartData.range()
        let minValue    : Double    = chartData.minValue()
        let range       : Double    = dataRange / Double(numberOfLabels)
        for index in 0...numberOfLabels {
            if index == 0 {
                labels.append(minValue)
            } else {
                labels.append(minValue + range * Double(index))
            }
        }
        return labels
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis
     - Parameters:
     - labelPosition: Whether the labels are on the leading edge or trialing egde of the chart.
     - numberOfLabels: Number of labels
     - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels(labelPosition   : YAxisLabelPosistion = .leading,
                            numberOfLabels  : Int = 10,
                            specifier       : String = "%.0f"
    ) -> some View {
        
        self.modifier(YAxisLabels(labelPosition: labelPosition,
                                  numberOfLabels: numberOfLabels,
                                  specifier: specifier))
    }
}

/**
Location of the Y axis labels
 ```
 case leading
 case trailing
 ```
 */
public enum YAxisLabelPosistion {
    case leading
    case trailing
}
