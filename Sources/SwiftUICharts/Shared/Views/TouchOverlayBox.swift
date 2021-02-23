//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
View that displays information from the touch events.
 */
internal struct TouchOverlayBox<D: CTChartDataPoint>: View {
    
    private var isTouchCurrent      : Bool
    private var selectedPoints      : [D]
    private var specifier           : String
    
    private var valueColour         : Color
    private var descriptionColour   : Color
    
    private var ignoreZero          : Bool
    
    @Binding private var boxFrame   :  CGRect
    
    internal init(isTouchCurrent    : Bool,
                  selectedPoints    : [D],
                  specifier         : String   = "%.0f",
                  valueColour       : Color,
                  descriptionColour : Color,
                  boxFrame          : Binding<CGRect>,
                  ignoreZero        : Bool     = false
    ) {
        self.isTouchCurrent     = isTouchCurrent
        self.selectedPoints     = selectedPoints
        self.specifier          = specifier
        self.valueColour        = valueColour
        self.descriptionColour  = descriptionColour
        self._boxFrame          = boxFrame
        self.ignoreZero         = ignoreZero
    }
    
    internal var body: some View {
        
        HStack {
            ForEach(selectedPoints, id: \.self) { point in
                if ignoreZero && point.value != 0 {
                    Text("\(point.value, specifier: specifier)")
                        .font(.subheadline)
                        .foregroundColor(valueColour)
                } else if !ignoreZero {
                    Text("\(point.value, specifier: specifier)")
                        .font(.subheadline)
                        .foregroundColor(valueColour)
                }
                if let label = point.pointDescription {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(descriptionColour)
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if isTouchCurrent {
                    Group {
                        RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                            .fill(Color.systemsBackground)
                    }
                    .overlay(
                        Group {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.primary, lineWidth: 1)
                        }
                    )
                    .onChange(of: geo.frame(in: .local)) { frame in
                        self.boxFrame = frame
                    }
                }
            }
        )
    }
}
