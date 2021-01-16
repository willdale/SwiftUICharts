//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisGrid: ViewModifier {
    
    @EnvironmentObject var chartData : ChartData
        
    internal func body(content: Content) -> some View {
        ZStack {
            HStack {
                ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines), id: \.self) { index in
                    if index != 0 {
                        VerticalGridView(chartData: chartData)
                        Spacer()
                    }
                }
                VerticalGridView(chartData: chartData)
            }
            content
        }
    }
}

extension View {
    /**
     Adds vertical lines along the X axis.
    */
    public func xAxisGrid() -> some View {
        self.modifier(XAxisGrid())
    }
}


internal struct VerticalGridView: View {
    
    var chartData : ChartData
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        VerticalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.xAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.xAxisGridStyle.lineWidth,
                                       dash     : chartData.chartStyle.xAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.xAxisGridStyle.dashPhase))
            .frame(width: chartData.chartStyle.xAxisGridStyle.lineWidth)
            .animateOnAppear(using: .linear(duration: 1.0)) {
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
