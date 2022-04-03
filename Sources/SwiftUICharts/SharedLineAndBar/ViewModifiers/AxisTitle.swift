//
//  AxisTitle.swift
//  
//
//  Created by Will Dale on 03/01/2022.
//

import SwiftUI

public struct AxisTitleStyle {
    /// Font of the axis title.
    public var font: Font
    
    /// Colour of the x axis title.
    public var colour: Color
    
    /// Padding between the title and next element
    public var padding: CGFloat
    
    public init(
        font: Font = .caption,
        colour: Color = .primary,
        padding: CGFloat = 8
    ) {
        self.font = font
        self.colour = colour
        self.padding = padding
    }
    
    public enum Edge: Hashable, Identifiable {
        case top(text: String)
        case leading(text: String)
        case trailing(text: String)
        case bottom(text: String)
        
        public var id: String {
            switch self {
            case .top(let text):
                return "-top-\(text)"
            case .leading(let text):
                return "-leading-\(text)"
            case .trailing(let text):
                return "-trailing-\(text)"
            case .bottom(let text):
                return "-bottom-\(text)"
            }
        }
        
        var text: String {
            switch self {
            case let .top(text): return text
            case let .leading(text): return text
            case let .trailing(text): return text
            case let .bottom(text): return text
            }
        }
        
        internal var isTop: Bool {
            switch self {
            case .top: return true
            default: return false
            }
        }
        internal var isLeading: Bool {
            switch self {
            case .leading: return true
            default: return false
            }
        }
        internal var isTrailing: Bool {
            switch self {
            case .trailing: return true
            default: return false
            }
        }
        internal var isBottom: Bool {
            switch self {
            case .bottom: return true
            default: return false
            }
        }
    }
}

extension AxisTitleStyle {
    public static let standard = AxisTitleStyle(font: .caption, colour: .primary, padding: 8)
}

// MARK: - API
extension View {
    public func axisTitles(
        edges: Set<AxisTitleStyle.Edge>,
        style: AxisTitleStyle
    ) -> some View {
        self.modifier(_AxisTitles(edges: Array(edges)))
    }
}

// MARK: - Internal
//
//
//
// MARK: View Modifier
internal struct _AxisTitles: ViewModifier {
    
    internal let edges: [AxisTitleStyle.Edge]
    internal let style: AxisTitleStyle = .standard
    
    internal func body(content: Content) -> some View {
        content
            .modifier(__AxisTitle(edge: edge(in: edges, at: 0), style: style))
            .modifier(__AxisTitle(edge: edge(in: edges, at: 1), style: style))
            .modifier(__AxisTitle(edge: edge(in: edges, at: 2), style: style))
            .modifier(__AxisTitle(edge: edge(in: edges, at: 3), style: style))
    }
    
    private func edge(
        in edges: [AxisTitleStyle.Edge],
        at index: Int
    ) -> AxisTitleStyle.Edge? {
        switch index {
        case 0: return edges.first { $0.isLeading }
        case 1: return edges.first { $0.isTrailing}
        case 2: return edges.first { $0.isTop     }
        case 3: return edges.first { $0.isBottom  }
        default: return nil
        }
    }
}

fileprivate struct __AxisTitle: ViewModifier {

    internal let edge: AxisTitleStyle.Edge?
    internal let style: AxisTitleStyle

    internal func body(content: Content) -> some View {
        switch edge {
        case .top:
            VStack(spacing: style.padding) {
                XAxisTitle(edge: edge, style: style)
                content
            }
        case .bottom:
            VStack(spacing: style.padding) {
                content
                XAxisTitle(edge: edge, style: style)
            }
        case .leading:
            HStack(spacing: style.padding) {
                YAxisTitle(edge: edge, style: style)
                content
            }
        case .trailing:
            HStack(spacing: style.padding) {
                content
                YAxisTitle(edge: edge, style: style)
            }
        default:
            content
        }
    }
}

// MARK: X View
internal struct XAxisTitle: View {
    
    @EnvironmentObject internal var stateObject: ChartStateObject
    
    internal let edge: AxisTitleStyle.Edge?
    internal let style: AxisTitleStyle
    
    @State private var height: CGFloat = 0
    
    internal var body: some View {
        Text(LocalizedStringKey(edge?.text ?? ""))
            .font(style.font)
            .foregroundColor(style.colour)
            .background(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .onAppear {
                            let element = element(for: edge)
                            let value = geo.frame(in: .local).height
                            stateObject.updateLayoutElement(with: ChartStateObject.Model(element: element, value: value + padding + style.padding))
                            height = value
                        }
                }
            )
            .position(x: stateObject.leadingInset + (stateObject.chartSize.width / 2),
                      y: padding)
            .frame(height: height)
    }
    
    private var padding: CGFloat {
        return (edge?.isBottom ?? false) ? 4 : 0
    }
    
    private func element(for edge: AxisTitleStyle.Edge?) -> ChartStateObject.Model.Element {
        switch edge {
        case .top:
            return .topTitle
        case .bottom:
            return .bottomTitle
        default:
            return .bottomTitle
        }
    }
}

// MARK: Y View
internal struct YAxisTitle: View {
    
    @EnvironmentObject internal var stateObject: ChartStateObject
    
    internal let edge: AxisTitleStyle.Edge?
    internal let style: AxisTitleStyle
    
    @State private var width: CGFloat = 0
    
    internal var body: some View {
        Text(LocalizedStringKey(edge?.text ?? ""))
            .font(style.font)
            .foregroundColor(style.colour)
            .background(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .onAppear {
                            let element = element(for: edge)
                            let value = geo.frame(in: .local).height
                            stateObject.updateLayoutElement(with: ChartStateObject.Model(element: element, value: value + padding + style.padding))
                            width = value
                        }
                }
            )
            .rotationEffect(Angle(degrees: -90), anchor: .center)
            .fixedSize()
            .position(x: padding,
                      y: stateObject.topInset + (stateObject.chartSize.height / 2))
            .frame(width: width)
    }
    
    private var padding: CGFloat {
        (edge?.isLeading ?? false) ? 0 : 4
    }
    
    private func element(for edge: AxisTitleStyle.Edge?) -> ChartStateObject.Model.Element {
        switch edge {
        case .leading:
            return .leadingTitle
        case .trailing:
            return .trailingTitle
        default:
            return .leadingTitle
        }
    }
}
