//
//  MultiLayerPieChartData.swift
//
//
//  Created by Will Dale on 05/02/2021.
//

import SwiftUI

/**
 Data for drawing and styling a multi layered pie chart.
 
 This model contains the data and styling information for a multi layered pie chart
 
 # Example
 ```
 public static func makeData() -> MultiLayerPieChartData {
    
    let data = MultiPieDataSet(dataPoints: [
        MultiPieDataPoint(value: 40, pointDescription: "One", colour: Color(.red),
                        layerDataPoints: [
                            MultiPieDataPoint(value: 50, colour: Color(.cyan),
                                            layerDataPoints: [
                                                MultiPieDataPoint(value: 70, colour: .red,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 20, colour: .red),
                                                                    MultiPieDataPoint(value: 30, colour: .blue)
                                                                ]),
                                                MultiPieDataPoint(value: 30, colour: .blue,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 30, colour: .green),
                                                                    MultiPieDataPoint(value: 50, colour: .orange)
                                                                ])
                                            ]),
                            MultiPieDataPoint(value: 70, colour: Color(.yellow),
                                            layerDataPoints: [
                                                MultiPieDataPoint(value: 50, colour: .green,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 30, colour: .yellow),
                                                                    MultiPieDataPoint(value: 30, colour: .pink)
                                                                ]),
                                                MultiPieDataPoint(value: 30, colour: .red,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 50, colour: .green),
                                                                    MultiPieDataPoint(value: 20, colour: .orange)
                                                                ])
                                            ])
                        ]),
        MultiPieDataPoint(value: 40, pointDescription: "Two", colour: Color(.blue),
                        layerDataPoints: [
                            MultiPieDataPoint(value: 50, colour: Color(.cyan),
                                            layerDataPoints: [
                                                MultiPieDataPoint(value: 70, colour: .red,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 60, colour: .green),
                                                                    MultiPieDataPoint(value: 40, colour: .yellow)
                                                                ]),
                                                MultiPieDataPoint(value: 30, colour: .blue,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 30, colour: .red),
                                                                    MultiPieDataPoint(value: 20, colour: .orange)
                                                                ])
                                            ]),
                            MultiPieDataPoint(value: 70, colour: Color(.green),
                                            layerDataPoints: [
                                                MultiPieDataPoint(value: 50, colour: .green,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 70, colour: .green),
                                                                    MultiPieDataPoint(value: 60, colour: .pink)
                                                                ]),
                                                MultiPieDataPoint(value: 30, colour: .red,
                                                                layerDataPoints: [
                                                                    MultiPieDataPoint(value: 10, colour: .orange),
                                                                    MultiPieDataPoint(value: 50, colour: .pink)
                                                                ])
                                            ])
                        ])
        ])
    return MultiLayerPieChartData(dataSets: data,
                                  metadata: ChartMetadata(title: "Pie", subtitle: "mmm pie"),
                                  chartStyle: PieChartStyle(infoBoxPlacement: .header))
 }
 ```
 */
public final class MultiLayerPieChartData: CTMultiPieChartDataProtocol {
    
    // MARK: Properties
    public var id : UUID = UUID()
    @Published public var dataSets      : MultiPieDataSet
    @Published public var metadata      : ChartMetadata
    @Published public var chartStyle    : PieChartStyle
    @Published public var legends       : [LegendData]
    @Published public var infoView      : InfoViewData<MultiPieDataPoint>
            
    public var noDataText: Text
    public var chartType : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: Initializer
    /// Initialises a multi layered pie chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - chartStyle : The style data for the aesthetic of the chart.
    ///   - noDataText : Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : MultiPieDataSet,
                metadata    : ChartMetadata,
                chartStyle  : PieChartStyle  = PieChartStyle(),
                noDataText  : Text = Text("No Data")
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
        self.infoView    = InfoViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .single)
        
        self.setupLegends()
        self.makeDataPoints()
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
    
    public typealias Set       = MultiPieDataSet
    public typealias DataPoint = MultiPieDataPoint
    public typealias CTStyle   = PieChartStyle
}

// MARK: - Touch
extension MultiLayerPieChartData: TouchProtocol {
    public func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let points : [MultiPieDataPoint] = []
        self.infoView.touchOverlayInfo = points
    }
}

// MARK: - Legends
extension MultiLayerPieChartData: LegendProtocol {
    internal func setupLegends() {}
    
    internal func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}
