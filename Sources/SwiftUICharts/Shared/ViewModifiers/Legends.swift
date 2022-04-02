//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

public struct Legend: Hashable {
    public let id: UUID = UUID()
    public let chartType: ChartType
    public let text: String
    public let font: Font
    public let textColor: Color
    public let shapeColour: ChartColour
    public let shapeWidth: CGFloat
    public let strokeStyle: StrokeStyle?
    
    public init(
        chartType: ChartType,
        text: String,
        font: Font = .caption,
        textColor: Color = .primary,
        shapeColour: ChartColour = .colour(colour: .red),
        shapeWidth: CGFloat = 25,
        strokeStyle: StrokeStyle? = nil
    ) {
        self.chartType = chartType
        self.text = text
        self.font = font
        self.textColor = textColor
        self.shapeColour = shapeColour
        self.shapeWidth = shapeWidth
        self.strokeStyle = strokeStyle
    }
    
    var wrappedStyle: StrokeStyle {
        strokeStyle ?? StrokeStyle()
    }
}

public struct CustomLegend<U: View>: Hashable {
    public let id: UUID = UUID()
    public let legend: U
    
    public init(legend: U) {
        self.legend = legend
    }
    
    public static func == (lhs: CustomLegend<U>, rhs: CustomLegend<U>) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct LegendsStyle {
    var columns: [GridItem] = [GridItem(.flexible())]
    var font: Font? = .caption
    var textColour: Color? = .primary
    var alignment: HorizontalAlignment = .leading
    var topPadding: CGFloat = 18
}

extension LegendsStyle {
    public static let standard = Self(columns: [GridItem(.flexible())], font: .caption, textColour: .primary, alignment: .leading, topPadding: 18)
}

extension View {
    public func legends(
        legends: [Legend],
        style: LegendsStyle
    ) -> some View {
        self.modifier(_Legends(legends: legends, style: style))
    }
    
    public func legends<U: View>(
        legends: [CustomLegend<U>],
        style: LegendsStyle
    ) -> some View {
        self.modifier(_CustomLegends(legends: legends, style: style))
    }
}

fileprivate struct _Legends: ViewModifier {

    let legends: [Legend]
    let style: LegendsStyle
    
    internal func body(content: Content) -> some View {
        VStack {
            content
            LegendsView(legends: legends, style: style)
        }
    }
}

fileprivate struct _CustomLegends<U: View>: ViewModifier {
    
    let legends: [CustomLegend<U>]
    let style: LegendsStyle
    
    internal func body(content: Content) -> some View {
        VStack {
            content
            LazyVGrid(columns: style.columns, alignment: style.alignment) {
                ForEach(legends, id:\.id) { legend in
                    legend.legend
                }
            }
        }
    }
}

public struct LegendsView: View {
    
    public let legends: [Legend]
    public let style: LegendsStyle
        
    public var body: some View {
        LazyVGrid(columns: style.columns, alignment: style.alignment) {
            ForEach(legends, id:\.id) { legend in
                HStack {
                    legend.chartType.legend(for: legend)
                    Text(legend.text)
                        .font(style.font ?? legend.font)
                        .foregroundColor(style.textColour ?? legend.textColor)
                }
            }
        }
    }
}

extension ChartType {
    fileprivate func legend(for legend: Legend) -> some View {
        Group {
            switch self {
            case .line:
                LegendLine(width: legend.shapeWidth)
                    .stroke(legend.shapeColour, strokeStyle: legend.wrappedStyle)
                    .frame(width: legend.shapeWidth)
            case .bar:
                Rectangle()
                    .fill(legend.shapeColour)
                    .frame(width: legend.shapeWidth)
            case .pie:
                Circle()
                    .fill(legend.shapeColour)
                    .frame(width: legend.shapeWidth)
            case .extraLine:
                LegendLine(width: legend.shapeWidth).stroke(legend.shapeColour, strokeStyle: legend.wrappedStyle)
                    .frame(width: legend.shapeWidth)
            }
        }
    }
}

// MARK: Depricated
extension View {
    /**
     Displays legends under the chart.
     
     - Parameters:
        - chartData: Chart data model.
        - columns: How to layout the legends.
        - textColor: Colour of the text.
     - Returns: A  new view containing the chart with chart legends under.
     */
    @available(*, deprecated, message: "Please use `` .")
    public func legends(
        chartData: EmptyChartData,
        columns: [GridItem] = [GridItem(.flexible())],
        iconWidth: CGFloat = 40,
        font: Font = .caption,
        textColor: Color = Color.primary,
        topPadding: CGFloat = 18
    ) -> some View {
        self.modifier(EmptyModifier())
    }
}


public class EmptyChartData {}
