//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

public typealias BorderSet = Set<ChartBorder>
public typealias BorderStyle = ChartBorder.Style

// MARK: - Style
public enum ChartBorder: Hashable, Identifiable {
    case top(direction: HorizontalAnimationDirection, style: BorderStyle)
    case bottom(direction: HorizontalAnimationDirection, style: BorderStyle)
    case leading(direction: VerticalAnimationDirection, style: BorderStyle)
    case trailing(direction: VerticalAnimationDirection, style: BorderStyle)
    
    public var id: Self { self }
    
    public enum VerticalAnimationDirection: Hashable {
        case up
        case middle
        case down
    }
    
    public enum HorizontalAnimationDirection: Hashable {
        case leading
        case middle
        case trailing
    }
    
    public struct Style: Hashable {
        /// Line Colour
        public var colour: Color
        
        /// Line Width
        public var style: StrokeStyle
        
        public var animation: Animation
        
        /// Model for controlling the look of the Grid
        /// - Parameters:
        ///   - lineColour: Line Colour
        ///   - lineWidth: Line Width
        ///   - dash: Dash
        ///   - dashPhase: Dash Phase
        public init(
            colour: Color = Color(.gray).opacity(0.25),
            style: StrokeStyle = StrokeStyle(),
            animation: Animation //= .linear(duration: 1)
        ) {
            self.colour = colour
            self.style = style
            self.animation = animation
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(colour)
            hasher.combine(style)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .top:
            hasher.combine("ChartBorder.Side.top(direction: .middle)")
        case .leading:
            hasher.combine("ChartBorder.Side.leading(direction: .middle)")
        case .trailing:
            hasher.combine("ChartBorder.Side.trailing(direction: .middle)")
        case .bottom:
            hasher.combine("ChartBorder.Side.bottom(direction: .middle)")
        }
    }
    
    internal enum Direction {
        case up
        case down
        
        case middle
        
        case leading
        case trailing
    }
    
    internal var reverse: (ChartBorder, ChartBorder) {
        switch self {
        case .top:
            return (.top(direction: .leading, style: .noStyle),
                    .top(direction: .trailing, style: .noStyle))
        case .bottom:
            return (.bottom(direction: .leading, style: .noStyle),
                    .bottom(direction: .trailing, style: .noStyle))
        case .leading:
            return (.leading(direction: .up, style: .noStyle),
                    .leading(direction: .down, style: .noStyle))
        case .trailing:
            return (.trailing(direction: .up, style: .noStyle),
                    .trailing(direction: .down, style: .noStyle))
        }
    }
    
    internal var isMiddle: Bool {
        switch self {
        case .top(direction: let direction, _):
            if direction == .middle {
                return true
            }
            return false
        case .bottom(direction: let direction, _):
            if direction == .middle {
                return true
            }
            return false
        case .leading(direction: let direction, _):
            if direction == .middle {
                return true
            }
            return false
        case .trailing(direction: let direction, _):
            if direction == .middle {
                return true
            }
            return false
        }
    }
    
    var style: Style {
        switch self {
        case .top(_, let style):
            return style
        case .bottom(_, let style):
            return style
        case .leading(_, let style):
            return style
        case .trailing(_, let style):
            return style
        }
    }
    
    var animation: Animation {
        switch self {
        case .top(_, let style):
            return style.animation
        case .bottom(_, let style):
            return style.animation
        case .leading(_, let style):
            return style.animation
        case .trailing(_, let style):
            return style.animation
        }
    }
}

extension ChartBorder.Style {
//    public static let white = ChartBorder.Style(colour: Color(.white))
//    public static let lightGray = ChartBorder.Style(colour: Color(.gray).opacity(0.50))
//    public static let gray = ChartBorder.Style(colour: Color(.gray))
//    public static let black = ChartBorder.Style(colour: Color(.black))
//    public static let primary =   ChartBorder.Style(colour: Color.primary)
    
    internal static let noStyle = ChartBorder.Style(colour: .clear, animation: .default)
}

// MARK: - API
extension View {
    public func axisBorder(
        edges: BorderSet
    ) -> some View {
        self.modifier(AxisBorder(edges: Array(edges)))
    }
}

internal struct AxisBorder: ViewModifier {
    
    internal let edges: [ChartBorder]
    
    internal func body(content: Content) -> some View {
        ZStack {
            ForEach(edges, id: \.id) { edge in
                switch edge.isMiddle {
                case false:
                    _Animate_From_Corner(edge: edge)
                case true:
                    _Animate_From_Middle(edge: edge)
                }

                content
            }
        }
    }
}

fileprivate struct _Animate_From_Corner: View {
    
    internal let edge: ChartBorder
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AxisBorderShape(edge: edge)
                .trim(from: 0.0, to: animate ? 1.0 : 0.0)
                .stroke(edge.style.colour, style: edge.style.style)
        }
        .animateOnAppear(using: edge.style.animation) {
            self.animate = true
        }
    }
}

fileprivate struct _Animate_From_Middle: View {
    
    internal let edge: ChartBorder
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AxisBorderShape(edge: edge.reverse.0)
                .trim(from: 0.5, to: animate ? 1.0 : 0.5)
                .stroke(edge.style.colour, style: edge.style.style)
            AxisBorderShape(edge: edge.reverse.1)
                .trim(from: 0.5, to: animate ? 1.0 : 0.5)
                .stroke(edge.style.colour, style: edge.style.style)
        }
        .animateOnAppear(using: edge.style.animation) {
            self.animate = true
        }
    }
}

public struct AxisBorderShape: Shape {
    
    let edge: ChartBorder
    
    public func path(in rect: CGRect) -> Path {
        switch edge {
        case .top(let direction, _):
            switch direction {
            case .leading:
                return Path._topTrailing_to_topLeading(rect)
            case .trailing:
                return Path._topLeading_to_topTrailing(rect)
            default:
                return Path._topLeading_to_topTrailing(rect)
            }
        case .leading(let direction, _):
            switch direction {
            case .up:
                return Path._leadingBottom_to_leadingTop(rect)
            case .down:
                return Path._leadingTop_to_leadingBottom(rect)
            default:
                return Path._leadingTop_to_leadingBottom(rect)
            }
        case .bottom(let direction, _):
            switch direction {
            case .leading:
                return Path._bottomTrailing_to_bottomLeading(rect)
            case .trailing:
                return Path._bottomLeading_to_bottomTrailing(rect)
            default:
                return Path._bottomLeading_to_bottomTrailing(rect)
            }
        case .trailing(let direction, _):
            switch direction {
            case .up:
                return Path._bottomTrailing_to_topTrailing(rect)
            case .down:
                return Path._topTrailing_to_bottomTrailing(rect)
            default:
                return Path._topTrailing_to_bottomTrailing(rect)
            }
        }
    }
}

extension Path {
    static func topLeading(_ rect: CGRect) -> CGPoint { CGPoint(x: rect.minX, y: rect.minY) }
    static func bottomLeading(_ rect: CGRect) -> CGPoint { CGPoint(x: rect.minX, y: rect.maxY) }
    static func bottomTrailing(_ rect: CGRect) -> CGPoint { CGPoint(x: rect.maxX, y: rect.maxY) }
    static func topTrailing(_ rect: CGRect) -> CGPoint { CGPoint(x: rect.maxX, y: rect.minY) }
    
    static func _leadingBottom_to_leadingTop(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.bottomLeading(rect))
        path.addLine(to: Self.topLeading(rect))
        return path
    }
    
    static func _leadingTop_to_leadingBottom(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.topLeading(rect))
        path.addLine(to: Self.bottomLeading(rect))
        return path
    }
    
    static func _bottomLeading_to_bottomTrailing(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.bottomLeading(rect))
        path.addLine(to: Self.bottomTrailing(rect))
        return path
    }
    
    static func _bottomTrailing_to_bottomLeading(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.bottomTrailing(rect))
        path.addLine(to: Self.bottomLeading(rect))
        return path
    }
    
    static func _bottomTrailing_to_topTrailing(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.bottomTrailing(rect))
        path.addLine(to: Self.topTrailing(rect))
        return path
    }
    
    static func _topTrailing_to_bottomTrailing(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.topTrailing(rect))
        path.addLine(to: Self.bottomTrailing(rect))
        return path
    }
    
    static func _topLeading_to_topTrailing(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.topLeading(rect))
        path.addLine(to: Self.topTrailing(rect))
        return path
    }
    
    static func _topTrailing_to_topLeading(_ rect: CGRect) -> Path {
        var path = Path()
        path.move(to: Self.topTrailing(rect))
        path.addLine(to: Self.topLeading(rect))
        return path
    }
}
