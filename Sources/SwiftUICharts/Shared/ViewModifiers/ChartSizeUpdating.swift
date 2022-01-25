//
//  ChartSizeUpdating.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import SwiftUI

internal struct ChartSizeUpdating: ViewModifier {
    
    private(set) var stateObject: ChartStateObject
    
    internal func body(content: Content) -> some View {
        content.background(sizeView)
    }
    
    private var sizeView: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    stateObject.chartSize = geo.frame(in: .local)
                }
                .onChange(of: geo.frame(in: .local)) {
                    stateObject.chartSize = $0
                }
        }
    }
}
