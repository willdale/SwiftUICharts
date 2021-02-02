//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI


/// - Tag: PointMarkers
internal struct PointMarkers<T>: ViewModifier where T: LineChartDataProtocol {
        
    @ObservedObject var chartData: T
        
    private let minValue : Double
    private let range    : Double
        
    internal init(chartData : T) {
        self.chartData  = chartData
        
        switch chartData.chartStyle.baseline {
        case .minimumValue:
            self.minValue = chartData.getMinValue()
            self.range    = chartData.getRange()
        case .zero:
            self.minValue = 0
            self.range    = chartData.getMaxValue()
        }
        
        
    }
    internal func body(content: Content) -> some View {
        ZStack {
            content
            if chartData.chartType.dataSetType == .single {
                
                let data = chartData as! LineChartData
                PointsSubView(dataSets: data.dataSets, minValue: minValue, range: range, animation: chartData.chartStyle.globalAnimation, isFilled: chartData.isFilled)
                    
            } else if chartData.chartType.dataSetType == .multi {
                
                let data = chartData as! MultiLineChartData
                ForEach(data.dataSets.dataSets, id: \.self) { dataSet in
                    PointsSubView(dataSets: dataSet, minValue: minValue, range: range,  animation: chartData.chartStyle.globalAnimation, isFilled: chartData.isFilled)
                }
            }
        }
    }
}

extension View {
    /// Lays out markers over each of the data point.
    ///
    /// The style of the markers is set in the PointStyle data model as parameter in ChartData
    public func pointMarkers<T: LineChartDataProtocol>(chartData: T) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}

struct PointsSubView: View {
    
    let dataSets: LineDataSet
    let minValue : Double
    let range    : Double
    let animation: Animation
    let isFilled : Bool
    
    @State var startAnimation : Bool = false
    
    var body: some View {
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
