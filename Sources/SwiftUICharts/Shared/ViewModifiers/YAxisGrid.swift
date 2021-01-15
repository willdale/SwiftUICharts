//
//  YAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisGrid: ViewModifier {
    
    @EnvironmentObject var chartData : ChartData
    
    internal func body(content: Content) -> some View {
        
         ZStack {
            content
            VStack {
                ForEach((0...chartData.chartStyle.yAxisGridStyle.numberOfLines), id: \.self) { index in
                    if index != 0 {
                        
                        HorizontalGridView(chartData: chartData)
                        
                        Spacer()
                    }
                }
                HorizontalGridView(chartData: chartData)
            }
        }
    }
}

extension View {
    /**
    Adds horizontal lines along the Y axis.
    - Parameter numberOfLines: Number of lines subdividing the chart
    - Returns: View of evenly spaced horizontal lines
    */
    public func yAxisGrid() -> some View {
        self.modifier(YAxisGrid())
    }
}


internal struct HorizontalGridView: View {
    
    var chartData : ChartData
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.yAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.yAxisGridStyle.lineWidth,
                                       dash     : chartData.chartStyle.yAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.yAxisGridStyle.dashPhase))
            .frame(height: chartData.chartStyle.yAxisGridStyle.lineWidth)
            .animateOnAppear(using: .linear(duration: 1.0)) {
                self.startAnimation.toggle()
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
