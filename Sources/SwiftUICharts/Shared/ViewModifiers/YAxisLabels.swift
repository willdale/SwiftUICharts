//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisLabels<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T

    let specifier       : String
    var labelsArray     : [Double] { getLabels() }

    internal init(chartData: T,
                  specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
        
        chartData.viewData.hasXAxisLabels = true
    }

    internal var labels: some View {
        let labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
        let numberOfLabels  = chartData.chartStyle.yAxisNumberOfLabels
        
        return VStack {
            if labelsAndTop {
                Text("")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                    .frame(minHeight: 0, maxHeight: 500)
            }
            ForEach((0...numberOfLabels).reversed(), id: \.self) { i in
                Text("\(labelsArray[i], specifier: specifier)")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            if labelsAndBottom {
                Text("")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .if(labelsAndBottom) { $0.padding(.top, -8) }
        .if(labelsAndTop) { $0.padding(.bottom, -8) }

    }
    
    @ViewBuilder
    internal  func body(content: Content) -> some View {
        switch chartData.chartStyle.yAxisLabelPosition {
        case .leading:
            HStack {
//                if chartData.isGreaterThanTwo {
                    labels
//                }
                content
            }
        case .trailing:
            HStack {
                content
//                if chartData.isGreaterThanTwo {
                    labels
//                }
            }
        }
    }
    
    internal func getLabels() -> [Double] {
        let numberOfLabels = chartData.chartStyle.yAxisNumberOfLabels
        
        switch chartData.chartType {
        case (.line, .single):

            let data = chartData as! LineChartData
            return self.getYLabelsLineChart(dataSet: data.dataSets, numberOfLabels)
            
        case (.bar, .single):

            let data = chartData as! BarChartData
            return self.getYLabelsBarChart(dataSet: data.dataSets, numberOfLabels)
            
        case (.line, .multi):
            
            let data = chartData as! MultiLineChartData
            return self.getYLabelsMultiLineChart(dataSet: data.dataSets, numberOfLabels)
            
        case (.bar, .multi):
            
            let data = chartData as! MultiBarChartData
            return self.getYLabelsMultiBarChart(dataSet: data.dataSets, numberOfLabels)
            
        default:
            return [0.0]
        }
    }

    internal func getYLabelsLineChart<DS: SingleDataSet>(dataSet: DS, _ numberOfLabels: Int) -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = DataFunctions.dataSetRange(from: dataSet)
        let minValue    : Double    = DataFunctions.dataSetMinValue(from: dataSet)
        
        let range       : Double    = dataRange / Double(numberOfLabels)
        labels.append(minValue)
        for index in 1...numberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
    internal func getYLabelsBarChart<DS: SingleDataSet>(dataSet: DS, _ numberOfLabels: Int) -> [Double] {
        var labels : [Double]  = [Double]()
        let maxValue    : Double    = DataFunctions.dataSetMaxValue(from: dataSet)
        for index in 0...numberOfLabels {
            labels.append(maxValue / Double(numberOfLabels) * Double(index))
        }
        return labels
    }
    
    internal func getYLabelsMultiLineChart<DS: MultiDataSet>(dataSet: DS, _ numberOfLabels: Int) -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = DataFunctions.multiDataSetRange(from: dataSet)
        let minValue    : Double    = DataFunctions.multiDataSetMinValue(from: dataSet)
        
        let range       : Double    = dataRange / Double(numberOfLabels)
        labels.append(minValue)
        for index in 1...numberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
    internal func getYLabelsMultiBarChart<DS: MultiDataSet>(dataSet: DS, _ numberOfLabels: Int) -> [Double] {
        var labels : [Double]  = [Double]()
        let maxValue    : Double    = DataFunctions.multiDataSetMaxValue(from: dataSet)
        for index in 0...numberOfLabels {
            labels.append(maxValue / Double(numberOfLabels) * Double(index))
        }
        return labels
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis
     - Parameters:
      - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels<T: LineAndBarChartData>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier))
    }
}
