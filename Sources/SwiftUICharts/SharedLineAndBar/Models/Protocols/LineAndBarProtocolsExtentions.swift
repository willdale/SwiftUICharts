//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Data Set
extension CTLineBarChartDataProtocol {
    public var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch self.chartStyle.baseline {
            case .minimumValue:
                _lowestValue = self.dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(self.dataSets.minValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch self.chartStyle.topLine {
            case .maximumValue:
                _highestValue = self.dataSets.maxValue()
            case .maximum(of: let value):
                _highestValue = max(self.dataSets.maxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    
    public var minValue: Double {
        get {
            switch self.chartStyle.baseline {
            case .minimumValue:
                return self.dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                return min(self.dataSets.minValue(), value)
            case .zero:
                return 0
            }
        }
    }
    
    public var maxValue: Double {
        get {
            switch self.chartStyle.topLine {
            case .maximumValue:
                return self.dataSets.maxValue()
            case .maximum(of: let value):
                return max(self.dataSets.maxValue(), value)
            }
        }
    }
    
    public var average: Double {
        return self.dataSets.average()
    }
}

// MARK: - Y Axis
extension CTLineBarChartDataProtocol {
    
    private var labelsArray: [String] { self.getYLabels(self.viewData.yAxisSpecifier) }
    
    public func getYLabels(_ specifier: String) -> [String] {
        switch self.chartStyle.yAxisLabelType {
        case .numeric:
            let dataRange: Double = self.range
            let minValue: Double = self.minValue
            let range: Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels-1)
            let firstLabel = [String(format: self.viewData.yAxisSpecifier, minValue)]
            let otherLabels = (1...self.chartStyle.yAxisNumberOfLabels-1).map { String(format: self.viewData.yAxisSpecifier, minValue + range * Double($0)) }
            let labels = firstLabel + otherLabels
            return labels
        case .custom:
            return self.yAxisLabels ?? []
        }
    }
}

// MARK: Most
extension CTLineBarChartDataProtocol {
    public func showYAxisLabels() -> some View {
        VStack {
            ForEach(self.labelsArray.indices.reversed(), id: \.self) { i in
                Text(self.labelsArray[i])
                    .font(self.chartStyle.yAxisLabelFont)
                    .foregroundColor(self.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .accessibilityLabel(Text("Y Axis Label"))
                    .accessibilityValue(Text(self.labelsArray[i]))
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            Spacer()
                .frame(height: (self.viewData.xAxisLabelHeights.max() ?? 0) + self.viewData.xAxisTitleHeight)
        }
    }
}

// MARK: Horizontal Bar Chart
extension CTLineBarChartDataProtocol where Self: CTHorizontalBarChartDataProtocol,
                                           Self.Set: CTSingleDataSetProtocol,
                                           Self.Set.DataPoint: CTLineBarDataPointProtocol {
    @ViewBuilder public func showYAxisLabels() -> some View {
        switch self.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(dataSets.dataPoints, id: \.id) { data in
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                    Text(data.wrappedXAxisLabel)
                        .font(self.chartStyle.xAxisLabelFont)
                        .lineLimit(1)
                        .foregroundColor(self.chartStyle.xAxisLabelColour)
                        .overlay(
                            GeometryReader { geo in
                                Rectangle()
                                    .foregroundColor(Color.clear)
                                    .onAppear {
                                        self.viewData.yAxisLabelWidth.append(geo.size.width)
                                    }
                            }
                        )
                        .accessibilityLabel(Text("X Axis Label"))
                        .accessibilityValue(Text("\(data.wrappedXAxisLabel)"))
                    
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
                Spacer()
                    .frame(height: self.viewData.xAxisTitleHeight + (self.viewData.xAxisLabelHeights.max() ?? 0) + 8)
            }
            .frame(width: self.viewData.yAxisLabelWidth.max())
            Spacer()
            
        case .chartData:
            
            if let labelArray = self.xAxisLabels {
                VStack(spacing: 0) {
                    ForEach(labelArray, id: \.self) { data in
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                        Text(data)
                            .font(self.chartStyle.xAxisLabelFont)
                            .lineLimit(1)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .overlay(
                                GeometryReader { geo in
                                    Rectangle()
                                        .foregroundColor(Color.clear)
                                        .onAppear {
                                            self.viewData.yAxisLabelWidth.append(geo.size.width)
                                        }
                                }
                            )
                            .accessibilityLabel(Text("X Axis Label"))
                            .accessibilityValue(Text("\(data)"))
                        
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                    }
                    Spacer()
                        .frame(height: self.viewData.xAxisTitleHeight + (self.viewData.xAxisLabelHeights.max() ?? 0) + 8)
                }
                .frame(width: self.viewData.yAxisLabelWidth.max())
                Spacer()
            }
        }
    }
}

// MARK: Title
extension CTLineBarChartDataProtocol {
    public func showYAxisTitle() -> some View {
        Group {
            if let title = self.chartStyle.yAxisTitle {
                VStack {
                    Text(title)
                        .font(self.chartStyle.yAxisTitleFont)
                        .background(
                            GeometryReader { geo in
                                Rectangle()
                                    .foregroundColor(Color.clear)
                                    .onAppear {
                                        self.viewData.yAxisTitleWidth = geo.size.height + 10
                                    }
                            }
                        )
                        .rotationEffect(Angle.init(degrees: -90), anchor: .center)
                        .fixedSize()
                        .frame(width: self.viewData.yAxisTitleWidth)
                    Spacer()
                        .frame(height: (self.viewData.xAxisLabelHeights.max() ?? 0) + self.viewData.yAxisTitleWidth)
                }
            }
        }
    }
}

// MARK: - X Axis
//
//
//
// MARK: Bar Chart && Ranged Bar Chart
extension CTBarChartDataProtocol where Self.Set: CTSingleDataSetProtocol,
                                       Self.Set.DataPoint: CTLineBarDataPointProtocol {
    
    func getBarChartXSection<DS: CTSingleDataSetProtocol>(dataSet: DS, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
    }
    
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints, id: \.id) { data in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        VStack {
                            RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                            Spacer()
                        }
                        .frame(width: self.getBarChartXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize),
                               height: self.viewData.xAxisLabelHeights.max())
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            VStack {
                                RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                Spacer()
                            }
                            .frame(width: self.getBarChartXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize),
                                   height: self.viewData.xAxisLabelHeights.max())
                            if i != labelArray.count - 1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: Grouped Bar Chart
extension GroupedBarChartData {
    func getGroupedBarChartXSection<DS: CTMultiDataSetProtocol>(dataSet: DS, chartSize: CGRect, groupSpacing: CGFloat) -> CGFloat {
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        let section = superXSection - compensation
        return section > 0 ? section : 0
    }
    func getGroupedBarChartXSectionTest(dataSet: GroupedBarDataSets, chartSize: CGRect) -> CGFloat {
        let dataPointCount = dataSet.dataSets
            .flatMap(\.dataPoints)
            .count
        return chartSize.width / CGFloat(dataPointCount)
    }
    
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets.indices, id: \.self) { i in
                        if i > 0 {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                        VStack {
                            RotatedText(chartData: self, label: self.dataSets.dataSets[i].setTitle, rotation: angle)
                            Spacer()
                        }
                        .frame(width: self.getGroupedBarChartXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize, groupSpacing: self.groupSpacing),
                               height: self.viewData.xAxisLabelHeights.max())
                        if i < self.dataSets.dataSets.count - 1 {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            if i > 0 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                            VStack {
                                RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                Spacer()
                            }
                            .frame(width: self.getGroupedBarChartXSectionTest(dataSet: self.dataSets, chartSize: self.viewData.chartSize),
                                   height: self.viewData.xAxisLabelHeights.max())
                            if i < labelArray.count - 1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: Stacked Bar Chart
extension CTMultiBarChartDataProtocol where Self.Set: CTMultiDataSetProtocol,
                                            Self.Set.DataSet: CTMultiBarChartDataSet {
    
    func getBarChartXSection<DS: CTMultiDataSetProtocol>(dataSet: DS, chartSize: CGRect) -> CGFloat {
         return chartSize.width / CGFloat(dataSet.dataSets.count)
    }
    
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets, id: \.id) { dataSet in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        VStack {
                            RotatedText(chartData: self, label: dataSet.setTitle, rotation: angle)
                            Spacer()
                        }
                        .frame(width: self.getBarChartXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize),
                               height: self.viewData.xAxisLabelHeights.max())
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            if i > 0 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                            VStack {
                                RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                Spacer()
                            }
                            .frame(width: self.viewData.xAxislabelWidth,
                                   height: self.viewData.xAxisLabelHeights.max())
                            .border(Color.blue, width: 1)
                            if i < labelArray.count - 1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }
}


// MARK: Horizontal Bar Chart
extension CTBarChartDataProtocol where Self: CTHorizontalBarChartDataProtocol {
    public func getXAxisLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(self.getYLabels("%.f").indices, id: \.self) { i in
                Text(self.getYLabels("%.f")[i])
                    .font(self.chartStyle.yAxisLabelFont)
                    .foregroundColor(self.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .accessibilityLabel(Text("Y Axis Label"))
                    .accessibilityValue(Text(self.getYLabels("%.f")[i]))
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    self.viewData.xAxisLabelHeights.append(geo.size.height)
                                }
                        }
                    )
                if i != self.getYLabels("%.f").count - 1 {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
    }
}

// MARK: Title
extension CTLineBarChartDataProtocol {
    internal func xAxisTitle() -> some View {
        Group {
            if let title = self.chartStyle.xAxisTitle {
                Text(title)
                    .font(self.chartStyle.xAxisTitleFont)
                    .background(
                        GeometryReader { geo in
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .onAppear {
                                    self.viewData.xAxisTitleHeight = geo.size.height
                                }
                        }
                    )
            }
        }
    }
}


// MARK: - Rotated Text
internal struct RotatedText<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let rotation: Angle
    
    internal init(
        chartData: ChartData,
        label: String,
        rotation: Angle
    ) {
        self.chartData = chartData
        self.label = label
        self.rotation = rotation
    }
    
    @State private var finalFrame: CGRect = .zero
    
    internal var body: some View {
        Text(label)
            .font(chartData.chartStyle.xAxisLabelFont)
            .foregroundColor(chartData.chartStyle.xAxisLabelColour)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            finalFrame = geo.frame(in: .local)
                            chartData.viewData.xAxisLabelHeights.append(geo.frame(in: .local).width)
                            chartData.viewData.xAxislabelWidth = geo.frame(in: .local).height
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotation, anchor: .center)
            .frame(width: finalFrame.height, height: finalFrame.width)
            .accessibilityLabel(Text("X Axis Label"))
            .accessibilityValue(Text(label))
    }
}
