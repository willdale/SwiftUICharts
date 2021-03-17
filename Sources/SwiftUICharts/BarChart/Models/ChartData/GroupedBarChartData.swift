//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

/**
 Data model for drawing and styling a Grouped Bar Chart.
  
 The grouping data informs the model as to how the datapoints are linked.
 ```
 */
public final class GroupedBarChartData: CTMultiBarChartDataProtocol {
    
    // MARK: Properties
    public let id   : UUID  = UUID()

    @Published public final var dataSets     : MultiBarDataSets
    @Published public final var metadata     : ChartMetadata
    @Published public final var xAxisLabels  : [String]?
    @Published public final var barStyle     : BarStyle
    @Published public final var chartStyle   : BarChartStyle
    @Published public final var legends      : [LegendData]
    @Published public final var viewData     : ChartViewData
    @Published public final var infoView     : InfoViewData<MultiBarChartDataPoint> = InfoViewData()
    @Published public final var groups       : [GroupingData]
    
    public final var noDataText   : Text
    public final var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    final var groupSpacing : CGFloat = 0
        
    // MARK: Initializer
    /// Initialises a Grouped Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : MultiBarDataSets,
                groups      : [GroupingData],
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                barStyle    : BarStyle          = BarStyle(),
                chartStyle  : BarChartStyle     = BarChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.groups         = groups
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.barStyle       = barStyle
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .bar, dataSetType: .multi)
        self.setupLegends()
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        VStack {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: self.groupSpacing) {
                    ForEach(dataSets.dataSets) { dataSet in
                        HStack(spacing: 0) {
                            ForEach(dataSet.dataPoints) { data in
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                                YAxisDataPointCell(chartData: self, label: data.group.title, rotationAngle: angle)
                                    .foregroundColor(self.chartStyle.xAxisLabelColour)
                                    .accessibilityLabel(Text("X Axis Label"))
                                    .accessibilityValue(Text("\(data.group.title)"))
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
                .padding(.horizontal, -4)
                
            case .chartData(let angle):
                
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            YAxisDataPointCell(chartData: self, label: data, rotationAngle: angle)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(data)"))
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            }
            HStack(spacing: self.groupSpacing) {
                ForEach(dataSets.dataSets) { dataSet in
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        YAxisDataPointCell(chartData: self, label: dataSet.setTitle, rotationAngle: .degrees(0))
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .accessibilityLabel(Text("X Axis Label"))
                            .accessibilityValue(Text("\(dataSet.setTitle)"))
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
            }
            .padding(.horizontal, -4)
        }
    }
    
    // MARK: Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView()
    }
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        
        var points : [MultiBarChartDataPoint] = []
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.width / CGFloat(dataSets.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.width / CGFloat(dataSets.dataSets.count)) - compensation
        let index    : Int      = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSection)

        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            let dataSet = dataSets.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(dataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSubSection) - (dataSet.dataPoints.count * index)
            if subIndex >= 0 && subIndex < dataSet.dataPoints.count {
                var dataPoint = dataSet.dataPoints[subIndex]
                dataPoint.legendTag = dataSet.setTitle
                points.append(dataPoint)
            }
        }
        self.infoView.touchOverlayInfo = points
    }
    public final func getPointLocation(dataSet: MultiBarDataSets, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)

        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSet.dataSets.count - 1)) / CGFloat(dataSet.dataSets.count))

        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.width / CGFloat(dataSet.dataSets.count)) - compensation
        let ySection : CGFloat  = chartSize.height / CGFloat(self.maxValue)

        let index    : Int      = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)

        if index >= 0 && index < dataSet.dataSets.count && superIndex == index {

            let subDataSet = dataSet.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(subDataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(index))) / xSubSection) - (subDataSet.dataPoints.count * index)

            if subIndex >= 0 && subIndex < subDataSet.dataPoints.count {
                let element : CGFloat = (CGFloat(subIndex) * xSubSection) + (xSubSection / 2)
                let section : CGFloat = (superXSection * CGFloat(superIndex))
                let spacing : CGFloat = ((groupSpacing / CGFloat(dataSets.dataSets.count)) * CGFloat(superIndex))
                return CGPoint(x: element + section + spacing,
                               y: (chartSize.height - CGFloat(subDataSet.dataPoints[subIndex].value) * ySection))
            }
        }
        return nil
    }
    
    public typealias Set        = MultiBarDataSets
    public typealias DataPoint  = MultiBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}
