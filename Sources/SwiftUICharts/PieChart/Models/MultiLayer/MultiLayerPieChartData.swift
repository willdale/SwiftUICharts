//
//  MultiLayerPieChartData.swift
//
//
//  Created by Will Dale on 05/02/2021.
//

import SwiftUI

public class MultiLayerPieChartData {

    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : MultiPieDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var chartStyle    : PieChartStyle
    @Published public var legends       : [LegendData]
//    @Published public var infoView      : InfoViewData<MultiPieDataPoint>

    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : MultiPieDataSet,
                metadata    : ChartMetadata? = nil,
                chartStyle  : PieChartStyle  = PieChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets = dataSets
        self.metadata    = metadata
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
//        self.infoView    = InfoViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .multi)
//        self.setupLegends()

    }

}

public struct MultiPieDataSet: Hashable, Identifiable {

    public let id         : UUID
    public var dataPoints : [MultiPieDataPoint] {
        didSet {
            let start  = dataPoints.first?.startAngle ?? 0
            let amount = dataPoints.last?.amount ?? 0
            let end    = start + amount
            segmentWidth = end
        }
    }
    
    var segmentWidth : Double?

    /// Initialises a new data set for Multiline Line Chart.
    public init(dataPoints: [MultiPieDataPoint]) {
        self.id       = UUID()
        self.dataPoints = dataPoints
    }
}

public struct MultiPieDataPoint: Hashable, Identifiable {
    
    public var id               : UUID = UUID()
    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    public var colour           : Color
    
    public var dataSets : MultiPieDataSet?
    
    var startAngle  : Double = 0
    var amount      : Double = 0
        
    public init(value           : Double,
                xAxisLabel      : String?   = nil,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red,
                dataSets        : MultiPieDataSet? = nil
    ) {
        self.value              = value
        self.xAxisLabel         = xAxisLabel
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
        
        self.dataSets = dataSets
        
    }
}

// MARK: - View

public struct MultiLayerPieChart: View {
    
    let chartData : MultiLayerPieChartData = makeData()
    
    public init() {}
    
    public var body: some View {
        
        ZStack {
            
            ForEach(chartData.dataSets.dataPoints, id: \.self) { dataPoint in
                
//                PieSegmentShape(id: dataPoint.id,
//                                startAngle: dataPoint.startAngle,
//                                amount: dataPoint.amount)
//                    .fill(dataPoint.colour)

                if let bob = dataPoint.dataSets {
                    
                    ForEach(bob.dataPoints) { point in
                        DoughnutSegmentShape(id         : UUID(),
                                             startAngle : point.startAngle,
                                             amount     : point.amount)
                            .strokeBorder(point.colour,
                                          lineWidth: 30)
                    }
                    
                }
                
            }
        }
    }
}

extension MultiLayerPieChart {
    static func makeData() -> MultiLayerPieChartData {
        
        let data = MultiPieDataSet(dataPoints: [
                                    MultiPieDataPoint(
                                        value: 10,
                                        colour: Color(.gray),
                                        dataSets: MultiPieDataSet(dataPoints: [
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: .red),
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: .green)])),
                                    
                                    MultiPieDataPoint(
                                        value: 40,
                                        colour: Color(.darkGray),
                                        dataSets: MultiPieDataSet(dataPoints: [
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: .blue),
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: Color(.cyan))])),
                                    MultiPieDataPoint(
                                        value: 20,
                                        colour: Color(.gray),
                                        dataSets: MultiPieDataSet(dataPoints: [
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: Color(.yellow)),
                                                                    MultiPieDataPoint(value: 20,
                                                                                      colour: Color(.magenta))])
                                    )])
        
        return MultiLayerPieChartData(dataSets: data,
                                      noDataText: Text("Bob"))
    }
}
