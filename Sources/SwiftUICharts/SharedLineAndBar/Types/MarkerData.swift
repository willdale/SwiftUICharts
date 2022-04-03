//
//  MarkerData.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import Foundation
import CoreGraphics.CGGeometry

public struct MarkerData {
    public let id: UUID = UUID()
    internal let lineMarkerData: [LineMarkerData]
    internal let barMarkerData: [BarMarkerData]
    internal let pieMarkerData: [PieMarkerData]
    
    public init(
        lineMarkerData: [LineMarkerData] = [],
        barMarkerData: [BarMarkerData] = [],
        pieMarkerData: [PieMarkerData] = []
    ) {
        self.lineMarkerData = lineMarkerData
        self.barMarkerData = barMarkerData
        self.pieMarkerData = pieMarkerData
    }
    
    public init() {
        self.lineMarkerData = []
        self.barMarkerData = []
        self.pieMarkerData = []
    }
}

public struct LineMarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: LineMarkerType
    let location: CGPoint
    
    let dataPoints: [LineChartDataPoint]
    let lineType: LineType
    let lineSpacing: SpacingType
    let minValue: Double
    let range: Double
    
    public static func == (lhs: LineMarkerData, rhs: LineMarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}

public struct BarMarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: BarMarkerType
    let location: CGPoint
    
    public static func == (lhs: BarMarkerData, rhs: BarMarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}

extension LineChartDataPoint {
    init(_ datapoint: RangedLineChartDataPoint) {
        self.init(value: datapoint.value,
                  description: datapoint.description,
                  ignore: datapoint.ignore)
    }
}

public struct PieMarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: PieMarkerType
    let location: CGPoint
    
    public static func == (lhs: PieMarkerData, rhs: PieMarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}
