//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI
import ChartMath

// MARK: - API
extension View {
    /**
     Lays out markers over each of the data point.

     The style of the markers is set in the PointStyle data model as parameter in the Chart Data.
     */
    public func pointMarkers<DataPoint, PointMarker>(
        datapoints: [DataPoint],
        dataSetInfo: DataSetInfo,
        animation: @escaping (_ index: Int) -> Animation,
        pointMaker: @escaping (_ index: Int) -> PointMarker
    ) -> some View where DataPoint: CTStandardDataPointProtocol & Ignorable,
                         PointMarker: View {
                             self.modifier(PointMarkersModifier(datapoints: datapoints, dataSetInfo: dataSetInfo, animation: animation, pointMaker: pointMaker))
                         }
}

internal struct PointMarkersModifier<DataPoint, PointMarker>: ViewModifier
where DataPoint: CTStandardDataPointProtocol & Ignorable,
      PointMarker: View {
            
    var datapoints: [DataPoint]
    var dataSetInfo: DataSetInfo
    var animation: (_ index: Int) -> Animation
    var pointMaker: (_ index: Int) -> PointMarker
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            PointMarkers(datapoints: datapoints, dataSetInfo: dataSetInfo, animation: animation, pointMaker: pointMaker)
        }
    }
}

public struct PointMarkers<DataPoint, PointMarker>: View
where DataPoint: CTStandardDataPointProtocol & Ignorable,
      PointMarker: View {
    
    @EnvironmentObject var state: ChartStateObject
    
    var datapoints: [DataPoint]
    var dataSetInfo: DataSetInfo
    var animation: (_ index: Int) -> Animation
    var pointMaker: (_ index: Int) -> PointMarker
    
    public var body: some View {
        ForEach(datapoints.indices, id: \.self) { index in
            pointMaker(index)
                .position(x: plotPointX(index, datapoints.count, state.chartSize.size.width),
                          y: plotPointY(datapoints[index].value, dataSetInfo.minValue, dataSetInfo.range, state.chartSize.size.height))
            
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
