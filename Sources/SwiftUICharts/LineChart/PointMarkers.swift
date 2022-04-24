//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI
import ChartMath

// MARK: - Single Line
extension View {
    /**
     Lays out markers over each of the data point.

     The style of the markers is set in the PointStyle data model as parameter in the Chart Data.
     */
    public func pointMarkers<ChartData, PointMarker>(
        chartData: ChartData,
        animation: @escaping (_ index: Int) -> Animation,
        pointMaker: @escaping (_ index: Int) -> PointMarker
    ) -> some View where ChartData: CTChartData & DataHelper,
                         ChartData.SetType: CTSingleDataSetProtocol,
                         ChartData.SetType.DataPoint: CTStandardDataPointProtocol,
                         PointMarker: View {
                             self.modifier(PointMarkersModifier(chartData: chartData, animation: animation, pointMaker: pointMaker))
                         }
}

internal struct PointMarkersModifier<ChartData, PointMarker>: ViewModifier
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTSingleDataSetProtocol,
      ChartData.SetType.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    var chartData: ChartData
    var animation: (_ index: Int) -> Animation
    var pointMaker: (_ index: Int) -> PointMarker
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            PointMarkers(chartData: chartData, stateObject: chartData.stateObject, animation: animation, pointMaker: pointMaker)
        }
    }
}

public struct PointMarkers<ChartData, PointMarker>: View
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTSingleDataSetProtocol,
      ChartData.SetType.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    var chartData: ChartData
    @ObservedObject var stateObject: ChartStateObject
    var animation: (_ index: Int) -> Animation
    var pointMaker: (_ index: Int) -> PointMarker
    
    public var body: some View {
        ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
            pointMaker(index)
                .position(x: plotPointX(index, chartData.dataSets.dataPoints.count, stateObject.chartSize.size.width),
                          y: plotPointY(chartData.dataSets.dataPoints[index].value, chartData.minValue, chartData.range, stateObject.chartSize.size.height))
            
                .modifier(_PointMarker_Cell_Pos_Anim(index: index, animation: animation))
        }
    }
}

fileprivate struct _PointMarker_Cell_Pos_Anim: ViewModifier {

    let index: Int
    let animation: (_ index: Int) -> Animation

    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .opacity(animate ? 1 : 0)
            .animateOnAppear(using: animation(index)) {
                self.animate = true
            }
    }
}

// MARK: - Multi Line
extension View {
    /**
     Lays out markers over each of the data point.

     The style of the markers is set in the PointStyle data model as parameter in the Chart Data.
     */
    public func pointMarkers<ChartData, PointMarker>(
        chartData: ChartData,
        animation: @escaping (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation,
        pointMaker: @escaping (_ dataSetIndex: Int, _ dataPointIndex: Int) -> PointMarker
    ) -> some View where ChartData: CTChartData & DataHelper,
                         ChartData.SetType: CTMultiDataSetProtocol,
                         ChartData.SetType.DataSet.DataPoint: CTStandardDataPointProtocol,
                         PointMarker: View {
                             self.modifier(MultiPointMarkersModifier(chartData: chartData, animation: animation, pointMaker: pointMaker))
                         }
}

internal struct MultiPointMarkersModifier<ChartData, PointMarker>: ViewModifier
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTMultiDataSetProtocol,
      ChartData.SetType.DataSet.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    var chartData: ChartData
    var animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation
    var pointMaker: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> PointMarker
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            MultiPointMarkers(chartData: chartData, stateObject: chartData.stateObject, animation: animation, pointMaker: pointMaker)
        }
    }
}

public struct MultiPointMarkers<ChartData, PointMarker>: View
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTMultiDataSetProtocol,
      ChartData.SetType.DataSet.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    var chartData: ChartData
    @ObservedObject var stateObject: ChartStateObject
    var animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation
    var pointMaker: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> PointMarker
    
    public var body: some View {
        ForEach(chartData.dataSets.dataSets.indices, id: \.self) { dataSetIndex in
            ForEach(chartData.dataSets.dataSets[dataSetIndex].dataPoints.indices, id: \.self) { dataPointIndex in
                pointMaker(dataSetIndex, dataPointIndex)
                    .position(x: plotPointX(dataPointIndex, chartData.dataSets.dataSets[dataSetIndex].dataPoints.count, stateObject.chartSize.size.width),
                              y: plotPointY(chartData.dataSets.dataSets[dataSetIndex].dataPoints[dataPointIndex].value, chartData.minValue, chartData.range, stateObject.chartSize.size.height))
                
                    .modifier(_Multi_PointMarker_Cell_Pos_Anim(dataSetIndex: dataSetIndex, dataPointIndex: dataPointIndex, animation: animation))
            }
        }
    }
}

fileprivate struct _Multi_PointMarker_Cell_Pos_Anim: ViewModifier {

    let dataSetIndex: Int
    let dataPointIndex: Int
    let animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation

    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .opacity(animate ? 1 : 0)
            .animateOnAppear(using: animation(dataSetIndex, dataPointIndex)) {
                self.animate = true
            }
    }
}
