//
//  MultiPieDataSet.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

/**
 Data set for drawing a multi layered pie chart.
  
 # Example
 ```
 MultiPieDataSet(dataPoints: [
     MultiPieDataPoint(value: 30, colour: .red, layerDataPoints: [
         MultiPieDataPoint(value: 20, colour: .pink),
         MultiPieDataPoint(value: 30,  colour: .orange)
     ]),
     MultiPieDataPoint(value: 50, colour: .blue, layerDataPoints: [
         MultiPieDataPoint(value: 10, colour: .purple),
         MultiPieDataPoint(value: 20, colour: .green)
     ])
 ])
 ```
 */
public struct MultiPieDataSet: SingleDataSet {
    
    public var id: UUID = UUID()
    public var dataPoints  : [MultiPieDataPoint]
    
    /// Initialises a data set a multi layered pie chart.
    /// - Parameter dataPoints: Array of elements.
    public init(dataPoints: [MultiPieDataPoint]) {
        self.dataPoints = dataPoints
    }
    
    public typealias DataPoint = MultiPieDataPoint
}
