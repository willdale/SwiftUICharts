//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisGrid: ViewModifier {
    
    private let numberOfLines : Int
        
    internal init(numberOfLines: Int) {
        self.numberOfLines = numberOfLines - 1
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            HStack {
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
     Adds vertical lines along the X axis.
      - Parameter numberOfLines: Number of lines subdividing the chart
      - Returns: View of evenly spaced vertical lines
    */
    public func xAxisGrid(numberOfLines: Int = 10) -> some View {
        self.modifier(XAxisGrid(numberOfLines: numberOfLines))
    }
}
