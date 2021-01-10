//
//  YAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct YAxisGrid: ViewModifier {
    
    private let numberOfLines : Int
        
    internal init(numberOfLines: Int) {
        self.numberOfLines = numberOfLines - 1
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                ForEach((0...numberOfLines), id: \.self) { index in
                    if index != 0 {
                        Divider()
                        Spacer()
                    }
                }
                Divider()
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
    public func yAxisGrid(numberOfLines: Int = 10) -> some View {
        self.modifier(YAxisGrid(numberOfLines: numberOfLines))
    }
}
