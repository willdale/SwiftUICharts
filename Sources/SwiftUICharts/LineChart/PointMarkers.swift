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

fileprivate struct PointMarkersModifier<ChartData, PointMarker>: ViewModifier
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTSingleDataSetProtocol,
      ChartData.SetType.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    private let chartData: ChartData
    private let animation: (_ index: Int) -> Animation
    private let pointMaker: (_ index: Int) -> PointMarker
    
    fileprivate init(
        chartData: ChartData,
        animation: @escaping (Int) -> Animation,
        pointMaker: @escaping (Int) -> PointMarker
    ) {
        self.chartData = chartData
        self.animation = animation
        self.pointMaker = pointMaker
    }
    
    fileprivate func body(content: Content) -> some View {
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
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var stateObject: ChartStateObject
    private let animation: (_ index: Int) -> Animation
    private let pointMaker: (_ index: Int) -> PointMarker
    
    public init(
        chartData: ChartData,
        stateObject: ChartStateObject,
        animation: @escaping (Int) -> Animation,
        pointMaker: @escaping (Int) -> PointMarker
    ) {
        self.chartData = chartData
        self.stateObject = stateObject
        self.animation = animation
        self.pointMaker = pointMaker
    }
    
    public var body: some View {
        ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
            pointMaker(index)
                .position(x: plotPointX(index, chartData.dataSets.dataPoints.count, stateObject.chartSize.size.width),
                          y: plotPointY(chartData.dataSets.dataPoints[index].value, chartData.minValue, chartData.range, stateObject.chartSize.size.height))
            
                .modifier(_PointMarker_Cell_Pos_Anim(index: index,
                                                     animation: animation,
                                                     disableAnimation: chartData.disableAnimation))
        }
    }
}

fileprivate struct _PointMarker_Cell_Pos_Anim: ViewModifier {

    private let index: Int
    private let animation: (_ index: Int) -> Animation
    private let disableAnimation: Bool

    fileprivate init(
        index: Int,
        animation: @escaping (Int) -> Animation,
        disableAnimation: Bool
    ) {
        self.index = index
        self.animation = animation
        self.disableAnimation = disableAnimation
    }
    
    @State private var startAnimation = false

    fileprivate func body(content: Content) -> some View {
        content
            .opacity(startAnimation ? 1 : 0)
            .animateOnAppear(disabled: disableAnimation, using: animation(index)) {
                self.startAnimation = true
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

fileprivate struct MultiPointMarkersModifier<ChartData, PointMarker>: ViewModifier
where ChartData: CTChartData & DataHelper,
      ChartData.SetType: CTMultiDataSetProtocol,
      ChartData.SetType.DataSet.DataPoint: CTStandardDataPointProtocol,
      PointMarker: View {
    
    private let chartData: ChartData
    private let animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation
    private let pointMaker: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> PointMarker
    
    fileprivate init(
        chartData: ChartData,
        animation: @escaping (Int, Int) -> Animation,
        pointMaker: @escaping (Int, Int) -> PointMarker
    ) {
        self.chartData = chartData
        self.animation = animation
        self.pointMaker = pointMaker
    }
    
    fileprivate func body(content: Content) -> some View {
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
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var stateObject: ChartStateObject
    private var animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation
    private var pointMaker: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> PointMarker
    
    public init(
        chartData: ChartData,
        stateObject: ChartStateObject,
        animation: @escaping (Int, Int) -> Animation,
        pointMaker: @escaping (Int, Int) -> PointMarker
    ) {
        self.chartData = chartData
        self.stateObject = stateObject
        self.animation = animation
        self.pointMaker = pointMaker
    }
    
    public var body: some View {
        ForEach(chartData.dataSets.dataSets.indices, id: \.self) { dataSetIndex in
            ForEach(chartData.dataSets.dataSets[dataSetIndex].dataPoints.indices, id: \.self) { dataPointIndex in
                pointMaker(dataSetIndex, dataPointIndex)
                    .position(x: plotPointX(dataPointIndex, chartData.dataSets.dataSets[dataSetIndex].dataPoints.count, stateObject.chartSize.size.width),
                              y: plotPointY(chartData.dataSets.dataSets[dataSetIndex].dataPoints[dataPointIndex].value, chartData.minValue, chartData.range, stateObject.chartSize.size.height))
                
                    .modifier(_Multi_PointMarker_Cell_Pos_Anim(dataSetIndex: dataSetIndex,
                                                               dataPointIndex: dataPointIndex,
                                                               animation: animation,
                                                               disableAnimation: chartData.disableAnimation))
            }
        }
    }
}

fileprivate struct _Multi_PointMarker_Cell_Pos_Anim: ViewModifier {

    private let dataSetIndex: Int
    private let dataPointIndex: Int
    private let animation: (_ dataSetIndex: Int, _ dataPointIndex: Int) -> Animation
    private let disableAnimation: Bool
    
    fileprivate init(
        dataSetIndex: Int,
        dataPointIndex: Int,
        animation: @escaping (Int, Int) -> Animation,
        disableAnimation: Bool
    ) {
        self.dataSetIndex = dataSetIndex
        self.dataPointIndex = dataPointIndex
        self.animation = animation
        self.disableAnimation = disableAnimation
    }
    
    @State private var startAnimation = false

    func body(content: Content) -> some View {
        content
            .opacity(startAnimation ? 1 : 0)
            .animateOnAppear(disabled: disableAnimation, using: animation(dataSetIndex, dataPointIndex)) {
                self.startAnimation = true
            }
    }
}
