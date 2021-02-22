//
//  MultiPieDataSet.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

public struct MultiPieDataSet: SingleDataSet {
    
    public var id: UUID = UUID()
    public var dataPoints  : [MultiPieDataPoint]
    
    public init(dataPoints: [MultiPieDataPoint]) {
        self.dataPoints = dataPoints
    }
    
    public typealias DataPoint = MultiPieDataPoint
}
