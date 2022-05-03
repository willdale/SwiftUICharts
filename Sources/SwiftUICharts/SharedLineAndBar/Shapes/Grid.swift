//
//  Grid.swift
//  
//
//  Created by Will Dale on 23/01/2022.
//

import SwiftUI
import ChartMath

// MARK: - API
extension View {
    public func grid(
        vLines: Int = 5,
        hLines: Int = 5,
        style: Grid.Style = .grey,
        animation: @escaping (_ index: Int) -> Animation = { _ in .default }
    ) -> some View {
        self.modifier(__GridModifier(vLines: vLines, hLines: hLines, style: style, animation: animation))
    }
}

extension Grid {
    public struct Style {
        public var colour: ChartColour
        public var stroke: StrokeStyle
        public var edges: Bool
    }
    
    public struct Animation {
        public var style: Style = .draw(direction: .topLeading)

        public enum Style {
            case draw(direction: Direction)
            case fade
        }

        public enum Direction {
            case topLeading
            case topTrailing
            case bottomLeading
            case bottomTrailing

            var data: (v: VerticalDirection, h: HorizontalDirection) {
                switch self {
                case .topLeading:
                    return (v: .top, h: .leading)
                case .topTrailing:
                    return (v: .top, h: .trailing)
                case .bottomLeading:
                    return (v: .bottom, h: .leading)
                case .bottomTrailing:
                    return (v: .bottom, h: .trailing)
                }
            }
        }

        internal enum VerticalDirection {
            case top
            case bottom
        }

        internal enum HorizontalDirection {
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
    
    public let vLines: Int
    public let hLines: Int
    public let style: Grid.Style
    public let animation: (_ index: Int) -> SwiftUI.Animation
    
    private let hRange: Range<Int>
    private let vRange: Range<Int>
    
    public init(
        vLines: Int,
        hLines: Int,
        style: Grid.Style,
        animation: @escaping (_ index: Int) -> SwiftUI.Animation
    ) {
        self.style = style
        self.animation = animation
        
        var hRange = 0..<hLines
        var hLines = hLines
        if !style.edges {
            hLines = hLines + 2
            let lower = 1
            let upper = hLines-1
            hRange = lower..<upper
        }
        self.hLines = hLines
        self.hRange = hRange
        
        var vRange = 0..<vLines
        var vLines = vLines
        if !style.edges {
            vLines = vLines + 2
            let lower = 1
            let upper = vLines-1
            vRange = lower..<upper
        }
        self.vLines = vLines
        self.vRange = vRange
    }
    
    public var body: some View {
        HGrid(hRange: hRange, hLines: hLines, style: style, animation: animation)
        VGrid(vRange: vRange, vLines: vLines, style: style, animation: animation)
    }
}

fileprivate struct __GridModifier: ViewModifier {
    
    fileprivate let vLines: Int
    fileprivate let hLines: Int
    fileprivate let style: Grid.Style
    fileprivate let animation: (_ index: Int) -> Animation
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            Grid(vLines: vLines, hLines: hLines, style: style, animation: animation)
            content
        }
    }
}

// MARK: - Horrizontal
public struct HGrid: View {
    
    public let hRange: Range<Int>
    public let hLines: Int
    public let style: Grid.Style
    public let animation: (_ index: Int) -> Animation
    
    public init(
        hRange: Range<Int>,
        hLines: Int,
        style: Grid.Style,
        animation: @escaping (Int) -> Animation
    ) {
        self.hRange = hRange
        self.hLines = hLines
        self.style = style
        self.animation = animation
    }
    
    public var body: some View {
        ForEach(hRange, id: \.self) { index in
            __Horrizontal_Grid_Cell(index: index, total: hLines, style: style, animation: animation)
        }
    }
}

fileprivate struct __HGridModifier: ViewModifier {
    
    fileprivate let hLines: Int
    fileprivate let style: Grid.Style
    fileprivate let animation: (_ index: Int) -> Animation
    
    private let hRange: Range<Int>
    
    fileprivate init(
        hLines: Int,
        style: Grid.Style,
        animation: @escaping (_ index: Int) -> Animation
    ) {
        var hRange = 0..<hLines
        var hLines = hLines
        if !style.edges {
            hLines = hLines + 2
            let lower = 1
            let upper = hLines-1
            hRange = lower..<upper
        }
        self.hLines = hLines
        self.style = style
        self.hRange = hRange
        self.animation = animation
    }
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            HGrid(hRange: hRange, hLines: hLines, style: style, animation: animation)
            content
        }
    }
}

// MARK: Cell
fileprivate struct __Horrizontal_Grid_Cell: View {
    
    fileprivate let index: Int
    fileprivate let total: Int
    fileprivate let style: Grid.Style
    fileprivate let animation: (_ index: Int) -> Animation
    
    @State private var startAnimation: Bool = false
    
    fileprivate var body: some View {
        if total == 1 {
            __Horrizontal_Line_Center()
                .__gridAnimation(animation: .draw(direction: .topLeading), style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        } else {
            __Horrizontal_Line(index: index, total: total)
                .__gridAnimation(animation: .draw(direction: .topLeading), style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        }
    }
}

// MARK: Shape
fileprivate struct __Horrizontal_Line: Shape {
    
    fileprivate let index: Int
    fileprivate let total: Int
    fileprivate let direction: Grid.Animation.HorizontalDirection = .leading
    
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
    
    fileprivate let direction: Grid.Animation.HorizontalDirection = .leading
    
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
    public let vRange: Range<Int>
    public let vLines: Int
    public let style: Grid.Style
    public let animation: (_ index: Int) -> Animation
    
    public var body: some View {
        ForEach(vRange, id: \.self) { index in
            __Vertical_Grid_Cell(index: index, total: vLines, style: style, animation: animation)
        }
    }
}

fileprivate struct __VGridModifier: ViewModifier {
    
    fileprivate let vLines: Int
    fileprivate let style: Grid.Style
    fileprivate let animation: (_ index: Int) -> Animation
    
    private let vRange: Range<Int>
    
    fileprivate init(
        vLines: Int,
        style: Grid.Style,
        animation: @escaping (_ index: Int) -> Animation
    ) {
        var vRange = 0..<vLines
        var vLines = vLines
        if !style.edges {
            vLines = vLines + 2
            let lower = 1
            let upper = vLines-1
            vRange = lower..<upper
        }
        self.vLines = vLines
        self.style = style
        self.vRange = vRange
        self.animation = animation
    }
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            VGrid(vRange: vRange, vLines: vLines, style: style, animation: animation)
            content
        }
    }
}

// MARK: Cell
fileprivate struct __Vertical_Grid_Cell: View {
    
    fileprivate let index: Int
    fileprivate let total: Int
    fileprivate let style: Grid.Style
    fileprivate let animation: (_ index: Int) -> Animation
        
    @State private var startAnimation: Bool = false
    
    fileprivate var body: some View {
        if total == 1 {
            __Vertical_Line_Center()
                .__gridAnimation(animation: .draw(direction: .topLeading), style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    self.startAnimation = true
                }
        } else {
            __Vertical_Line(index: index, total: total)
                .__gridAnimation(animation: .draw(direction: .topLeading), style: style, startAnimation: startAnimation)
                .animateOnAppear(using: animation(index)) {
                    print(index)
                    self.startAnimation = true
                }
        }
    }
}

// MARK: Shape
fileprivate struct __Vertical_Line: Shape {
    
    fileprivate let index: Int
    fileprivate let total: Int
    fileprivate let direction: Grid.Animation.VerticalDirection = .bottom
    
    fileprivate func path(in rect: CGRect) -> Path {
        let sectionSize = divide(rect.width, total-1)
        let x = CGFloat(index) * sectionSize
        
        let top = CGPoint(x: x, y: rect.minY)
        let bottom = CGPoint(x: x, y: rect.maxY)

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

fileprivate struct __Vertical_Line_Center: Shape {
    
    fileprivate let direction: Grid.Animation.VerticalDirection = .bottom
    
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
