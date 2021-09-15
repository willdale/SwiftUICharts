//
//  MarkerData.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import Foundation

struct MarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: MarkerType
    let location: CTPoint
//    let isExtra: Bool
    
    static func == (lhs: MarkerData, rhs: MarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}
