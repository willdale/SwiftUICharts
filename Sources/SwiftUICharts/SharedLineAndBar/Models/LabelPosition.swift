//
//  LabelPosition.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import Foundation

public enum HorizontalLabelPosition: Hashable {
    case leading
    case trailing
}

public enum VerticalLabelPosition: Hashable {
    case top
    case bottom
}

extension HorizontalLabelPosition: Identifiable {
    public var id: Self { self }
}
extension VerticalLabelPosition: Identifiable {
    public var id: Self { self }
}
