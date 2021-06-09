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
//internal struct PointsSubView<DS>: View where DS: CTLineChartDataSet,
//                                              DS.DataPoint: CTStandardDataPointProtocol {
//
//    private let dataSets: DS
//    private let minValue: Double
//    private let range: Double
//    private let animation: Animation
//    private let isFilled: Bool
//
//    internal init(
//        dataSets: DS,
//        minValue: Double,
//        range: Double,
//        animation: Animation,
//        isFilled: Bool
//    ) {
//        self.dataSets = dataSets
//        self.minValue = minValue
//        self.range = range
//        self.animation = animation
//        self.isFilled = isFilled
//    }
//
//    @State private var startAnimation: Bool = false
//
//    internal var body: some View {
//        switch dataSets.pointStyle.pointType {
//        case .filled:
//            Point(dataSet: dataSets,
//                  minValue: minValue,
//                  range: range)
//                .ifElse(!isFilled, if: {
//                    $0.trim(to: startAnimation ? 1 : 0)
//                        .fill(dataSets.pointStyle.fillColour)
//                }, else: {
//                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
//                        .fill(dataSets.pointStyle.fillColour)
//                })
//                .animateOnAppear(using: animation) {
//                    self.startAnimation = true
//                }
//                .animateOnDisappear(using: animation) {
//                    self.startAnimation = false
//                }
//        case .outline:
//            Point(dataSet: dataSets,
//                  minValue: minValue,
//                  range: range)
//                .ifElse(!isFilled, if: {
//                    $0.trim(to: startAnimation ? 1 : 0)
//                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
//                }, else: {
//                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
//                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
//                })
//                .animateOnAppear(using: animation) {
//                    self.startAnimation = true
//                }
//                .animateOnDisappear(using: animation) {
//                    self.startAnimation = false
//                }
//        case .filledOutLine:
//            Point(dataSet: dataSets,
//                  minValue: minValue,
//                  range: range)
//                .ifElse(!isFilled, if: {
//                    $0.trim(to: startAnimation ? 1 : 0)
//                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
//                }, else: {
//                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
//                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
//                })
//                .background(Point(dataSet: dataSets,
//                                  minValue: minValue,
//                                  range: range)
//                                .foregroundColor(dataSets.pointStyle.fillColour)
//                )
//                .animateOnAppear(using: animation) {
//                    self.startAnimation = true
//                }
//                .animateOnDisappear(using: animation) {
//                    self.startAnimation = false
//                }
//        }
//    }
//}



/**
 Sub view gets the point markers drawn, sets the styling and sets up the animations.
 */
internal struct PointsSubView<DS>: View where DS: CTLineChartDataSet,
                                              DS.DataPoint: CTStandardDataPointProtocol {
    
    private let dataSets: DS
    private let minValue: Double
    private let range: Double
    private let animation: Animation
    private let isFilled: Bool
    
    internal init(
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
    }
    
    @State private var startAnimation: Bool = false
    
    internal var body: some View {
        
        switch dataSets.pointStyle.pointType {
        case .filled:
            ForEach(dataSets.dataPoints.indices, id: \.self) { index in
                Point2(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
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
                Point2(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
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
                Point2(value: dataSets.dataPoints[index].value,
                       index: index,
                       minValue: minValue,
                       range: range,
                       datapointCount: dataSets.dataPoints.count,
                       pointSize: dataSets.pointStyle.pointSize,
                       ignoreZero: dataSets.style.ignoreZero,
                       pointStyle: dataSets.pointStyle.pointShape)
                    .ifElse(!isFilled, if: {
                        $0.trim(to: startAnimation ? 1 : 0)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                    }, else: {
                        $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                            .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                    })
                    .background(Point2(value: dataSets.dataPoints[index].value,
                                       index: index,
                                       minValue: minValue,
                                       range: range,
                                       datapointCount: dataSets.dataPoints.count,
                                       pointSize: dataSets.pointStyle.pointSize,
                                       ignoreZero: dataSets.style.ignoreZero,
                                       pointStyle: dataSets.pointStyle.pointShape)
                                    .foregroundColor(dataSets.pointStyle.fillColour)
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

internal struct Point2: Shape {
    
    private let value: Double
    private let index: Int
    private let minValue: Double
    private let range: Double
    private let datapointCount: Int
    private let pointSize: CGFloat
    private let ignoreZero: Bool
    private let pointStyle: PointShape
    
    internal init(
        value: Double,
        index: Int,
        minValue: Double,
        range: Double,
        datapointCount: Int,
        pointSize: CGFloat,
        ignoreZero: Bool,
        pointStyle: PointShape
    ) {
        self.value = value
        self.index = index
        self.minValue = minValue
        self.range = range
        self.datapointCount = datapointCount
        self.pointSize = pointSize
        self.ignoreZero = ignoreZero
        self.pointStyle = pointStyle
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let x: CGFloat = rect.width / CGFloat(datapointCount-1)
        let y: CGFloat = rect.height / CGFloat(range)
        let offset: CGFloat = pointSize / CGFloat(2)
        
        let pointX: CGFloat = (CGFloat(index) * x) - offset
        let pointY: CGFloat = ((CGFloat(value - minValue) * -y) + rect.height) - offset
        let point: CGRect = CGRect(x: pointX, y: pointY, width: pointSize, height: pointSize)
        if !ignoreZero {
            pointSwitch(&path, point)
        } else {
            if value != 0 {
                pointSwitch(&path, point)
            }
        }
        return path
    }
    
    /// Draws the points based on chosen parameters.
    /// - Parameters:
    ///   - path: Path to draw on.
    ///   - point: Position to draw the point.
    internal func pointSwitch(_ path: inout Path, _ point: CGRect) {
        switch pointStyle {
        case .circle:
            path.addEllipse(in: point)
        case .square:
            path.addRect(point)
        case .roundSquare:
            path.addRoundedRect(in: point, cornerSize: CGSize(width: 3, height: 3))
        }
    }
}
