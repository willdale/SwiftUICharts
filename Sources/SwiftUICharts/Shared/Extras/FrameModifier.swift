//
//  FrameModifier.swift
//  
//
//  Created by Will Dale on 11/09/2021.
//

import SwiftUI

internal struct FrameModifier: ViewModifier {
    
    internal let rect: CGSize
    
    internal func body(content: Content) -> some View {
        return content
            .frame(width: rect.width, height: rect.height)
    }
}

extension View {
    internal func frame(_ rect: CGSize) -> some View {
        self.modifier(FrameModifier(rect: rect))
    }
}
