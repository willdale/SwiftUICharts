//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisGrid<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData : T
        
    internal func body(content: Content) -> some View {
        ZStack {
//            if chartData.isGreaterThanTwo {
                HStack {
                    ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines), id: \.self) { index in
                        if index != 0 {
                            VerticalGridView(chartData: chartData)
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                    VerticalGridView(chartData: chartData)
                }
//            }
            content
        }
    }
}

extension View {
    /**
     Adds vertical lines along the X axis.
    */
    public func xAxisGrid<T: ChartData>(chartData: T) -> some View {
        self.modifier(XAxisGrid(chartData: chartData))
    }
}


internal struct VerticalGridView<T>: View where T: ChartData {
    
    var chartData : T
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        VerticalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.xAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.xAxisGridStyle.lineWidth,
                                       dash     : chartData.chartStyle.xAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.xAxisGridStyle.dashPhase))
            .frame(width: chartData.chartStyle.xAxisGridStyle.lineWidth)
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation.toggle()
            }
    }
}
internal struct VerticalGridShape: Shape {
    
    internal func path(in rect: CGRect) -> Path {
        
        var path  = Path()

        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
    
}
