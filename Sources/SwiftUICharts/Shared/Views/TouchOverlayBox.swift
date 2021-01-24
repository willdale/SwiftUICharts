//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

internal struct TouchOverlayBox<D: ChartDataPoint>: View {
    
    private var selectedPoints  : [D]
    private var specifier       : String
    private var ignoreZero      : Bool
    
    @Binding private var boxFrame   :  CGRect
    
    internal init(selectedPoints : [D],
                  specifier      : String = "%.0f",
                  boxFrame       : Binding<CGRect>,
                  ignoreZero     : Bool = false
    ) {
        self.selectedPoints  = selectedPoints
        self.specifier      = specifier
        self._boxFrame      = boxFrame
        self.ignoreZero     = ignoreZero
    }
    
    internal var body: some View {
        VStack {
            ForEach(selectedPoints, id: \.self) { point in
                if ignoreZero && point.value != 0 {
                    Text("\(point.value, specifier: specifier)")
                } else if !ignoreZero {
                    Text("\(point.value, specifier: specifier)")
                }
                if let label = point.pointDescription {
                    Text(label)
                } else if let label = point.xAxisLabel {
                    Text(label)
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                ZStack {
                    #if os(iOS)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .shadow(color: Color(.systemGray), radius: 6, x: 0, y: 0)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .fill(Color(.systemBackground))
                    #elseif os(macOS)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .shadow(color: Color(.highlightColor), radius: 6, x: 0, y: 0)
                    RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                        .fill(Color(.windowBackgroundColor))
                    #endif
                    
                }
                .overlay(
                    Group {
                        #if os(iOS)
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.primary, lineWidth: 1)
                        #elseif os(macOS)
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.primary, lineWidth: 2)
                        #endif
                    }
                )
                .onChange(of: geo.frame(in: .local)) { frame in
                    self.boxFrame = frame
                }
            }
        )
    }
}
