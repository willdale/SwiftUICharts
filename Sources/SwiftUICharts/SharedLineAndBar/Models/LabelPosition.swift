//
//  LabelPosition.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import Foundation

public enum HorizontalEdge: Hashable {
    case leading
    case trailing
}

public enum VerticalEdge: Hashable {
    case top
    case bottom
}

extension HorizontalEdge: Identifiable {
    public var id: Self { self }
}
extension VerticalEdge: Identifiable {
    public var id: Self { self }
}
