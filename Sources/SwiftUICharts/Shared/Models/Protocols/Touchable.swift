//
//  File.swift
//  
//
//  Created by Will Dale on 01/08/2021.
//

import SwiftUI

// MARK: - Touch
public protocol Touchable {
    
    /// A type representing a view for the results of the touch interaction.
    associatedtype Touch: View
    
    /**
     Takes in the required data to set up all the touch interactions.
     
     Output via `getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     */
    func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)
    
    /**
     Takes touch location and return a view based on the chart type and configuration.
     
     Inputs from `setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     - Returns: The relevent view for the chart type and options.
     */
    func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch
    
    
    /// Informs the data model that touch
    /// input has finished.
    func touchDidFinish()
}
