//
//  PositionedPOILabel.swift
//  SwiftUICharts
//
//  Created by Kunal Verma on 16/01/22.
//

import SwiftUI

internal struct PositionedPOILabel<Content>: View where Content: View {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    let content: () -> Content
    let orientation: Orientation
    let distanceFromLeading: CGFloat
    @State var contentSize: CGFloat = 0
    @State var containerSize: CGFloat = 0
    
    init(@ViewBuilder content: @escaping () -> Content, orientation: Orientation, distanceFromLeading: CGFloat) {
        self.content = content
        self.orientation = orientation
        self.distanceFromLeading = distanceFromLeading
    }
    
    var body: some View {
        if orientation == .horizontal {
            horizontalView()
        } else {
            verticalView()
        }
    }
    
    @ViewBuilder
    func horizontalView() -> some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: (containerSize - contentSize) * distanceFromLeading)
            content()
                .background(
                    GeometryReader { geo in
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .onAppear {
                                self.contentSize = geo.size.width
                            }
                    }
                )
                .fixedSize()
            Spacer()
        }
        .background(
            GeometryReader { stackGeo in
                Rectangle()
                    .foregroundColor(Color.clear)
                    .onAppear {
                        self.containerSize = stackGeo.size.width
                    }
            }
        )
    }
    
    @ViewBuilder
    func verticalView() -> some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: (containerSize - contentSize) * distanceFromLeading)
            content()
                .background(
                    GeometryReader { geo in
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .onAppear {
                                self.contentSize = geo.size.height
                            }
                    }
                )
                .fixedSize()
            Spacer()
        }
        .background(
            GeometryReader { stackGeo in
                Rectangle()
                    .foregroundColor(Color.clear)
                    .onAppear {
                        self.containerSize = stackGeo.size.height
                    }
            }
        )
        
    }
}
