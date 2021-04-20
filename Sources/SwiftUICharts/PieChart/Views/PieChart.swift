//
//  PieChart.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 View for creating a pie chart.
 
 Uses `PieChartData` data model.
 
 # Declaration
 ```
 PieChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct PieChart<ChartData>: View where ChartData: PieChartData {
    
    @ObservedObject var chartData: ChartData

    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be PieChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation: Bool = false
    
    public var body: some View {
        GeometryReader { geo in
        ZStack {
                ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                    
                    PieSegmentShape(id:         chartData.dataSets.dataPoints[data].id,
                                    startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                    amount:     chartData.dataSets.dataPoints[data].amount)
                        .fill(chartData.dataSets.dataPoints[data].colour)
                        .overlay(
                            Text(chartData.dataSets.dataPoints[data].wrappedDescription)
                                .foregroundColor(chartData.dataSets.dataPoints[data].labelColour)
                                .position(getPosition(rect: geo.frame(in: .local),
                                                      startRad: chartData.dataSets.dataPoints[data].startAngle,
                                                      amountRad: chartData.dataSets.dataPoints[data].amount))

                        )
                        
//                        .scaleEffect(startAnimation ? 1 : 0)
//                        .opacity(startAnimation ? 1 : 0)
//                        .animation(Animation.spring().delay(Double(data) * 0.06))


                        
//                        .if(chartData.infoView.touchOverlayInfo == [chartData.dataSets.dataPoints[data]]) {
//                            $0
//                                .scaleEffect(1.1)
//                                .zIndex(1)
//                                .shadow(color: Color.primary, radius: 10)
//                        }
//                        .accessibilityLabel(Text("\(chartData.metadata.title)"))
//                        .accessibilityValue(chartData.dataSets.dataPoints[data].getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
                    
//                        .onAppear {
//                            let start = (chartData.dataSets.dataPoints[data].startAngle * Double(180 / Double.pi)) + 90
//                            let amount = chartData.dataSets.dataPoints[data].amount * Double(180 / Double.pi)
//
//                            print(start, amount, (start + (start + amount)) / 2)
//                        }
                }
            }
        }
        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
        .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = false
        }
    }
    func getPosition(rect: CGRect, startRad: Double, amountRad: Double) -> CGPoint {
        
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        
        let startDegree = (startRad * Double(180 / Double.pi)) + 90
        let amountDegree = amountRad * Double(180 / Double.pi)
        let segmentDegree = (startDegree + (startDegree + amountDegree)) / 2
        let segmentRad = CGFloat.pi * CGFloat(segmentDegree - 90) / 180
        
        let x = center.x + (radius * 0.75) * cos(segmentRad)
        let y = center.y + (radius * 0.75) * sin(segmentRad)
        
        return CGPoint(x: x, y: y)
    }
}
