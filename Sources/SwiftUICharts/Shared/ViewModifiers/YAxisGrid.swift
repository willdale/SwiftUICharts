//
//  YAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisGrid<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData : T
    
    internal func body(content: Content) -> some View {
         ZStack {
//            if chartData.isGreaterThanTwo {
                VStack {
                    ForEach((0...chartData.chartStyle.yAxisGridStyle.numberOfLines), id: \.self) { index in
                        if index != 0 {
                            
                            HorizontalGridView(chartData: chartData)
                            
                            Spacer()
                                .frame(minHeight: 0, maxHeight: 500)
                        }
                    }
                    HorizontalGridView(chartData: chartData)
                }
//            }
            content
        }
    }
}

extension View {
    /**
     Adds horizontal lines along the X axis.
     
     The style is set in ChartData --> LineChartStyle --> yAxisGridStyle
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
          
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with horizontal lines under it.
     
     - Tag: YAxisGrid
    */
    public func yAxisGrid<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(YAxisGrid<T>(chartData: chartData))
    }
}


internal struct HorizontalGridView<T>: View where T: LineAndBarChartData {
    
    var chartData : T
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.yAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.yAxisGridStyle.lineWidth,
                                       dash     : chartData.chartStyle.yAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.yAxisGridStyle.dashPhase))
            .frame(height: chartData.chartStyle.yAxisGridStyle.lineWidth)
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}
internal struct HorizontalGridShape: Shape {
    
    internal func path(in rect: CGRect) -> Path {
        
        var path  = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        return path
    }
}
