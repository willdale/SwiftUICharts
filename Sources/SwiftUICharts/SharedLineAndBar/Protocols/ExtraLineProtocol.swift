//
//  ExtraLineProtocol.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import SwiftUI

public protocol ExtraLineProtocol {
    /**
     A data model for the `ExtraLine` View Modifier
    */
    var extraLineData: ExtraLineData! { get set }
    
    /**
     A type representing a View for displaying second set of labels on the Y axis.
    */
//    associatedtype ExtraYLabels: View
    
    /**
     View for displaying second set of labels on the Y axis.
    */
//    func getExtraYAxisLabels() -> ExtraYLabels
    
//    associatedtype ExtraYTitle: View
    
//    func getExtraYAxisTitle(colour: AxisColour) -> ExtraYTitle
}
