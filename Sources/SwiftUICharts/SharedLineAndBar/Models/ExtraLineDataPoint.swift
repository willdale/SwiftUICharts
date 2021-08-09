//
//  ExtraLineDataPoint.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

/**
 Data point for Extra line View Modifier.
 */
public struct ExtraLineDataPoint: Hashable, Identifiable {
    
    public let id: UUID = UUID()
    public var value: Double
    public var pointColour: PointColour?

    public init(
        value: Double,
        pointColour: PointColour? = nil
    ) {
        self.value = value
        self.pointColour = pointColour
    }
}

