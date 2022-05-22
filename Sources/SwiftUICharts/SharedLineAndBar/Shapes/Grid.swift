//
//  Grid.swift
//  
//
//  Created by Will Dale on 23/01/2022.
//

import SwiftUI
import ChartMath

public typealias GridAnimation = (_ index: Int) -> Animation

// MARK: - API
extension View {
    public func grid(
        vLines: Int = 5,
        hLines: Int = 5,
        style: Grid.Style = .grey,
        vAnimation: @escaping GridAnimation = { (_) in .default },
        hAnimation: @escaping GridAnimation = { (_) in .default }
    ) -> some View {
        self.modifier(__GridModifier(vLines: vLines, hLines: hLines, style: style, vAnimation: vAnimation, hAnimation: hAnimation))
    }
}

extension Grid {
    public struct Style {
        public var colour: ChartColour
        public var stroke: StrokeStyle
        public var edges: Bool
        public var animationStyle: Animation.Style = .draw()
    }
    
    public struct Animation {
        public enum Style {
            case draw(vDirection: VerticalDirection = .top, hDirection: HorizontalDirection = .leading)
            case fade
            
            var vDirection: VerticalDirection? {
                switch self {
                case let .draw(vDirection, _):
                    return vDirection
                default:
                    return nil
                }
            }
            
            var hDirection: HorizontalDirection? {
                switch self {
                case let .draw(_, hDirection):
                    return hDirection
                default:
                    return nil
                }
            }
        }

        public enum VerticalDirection {
            case top
            case bottom
        }

        public enum HorizontalDirection {
            case leading
            case trailing
        }
    }
}

extension Grid.Style {
    public static let grey = Self(colour: .colour(colour: .gray), stroke: StrokeStyle(), edges: true)
    public static let greyNoEdges = Self(colour: .colour(colour: .gray), stroke: StrokeStyle(), edges: false)
    
    public static let lightGrey = Self(colour: .colour(colour: Color(.lightGray)), stroke: StrokeStyle(), edges: true)
    public static let lightGreyNoEdges = Self(colour: .colour(colour: Color(.lightGray)), stroke: StrokeStyle(), edges: false)
}

extension Shape {
    fileprivate func __gridAnimation(animation: Grid.Animation.Style, style: Grid.Style, startAnimation: Bool) -> some View {
        Group {
            switch animation {
            case .draw:
                self.trim(to: startAnimation ? 1 : 0)
                    .stroke(style.colour, strokeStyle: style.stroke)
            case .fade:
                self.stroke(style.colour, strokeStyle: style.stroke)
                    .opacity(startAnimation ? 1 : 0)
            }
        }
    }
}

// MARK: - Grid
public struct Grid: View {
    
    private let vLines: Int
    private let hLines: Int
    private let style: Grid.Style
    private let vAnimation: GridAnimation
    private let hAnimation: GridAnimation
    
    public init(
        vLines: Int,
        hLines: Int,
        style: Grid.Style,
        vAnimation: @escaping GridAnimation,
        hAnimation: @escaping GridAnimation
    ) {
        self.style = style
        self.vLines = vLines
        self.vAnimation = vAnimation
        self.hLines = hLines
        self.hAnimation = hAnimation
    }
    
    public var body: some View {
        HGrid(hLines: hLines, style: style, animation: hAnimation)
        VGrid(vLines: vLines, style: style, animation: vAnimation)
    }
}

fileprivate struct __GridModifier: ViewModifier {
    
    fileprivate let vLines: Int
    fileprivate let hLines: Int
    fileprivate let style: Grid.Style
    fileprivate let vAnimation: GridAnimation
    fileprivate let hAnimation: GridAnimation
    
    fileprivate init(
        vLines: Int,
        hLines: Int,
        style: Grid.Style,
        vAnimation: @escaping GridAnimation,
        hAnimation: @escaping GridAnimation
    ) {
        self.vLines = vLines
        self.hLines = hLines
        self.style = style
        self.vAnimation = vAnimation
        self.hAnimation = hAnimation
    }
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            Grid(vLines: vLines, hLines: hLines, style: style, vAnimation: vAnimation, hAnimation: hAnimation)
            content
        }
    }
}

// MARK: - Horrizontal
public struct HGrid: View {
    
    private let total: Int
    private let style: Grid.Style
    private let animation: GridAnimation
    
    private let data: [Int]
    
    public init(
        hLines: Int,
        style: Grid.Style,
        animation: @escaping GridAnimation
    ) {
        let lower: Int
        let upper: Int
        let total: Int
        if style.edges {
            lower = 0
            upper = hLines-1
            total = hLines
        } else {
            lower = 1
            upper = hLines
            total = hLines+2
        }
        if lower <= upper {
            self.data = Array(lower...upper)
        } else {
            self.data = []
        }
        self.total = total
        self.style = style
        self.animation = animation
    }
    
    public var body: some View {
        ForEach(data, id: \.self) { index in
            __Horrizontal_Grid_Cell(index: index, total: total, style: style, animation: animation)
        }
    }
}

// MARK: Cell
fileprivate struct __Horrizontal_Grid_Cell: View {
    
    private let index: Int
    private let total: Int
    private let style: Grid.Style
    private let animation: GridAnimation
    
    fileprivate init(
        index: Int,
        total: Int,
        style: Grid.Style,
        animation: @escaping GridAnimation
    ) {
        self.index = index
        self.total = total
        self.style = style
        self.animation = animation
    }
    
    @State private var startAnimation: Bool = false
    
    fileprivate var body: some View {
        if total == 1 {
            __Horrizontal_Line_Center(direction: style.animationStyle.hDirection)
                .__gridAnimation(animation: style.animationStyle, style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        } else {
            __Horrizontal_Line(index: index, total: total, direction: style.animationStyle.hDirection)
                .__gridAnimation(animation: style.animationStyle, style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        }
    }
}

// MARK: Shape
fileprivate struct __Horrizontal_Line: Shape {
    
    private let index: Int
    private let total: Int
    private let direction: Grid.Animation.HorizontalDirection
    
    fileprivate init(
        index: Int,
        total: Int,
        direction: Grid.Animation.HorizontalDirection?
    ) {
        self.index = index
        self.total = total
        self.direction = direction ?? .leading
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        let sectionSize = divide(rect.height, total-1)
        let y = CGFloat(index) * sectionSize
        
        let leading = CGPoint(x: rect.minX, y: y)
        let trailing = CGPoint(x: rect.maxX, y: y)
        
        var path = Path()
        if direction == .leading {
            path.move(to: leading)
            path.addLine(to: trailing)
        } else {
            path.move(to: trailing)
            path.addLine(to: leading)
        }
        return path
    }
}

fileprivate struct __Horrizontal_Line_Center: Shape {
    
    private let direction: Grid.Animation.HorizontalDirection
    
    fileprivate init(direction: Grid.Animation.HorizontalDirection?) {
        self.direction = direction ?? .leading
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        let leading = CGPoint(x: rect.minX, y: rect.midX)
        let trailing = CGPoint(x: rect.maxX, y: rect.midX)
        
        var path = Path()
        if direction == .leading {
            path.move(to: leading)
            path.addLine(to: trailing)
        } else {
            path.move(to: trailing)
            path.addLine(to: leading)
        }
        
        return path
    }
}

// MARK: - Vertical
public struct VGrid: View {

    private let total: Int
    private let style: Grid.Style
    private let animation: GridAnimation
    
    private let data: [Int]
        
    public init(
        vLines: Int,
        style: Grid.Style,
        animation: @escaping GridAnimation
    ) {
        let lower: Int
        let upper: Int
        let total: Int
        if style.edges {
            lower = 0
            upper = vLines-1
            total = vLines
        } else {
            lower = 1
            upper = vLines
            total = vLines+2
        }
        
        if lower <= upper {
            self.data = Array(lower...upper)
        } else {
            self.data = []
        }
        self.total = total
        self.style = style
        self.animation = animation
    }
    
    public var body: some View {
        ForEach(data, id: \.self) { index in
            __Vertical_Grid_Cell(index: index, total: total, style: style, animation: animation)
        }
    }
}

// MARK: Cell
fileprivate struct __Vertical_Grid_Cell: View {
    
    private let index: Int
    private let total: Int
    private let style: Grid.Style
    private let animation: GridAnimation
    
    fileprivate init(
        index: Int,
        total: Int,
        style: Grid.Style,
        animation: @escaping GridAnimation
    ) {
        self.index = index
        self.total = total
        self.style = style
        self.animation = animation
    }
    
    @State private var startAnimation: Bool = false
    
    fileprivate var body: some View {
        if total == 1 {
            __Vertical_Line_Center(direction: style.animationStyle.vDirection)
                .__gridAnimation(animation: style.animationStyle, style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        } else {
            __Vertical_Line(index: index, total: total, direction: style.animationStyle.vDirection)
                .__gridAnimation(animation: style.animationStyle, style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        }
    }
}

// MARK: Shape
fileprivate struct __Vertical_Line: Shape {
    
    private let index: Int
    private let total: Int
    private let direction: Grid.Animation.VerticalDirection
    
    fileprivate init(
        index: Int,
        total: Int,
        direction: Grid.Animation.VerticalDirection?
    ) {
        self.index = index
        self.total = total
        self.direction = direction ?? .top
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        let sectionSize = divide(rect.width, total-1)
        let x = CGFloat(index) * sectionSize
        
        let top = CGPoint(x: x, y: rect.minY)
        let bottom = CGPoint(x: x, y: rect.maxY)

        var path = Path()
        if direction == .top {
            path.move(to: top)
            path.addLine(to: bottom)
        } else {
            path.move(to: bottom)
            path.addLine(to: top)
        }

        return path
    }
}

fileprivate struct __Vertical_Line_Center: Shape {
    
    private let direction: Grid.Animation.VerticalDirection
    
    fileprivate init(direction: Grid.Animation.VerticalDirection?) {
        self.direction = direction ?? .top
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)

        var path = Path()
        if direction == .bottom {
            path.move(to: top)
            path.addLine(to: bottom)
        } else {
            path.move(to: bottom)
            path.addLine(to: top)
        }

        return path
    }
}
