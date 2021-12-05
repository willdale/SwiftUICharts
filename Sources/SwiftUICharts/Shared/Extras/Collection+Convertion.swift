//
//  Collection+Convertion.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI

extension Collection where Element == GradientStop {
    internal var convert: [Gradient.Stop] {
        self.map { Gradient.Stop($0) }
    }
}
