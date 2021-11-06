//
//  PointsSubView.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Sub view gets the point markers drawn, sets the styling and sets up the animations.
 */
internal struct PointsSubView<ChartData, DS>: View where ChartData: CTChartData,
                                                         DS: CTLineChartDataSet,
                                                         DS.DataPoint: CTStandardDataPointProtocol & CTLineDataPointProtocol {
    
    private let dataSets: DS
    private let minValue: Double
    private let range: Double
    private let animation: Animation
    private let isFilled: Bool
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataSets: DS,
        minValue: Double,
        range: Double,
        animation: Animation,
        isFilled: Bool
    ) {
        self.dataSets = dataSets
        self.minValue = minValue
        self.range = range
        self.animation = animation
        self.isFilled = isFilled
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        switch dataSets.pointStyle.pointType {
        case .filled:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .fill(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .fill(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
                    })
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: animation) {
                self.startAnimation = false
            }
        case .outline:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                                    lineWidth: dataSets.pointStyle.lineWidth)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                                    lineWidth: dataSets.pointStyle.lineWidth)
                    })
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: animation) {
                self.startAnimation = false
            }
        case .filledOutLine:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                                    lineWidth: dataSets.pointStyle.lineWidth)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .stroke(dataSets.dataPoints[index].pointColour?.border ?? dataSets.pointStyle.borderColour,
                                    lineWidth: dataSets.pointStyle.lineWidth)
                    })
                    .background(Point(value: dataSets.dataPoints[index].value,
                                       index: index,
                                       minValue: minValue,
                                       range: range,
                                       datapointCount: dataSets.dataPoints.count,
                                       pointSize: dataSets.pointStyle.pointSize,
                                       ignoreZero: dataSets.style.ignoreZero,
                                       pointStyle: dataSets.pointStyle.pointShape)
                                    .foregroundColor(dataSets.dataPoints[index].pointColour?.fill ?? dataSets.pointStyle.fillColour)
                    )
            }
            .animateOnAppear(using: animation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: animation) {
                self.startAnimation = false
            }
        }
    }
}
