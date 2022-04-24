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
    public func infoDisplay<ChartData, Info>(
        chartData: ChartData,
        infoView: Info,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect, _ boxSize: CGRect) -> CGPoint
    ) -> some View where Info: View, ChartData: CTChartData {
        self.modifier(InfoDisplay(chartData: chartData, infoView: infoView, position: position))
    }
    
    /// Templated display of the data from `touch`.
    @available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
    public func infoDisplay<ChartData>(
        chartData: ChartData,
        infoView: InfoView,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect, _ boxSize: CGRect) -> CGPoint
    ) -> some View where ChartData: CTChartData & Publishable, ChartData.DataPoint: DataPointDisplayable {
        Group {
            switch infoView {
            case .vertical(let style):
                self.modifier(InfoDisplay(chartData: chartData,
                                          infoView: __Vertical_Info_PreSet(chartData: chartData, style: style),
                                          position: position))
            case .horizontal(let style):
                self.modifier(InfoDisplay(chartData: chartData,
                                          infoView: __Horizontal_Info_PreSet(chartData: chartData, style: style),
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
internal struct InfoDisplay<ChartData, Info>: ViewModifier
where Info: View,
      ChartData: CTChartData {

    internal var chartData: ChartData
    @ObservedObject private var touchObject: ChartTouchObject
    internal var infoView: Info
    internal var position: (_ touchLocation: CGPoint, _ chartSize: CGRect, _ boxSize: CGRect) -> CGPoint
    
    init(
        chartData: ChartData,
        infoView: Info,
        position: @escaping (_ touchLocation: CGPoint, _ chartSize: CGRect, _ boxSize: CGRect) -> CGPoint
    ) {
        self.chartData = chartData
        self.touchObject = chartData.touchObject
        self.infoView = infoView
        self.position = position
    }

    @State private var boxSize: CGRect = .zero

    internal func body(content: Content) -> some View {
        ZStack {
            content
            infoView
                .background(sizeView)
                .position(computedPosition)
                .zIndex(1)
        }
    }
    
    var computedPosition: CGPoint {
        let position = position(touchObject.touchLocation, chartData.stateObject.chartSize, boxSize)
        return CGPoint(x: chartData.stateObject.leadingInset + position.x,
                       y: chartData.stateObject.topInset + position.y)
    }
    
    private var sizeView: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    boxSize = geo.frame(in: .local)
                }
                .onChange(of: geo.frame(in: .local)) {
                    boxSize = $0
                }
        }
    }
}

// MARK: - Presets
fileprivate struct __Vertical_Info_PreSet<ChartData>: View where ChartData: CTChartData & Publishable,
                                                                 ChartData.DataPoint: DataPointDisplayable {

    let chartData: ChartData
    @ObservedObject var touchObject: ChartTouchObject
    let style: InfoBoxStyle
    
    init(
        chartData: ChartData,
        style: InfoBoxStyle
    ) {
        self.chartData = chartData
        self.touchObject = chartData.touchObject
        self.style = style
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(chartData.touchedData.touchPointData, id: \.id) { point in
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
                if touchObject.isTouch {
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

    let chartData: ChartData
    @ObservedObject var touchObject: ChartTouchObject
    let style: InfoBoxStyle
    
    init(
        chartData: ChartData,
        style: InfoBoxStyle
    ) {
        self.chartData = chartData
        self.touchObject = chartData.touchObject
        self.style = style
    }


    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(chartData.touchedData.touchPointData, id: \.id) { point in
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
                if touchObject.isTouch {
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
