//
//  Ignorable.swift
//
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/// Conforming types can have individual values ignored when rendering
public protocol Ignorable {
    
    /// Whether to ignore this data point while rendering
    var ignore: Bool { get set }
}
