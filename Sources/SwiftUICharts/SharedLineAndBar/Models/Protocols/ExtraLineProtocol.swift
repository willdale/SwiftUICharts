//
//  ExtraLineProtocol.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

public protocol ExtraLineProtocol {
    /**
     A data model for the `ExtraLine` View Modifier
    */
    var extraLineData: ExtraLineData! { get set }
    
    /**
     A type representing a View for displaying second set of labels on the Y axis.
    */
    associatedtype ExtraYLabels: View
    
    /**
     View for displaying second set of labels on the Y axis.
    */
    func getExtraYAxisLabels() -> ExtraYLabels
    
    associatedtype ExtraYTitle: View
    
    func getExtraYAxisTitle(colour: AxisColour) -> ExtraYTitle
}

extension ExtraLineProtocol where Self: CTChartData & YAxisViewDataProtocol,
                                  CTStyle: CTLineBarChartStyle {
    
    internal var extraLabelsArray: [String] { self.generateExtraYLabels(yAxisViewData.yAxisSpecifier) }
    private func generateExtraYLabels(_ specifier: String) -> [String] {
        let dataRange: Double = self.extraLineData.range
        let minValue: Double = self.extraLineData.minValue
        let range: Double = dataRange / Double(self.extraLineData.style.yAxisNumberOfLabels-1)
        let firstLabel = [String(format: specifier, minValue)]
        let otherLabels = (1...self.extraLineData.style.yAxisNumberOfLabels-1).map { String(format: specifier, minValue + range * Double($0)) }
        let labels = firstLabel + otherLabels
        return labels

    }
    
    public func getExtraYAxisLabels() -> some View {
        VStack {
            if self.chartStyle.xAxisLabelPosition == .top {
                Spacer()
                    .frame(height: 0)//yAxisPaddingHeight)
            }
            ForEach(self.extraLabelsArray.indices.reversed(), id: \.self) { i in
                Text(LocalizedStringKey(self.extraLabelsArray[i]))
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
                    .accessibilityValue(LocalizedStringKey(self.extraLabelsArray[i]))
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            if self.chartStyle.xAxisLabelPosition == .bottom {
                Spacer()
                    .frame(height: 0) //yAxisPaddingHeight)
            }
        }
        .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
            $0.padding(.top, -8)
        }, else: {
            $0.padding(.bottom, -8)
        })
    }
    
    @ViewBuilder
    public func getExtraYAxisTitle(colour: AxisColour) -> some View {
        Group {
//            if let title = self.extraLineData.style.yAxisTitle {
//                VStack {
//                    if self.chartStyle.xAxisLabelPosition == .top {
//                        Spacer()
//                            .frame(height: yAxisPaddingHeight)
//                    }
//                    VStack {
//                        Text(LocalizedStringKey(title))
//                            .font(self.chartStyle.yAxisTitleFont)
//                            .foregroundColor(self.chartStyle.yAxisTitleColour)
//                            .background(
//                                GeometryReader { geo in
//                                    Rectangle()
//                                        .foregroundColor(Color.clear)
//                                        .onAppear {
//                                            self.viewData.extraYAxisTitleWidth = geo.size.height + 10 // 10 to add padding
//                                            self.viewData.extraYAxisTitleHeight = geo.size.width
//                                        }
//                                }
//                        }
//                        .offset(x: 0, y: self.viewData.extraYAxisTitleHeight / 2)
//                    }
//                    if self.chartStyle.xAxisLabelPosition == .bottom {
//                        Spacer()
//                            .frame(height: yAxisPaddingHeight)
//                    }
//                }
//            } else { EmptyView() }
        }
    }
}
