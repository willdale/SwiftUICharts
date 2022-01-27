//
//  deprecated+PointsSubView.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

@available(*, deprecated, message: "")
internal struct PointsSubView<ChartData, DataSet>: View where ChartData: CTChartData,
                                                              DataSet: CTLineChartDataSet,
                                                              DataSet.DataPoint: CTLineDataPointProtocol & CTStandardDataPointProtocol & Ignorable {
    
    private let dataSets: DataSet
    private let minValue: Double
    private let range: Double
    private let animation: Animation
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataSets: DataSet,
        minValue: Double,
        range: Double,
        animation: Animation
    ) {
        self.dataSets = dataSets
        self.minValue = minValue
        self.range = range
        self.animation = animation
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        switch dataSets.pointStyle.pointType {
        case .filled:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .trim(to: startAnimation ? 1 : 0)
                    .fill(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        case .outline:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                            lineWidth: dataSets.pointStyle.lineWidth)
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        case .filledOutLine:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                            lineWidth: dataSets.pointStyle.lineWidth)
                    .background(Point(datapoint: dataSets.dataPoints[index],
                                      index: index,
                                      minValue: minValue,
                                      range: range,
                                      datapointCount: dataSets.dataPoints.count,
                                      pointSize: dataSets.pointStyle.pointSize,
                                      pointStyle: dataSets.pointStyle.pointShape)
                                    .foregroundColor(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
                    )
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        }
    }
}

@available(*, deprecated, message: "")
internal struct FilledPointsSubView<ChartData, DataSet>: View where ChartData: CTChartData,
                                                                    DataSet: CTLineChartDataSet,
                                                                    DataSet.DataPoint: CTStandardLineDataPoint & CTLineDataPointProtocol & Ignorable {
    
    private let dataSets: DataSet
    private let minValue: Double
    private let range: Double
    private let animation: Animation
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataSets: DataSet,
        minValue: Double,
        range: Double,
        animation: Animation
    ) {
        self.dataSets = dataSets
        self.minValue = minValue
        self.range = range
        self.animation = animation
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        switch dataSets.pointStyle.pointType {
        case .filled:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                    .fill(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        case .outline:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                    .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                            lineWidth: dataSets.pointStyle.lineWidth)
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        case .filledOutLine:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(datapoint: dataSets.dataPoints[index],
                      index: index,
                      minValue: minValue,
                      range: range,
                      datapointCount: dataSets.dataPoints.count,
                      pointSize: dataSets.pointStyle.pointSize,
                      pointStyle: dataSets.pointStyle.pointShape)
                    .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                    .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                            lineWidth: dataSets.pointStyle.lineWidth)
                    .background(Point(datapoint: dataSets.dataPoints[index],
                                      index: index,
                                      minValue: minValue,
                                      range: range,
                                      datapointCount: dataSets.dataPoints.count,
                                      pointSize: dataSets.pointStyle.pointSize,
                                      pointStyle: dataSets.pointStyle.pointShape)
                                    .foregroundColor(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
                    )
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        }
    }
}
