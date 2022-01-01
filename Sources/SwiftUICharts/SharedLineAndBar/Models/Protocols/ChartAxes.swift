//
//  ChartAxes.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

public typealias ChartAxes = AxisX & AxisY

// MARK: - AxisY
public protocol AxisY: AnyObject {
    /**
     Array of strings for the labels on the Y Axis instead of the labels generated
     from data point values.
     */
    var yAxisLabels: [String]? { get set }
    
    /**
     A type representing a View for displaying labels on the X axis.
     */
    associatedtype YLabels: View
    
    /**
     Displays a view for the labels on the Y Axis.
     */
    func getYAxisLabels() -> YLabels
}

extension AxisY where Self: CTChartData & GetDataProtocol & ViewDataProtocol,
                      CTStyle: CTLineBarChartStyle {
    internal var labelsArray: [String] {
        self.generateYLabels(yAxisViewData.yAxisSpecifier,
                             numberFormatter: yAxisViewData.yAxisNumberFormatter)
    }
    
    private func generateYLabels(_ specifier: String, numberFormatter: NumberFormatter?) -> [String] {
        switch self.chartStyle.yAxisLabelType {
        case .numeric:
            let dataRange: Double = self.range
            let minValue: Double = self.minValue
            let range: Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels-1)
            let firstLabel: [String] = {
                if let formatter = numberFormatter,
                   let formattedNumber = formatter.string(from: NSNumber(value:minValue)) {
                    return [formattedNumber]
                } else {
                    return [String(format: specifier, minValue)]
                }
            }()
            let otherLabels: [String] = (1...self.chartStyle.yAxisNumberOfLabels-1).map {
                let value = minValue + range * Double($0)
                if let formatter = numberFormatter,
                   let formattedNumber = formatter.string(from: NSNumber(value: value)) {
                    return formattedNumber
                } else {
                    return String(format: specifier, value)
                }
            }
            let labels = firstLabel + otherLabels
            return labels
        case .custom:
            return self.yAxisLabels ?? []
        }
    }
}

extension AxisY where Self: ViewDataProtocol {
   internal var yAxisPaddingHeight: CGFloat {
       (xAxisViewData.xAxisLabelHeights.max() ?? 0) + xAxisViewData.xAxisTitleHeight
    }
}

extension AxisY where Self: CTChartData & GetDataProtocol & ViewDataProtocol,
                      CTStyle: CTLineBarChartStyle {
    public func getYAxisLabels() -> some View {
        VStack {
            if self.chartStyle.xAxisLabelPosition == .top {
                Spacer()
                    .frame(height: yAxisPaddingHeight)
            }
            ForEach(self.labelsArray.indices.reversed(), id: \.self) { i in
                Text(LocalizedStringKey(self.labelsArray[i]))
                    .font(self.chartStyle.yAxisLabelFont)
                    .foregroundColor(self.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .overlay(
                        GeometryReader { geo in
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .onAppear {
                                    self.yAxisViewData.yAxisLabelWidth.append(geo.size.width)
                                }
                        }
                    )
                    .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
                    .accessibilityValue(LocalizedStringKey(self.labelsArray[i]))
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            if self.chartStyle.xAxisLabelPosition == .bottom {
                Spacer()
                    .frame(height: yAxisPaddingHeight)
            }
        }
        .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
            $0.padding(.top, -8)
        }, else: {
            $0.padding(.bottom, -8)
        })
    }
}

// MARK: - AxisX
public protocol AxisX: AnyObject {
    /**
     Array of strings for the labels on the X Axis instead of the labels in the data points.
     */
    var xAxisLabels: [String]? { get set }
    
    /**
     A type representing a View for displaying labels on the X axis.
     */
    associatedtype XLabels: View
    /**
     Displays a view for the labels on the X Axis.
     */
    func getXAxisLabels() -> XLabels
}
