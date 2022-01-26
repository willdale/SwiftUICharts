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
        vLines: UInt = 5,
        hLines: UInt = 5,
        style: Grid.Style = .grey
    ) -> some View {
        self.modifier(GridModifier(vLines: vLines, hLines: hLines, style: style))
    }
}

// MARK: - HGrid
public struct HGrid: Shape {
    
    public var lines: UInt
    public var edges: Bool
    
    public init(
        lines: UInt,
        edges: Bool = true
    ) {
        self.lines = edges ? lines : lines + 2
        self.edges = edges
    }
    
    public func path(in rect: CGRect) -> Path {
        if lines == 0 { return Path() }
        else if lines == 1 {
            return middleLine(in: rect)
        } else if lines == 2 {
            return edgeLines(in: rect)
        } else {
            return allLines(in: rect)
        }
    }
    
    private func middleLine(in rect: CGRect) -> Path {
        var path = Path()
        let pointOne = CGPoint(x: rect.minX, y: rect.midY)
        let pointTwo = CGPoint(x: rect.maxX, y: rect.midY)
        path.move(to: pointOne)
        path.addLine(to: pointTwo)
        return path
    }
    
    private func edgeLines(in rect: CGRect) -> Path {
        var path = Path()
        let bottomPointOne = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
        let topPointOne = CGPoint(x: rect.minX, y: rect.minY)
        let topPointTwo = CGPoint(x: rect.maxX, y: rect.minY)

        path.move(to: bottomPointOne)
        path.addLine(to: bottomPointTwo)
        path.move(to: topPointOne)
        path.addLine(to: topPointTwo)
        return path
    }
    
    private func allLines(in rect: CGRect) -> Path {
        var path = Path()
        let range = edges ? 0..<lines : 1..<lines-1
        let sectionSize = divide(rect.height, lines-1)
        for index in range {
            let y = CGFloat(index) * sectionSize
            let pointOne = CGPoint(x: rect.minX, y: y)
            let pointTwo = CGPoint(x: rect.maxX, y: y)
            path.move(to: pointOne)
            path.addLine(to: pointTwo)
        }
        return path
    }
}

// MARK: - VGrid
public struct VGrid: Shape {
    
    public var lines: UInt
    public var edges: Bool
    
    public init(
        lines: UInt,
        edges: Bool = true
    ) {
        self.lines = edges ? lines : lines + 2
        self.edges = edges
    }
    
    public func path(in rect: CGRect) -> Path {
        if lines == 0 { return Path() }
        else if lines == 1 {
            return middleLine(in: rect)
        } else if lines == 2 {
            return edgeLines(in: rect)
        } else {
            return allLines(in: rect)
        }
    }
    
    private func middleLine(in rect: CGRect) -> Path {
        var path = Path()
        let pointOne = CGPoint(x: rect.midX, y: rect.minY)
        let pointTwo = CGPoint(x: rect.midX, y: rect.maxY)
        path.move(to: pointOne)
        path.addLine(to: pointTwo)
        return path
    }
    
    private func edgeLines(in rect: CGRect) -> Path {
        var path = Path()
        let bottomPointOne = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
        let topPointOne = CGPoint(x: rect.minX, y: rect.minY)
        let topPointTwo = CGPoint(x: rect.minX, y: rect.maxY)
        
        path.move(to: bottomPointOne)
        path.addLine(to: bottomPointTwo)
        path.move(to: topPointOne)
        path.addLine(to: topPointTwo)
        return path
    }
    
    private func allLines(in rect: CGRect) -> Path {
        var path = Path()
        let range = edges ? 0..<lines : 1..<lines-1
        let sectionSize = divide(rect.width, lines-1)
        for index in range {
            let y = CGFloat(index) * sectionSize
            let pointOne = CGPoint(x: y, y: rect.minY)
            let pointTwo = CGPoint(x: y, y: rect.maxY)
            path.move(to: pointOne)
            path.addLine(to: pointTwo)
        }
        return path
    }
}

// MARK: Grid
public struct Grid: Shape {
    
    public var vLines: UInt
    public var hLines: UInt
    public var edges: Bool
    
    public init(
        vLines: UInt,
        hLines: UInt,
        edges: Bool = true
    ) {
        self.vLines = vLines
        self.hLines = hLines
        self.edges = edges
    }
    
    public func path(in rect: CGRect) -> Path {
        let vGrid = VGrid(lines: vLines, edges: edges)
            .path(in: rect)
        let hGrid = HGrid(lines: hLines, edges: edges)
            .path(in: rect)
        
        var path = Path()
        path.addPath(vGrid)
        path.addPath(hGrid)
        return path
    }
    
    public struct Style {
        var colour: ChartColour
        var stroke: StrokeStyle
        var edges: Bool
    }
}

extension Grid.Style {
    public static let grey = Self(colour: .colour(colour: .gray), stroke: StrokeStyle(), edges: true)
    public static let greyNoEdges = Self(colour: .colour(colour: .gray), stroke: StrokeStyle(), edges: false)
    
    public static let lightGrey = Self(colour: .colour(colour: Color(.lightGray)), stroke: StrokeStyle(), edges: true)
    public static let lightGreyNoEdges = Self(colour: .colour(colour: Color(.lightGray)), stroke: StrokeStyle(), edges: false)
}

// MARK: - HGrid Modifier
internal struct HGridModifier: ViewModifier {
        
    internal let lines: UInt
    internal let style: Grid.Style
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            HGrid(lines: lines, edges: style.edges)
                .stroke(style.colour, strokeStyle: style.stroke)
        }
    }
}

extension View {
    public func hGrid(
        lines: UInt = 5,
        style: Grid.Style = .grey
    ) -> some View {
        self.modifier(HGridModifier(lines: lines, style: style))
    }
}

// MARK: - VGrid Modifier
internal struct VGridModifier: ViewModifier {
        
    internal let lines: UInt
    internal let style: Grid.Style
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            VGrid(lines: lines, edges: style.edges)
                .stroke(style.colour, strokeStyle: style.stroke)
        }
    }
}

extension View {
    public func vGrid(
        lines: UInt = 5,
        style: Grid.Style = .grey
    ) -> some View {
        self.modifier(VGridModifier(lines: lines, style: style))
    }
}

// MARK: - Grid Modifier
internal struct GridModifier: ViewModifier {
        
    internal let vLines: UInt
    internal let hLines: UInt
    internal let style: Grid.Style
    
    internal func body(content: Content) -> some View {
        ZStack {
            Grid(vLines: vLines, hLines: hLines, edges: style.edges)
                .stroke(style.colour, strokeStyle: style.stroke)
            content
        }
    }
}
