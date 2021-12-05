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
public struct ExtraLineDataPoint: Hashable, Identifiable, Ignorable {
    
    public let id: UUID = UUID()
    public var value: Double
    public var pointColour: PointColour?
    public var description: String?
    public var ignore: Bool

    public init(
        value: Double,
        pointColour: PointColour? = nil,
        description: String? = nil,
        ignore: Bool = false
    ) {
        self.value = value
        self.pointColour = pointColour
        self.description = description
        self.ignore = ignore
    }
}

