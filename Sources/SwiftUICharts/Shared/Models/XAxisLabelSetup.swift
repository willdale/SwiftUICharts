//
//  XAxisLabelSetup.swift
//  
//
//  Created by Will Dale on 15/01/2021.
//

import Foundation

/// Model for the styling of the labels on the X axis.
public struct XAxisLabelSetup {
    
    /// Location of the X axis labels - Top or Bottom
    public var labelPosition: XAxisLabelPosistion
    /// Where the label data come from. DataPoint or xAxisLabels
    public var labelsFrom   : LabelsFrom
    
    /// Model for the styling of the labels on the X axis.
    /// - Parameters:
    ///   - labelPosition: Location of the X axis labels - Top or Bottom
    ///   - labelsFrom: Where the label data come from. DataPoint or xAxisLabels
    public init(labelPosition: XAxisLabelPosistion = .bottom,
                labelsFrom   : LabelsFrom = .xAxisLabel
    ) {
        self.labelPosition  = labelPosition
        self.labelsFrom     = labelsFrom
    }
}

/// Model for the styling of the labels on the Y axis.
public struct YAxisLabelSetup {
    
    /// Location of the X axis labels - Leading or Trailing
    public var labelPosition    : YAxisLabelPosistion
    /// Number Of Labels on Y Axis
    public var numberOfLabels   : Int
    
    /// Model for the styling of the labels on the Y axis.
    /// - Parameters:
    ///   - labelPosition: Location of the Y axis labels - Leading or Trailing
    ///   - numberOfLabels: Number Of Labels on Y Axis
    public init(labelPosition: YAxisLabelPosistion = .leading,
                numberOfLabels   : Int = 10
    ) {
        self.labelPosition  = labelPosition
        self.numberOfLabels = numberOfLabels
    }
}


