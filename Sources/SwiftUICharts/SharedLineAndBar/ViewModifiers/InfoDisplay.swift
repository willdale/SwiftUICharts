//
//  InfoDisplay.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

// MARK: - API
extension View {
    /// Customisable display of the data from `touch`.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<Info>(
        infoView: Info,
        position: @escaping (_ boxSize: CGRect) -> CGPoint
    ) -> some View
    where Info: View
    {
        self.modifier(InfoDisplay(infoView: infoView, position: position))
    }
    
    /// Templated display of the data from `touch`.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData>(
//        datapoints: [DataPoint],
        chartData: ChartData,
        infoView: InfoView,
        position: @escaping (_ boxSize: CGRect) -> CGPoint
    ) -> some View
    where ChartData: CTChartData & Publishable, ChartData.DataPoint: DataPointDisplayable
    {
        Group {
            switch infoView {
            case .vertical(let style):
                self.modifier(InfoDisplay(infoView: __Vertical_Info_PreSet(chartData: chartData, style: style),
                                          position: position))
            case .horizontal(let style):
                self.modifier(InfoDisplay(infoView: __Horizontal_Info_PreSet(chartData: chartData, style: style),
                                          position: position))
            }
        }
    }
}

public enum InfoView {
    case vertical(style: InfoBoxStyle)
    case horizontal(style: InfoBoxStyle)
}

// MARK: - Implementation
internal struct InfoDisplay<Info>: ViewModifier where Info: View {
    
    @EnvironmentObject internal var stateObject: ChartStateObject
    internal var infoView: Info
    internal var position: (CGRect) -> CGPoint
    
    @State private var size: CGRect = .zero
        
    internal func body(content: Content) -> some View {
        ZStack {
            content
            __ViewSize(infoView: infoView, size: $size)
                .position(x: stateObject.leadingInset + position(size).x,
                          y: stateObject.topInset + position(size).y)
                .zIndex(1)
        }
    }
}

fileprivate struct __ViewSize<Info: View>: View {
   
    internal var infoView: Info
    @Binding internal var size: CGRect
    
    var body: some View {
        infoView
            .background(sizeView)
    }
    
    private var sizeView: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    size = geo.frame(in: .local)
                }
                .onChange(of: geo.frame(in: .local)) {
                    size = $0
                }
        }
    }
}

// MARK: - Presets
fileprivate struct __Vertical_Info_PreSet<ChartData>: View where ChartData: CTChartData & Publishable,
                                                                 ChartData.DataPoint: DataPointDisplayable {
    
    @EnvironmentObject var stateObject: ChartStateObject
    let chartData: ChartData
    let style: InfoBoxStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(chartData.touchPointData, id: \.id) { point in
                Group {
                    Text(LocalizedStringKey(point.wrappedDescription))
                        .font(style.valueFont)
                        .foregroundColor(style.valueColour)
                    Text(point.formattedValue(from: .default))
                        .font(style.descriptionFont)
                        .foregroundColor(style.descriptionColour)
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if stateObject.isTouch {
                    Rectangle()
                        .fill(style.backgroundColour)
                        .overlay(
                            Rectangle()
                                .stroke(style.borderColour, style: style.borderStyle)
                        )
                }
            }
        )
    }
}

fileprivate struct __Horizontal_Info_PreSet<ChartData>: View where ChartData: CTChartData & Publishable,
                                                                   ChartData.DataPoint: DataPointDisplayable {
    
    @EnvironmentObject var stateObject: ChartStateObject
    let chartData: ChartData
    let style: InfoBoxStyle
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(chartData.touchPointData, id: \.id) { point in
                Group {
                    Text(LocalizedStringKey(point.wrappedDescription))
                        .font(style.valueFont)
                        .foregroundColor(style.valueColour)
                    Text(point.formattedValue(from: .default))
                        .font(style.descriptionFont)
                        .foregroundColor(style.descriptionColour)
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if stateObject.isTouch {
                    Rectangle()
                        .fill(style.backgroundColour)
                        .overlay(
                            Rectangle()
                                .stroke(style.borderColour, style: style.borderStyle)
                        )
                }
            }
        )
    }
}
