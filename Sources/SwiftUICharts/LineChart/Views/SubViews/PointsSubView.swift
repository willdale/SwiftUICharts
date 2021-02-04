//
//  PointsSubView.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

internal struct PointsSubView: View {
    
    private let dataSets: LineDataSet
    private let minValue : Double
    private let range    : Double
    private let animation: Animation
    private let isFilled : Bool
    
    @State var startAnimation : Bool = false
    
    internal init(dataSets  : LineDataSet,
                  minValue  : Double,
                  range     : Double,
                  animation : Animation,
                  isFilled  : Bool
    ) {
        self.dataSets = dataSets
        self.minValue = minValue
        self.range = range
        self.animation = animation
        self.isFilled = isFilled
    }
    
    internal var body: some View {
        switch dataSets.pointStyle.pointType {
        case .filled:
            
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .ifElse(!isFilled, if: {
                    $0.trim(to: startAnimation ? 1 : 0)
                        .fill(dataSets.pointStyle.fillColour)
                }, else: {
                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .fill(dataSets.pointStyle.fillColour)
                })
                .animateOnAppear(using: animation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: animation) {
                    self.startAnimation = false
                }
            
        case .outline:
            
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .ifElse(!isFilled, if: {
                    $0.trim(to: startAnimation ? 1 : 0)
                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                }, else: {
                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                })
                .animateOnAppear(using: animation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: animation) {
                    self.startAnimation = false
                }
            
        case .filledOutLine:
            
            Point(dataSet   : dataSets,
                  minValue  : minValue,
                  range     : range)
                .ifElse(!isFilled, if: {
                    $0.trim(to: startAnimation ? 1 : 0)
                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                }, else: {
                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .stroke(dataSets.pointStyle.borderColour, lineWidth: dataSets.pointStyle.lineWidth)
                })
                
                .background(Point(dataSet   : dataSets,
                                  minValue  : minValue,
                                  range     : range)
                                .foregroundColor(dataSets.pointStyle.fillColour)
                )
                .animateOnAppear(using: animation) {
                    self.startAnimation = true
                }
                .animateOnDisappear(using: animation) {
                    self.startAnimation = false
                }
            
        }
    }
    
}

