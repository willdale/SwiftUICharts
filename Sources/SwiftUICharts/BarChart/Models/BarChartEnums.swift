//
//  BarChartEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import Foundation

/**
 Where to get the colour data from.
 ```
 case barStyle // From BarStyle data model
 case dataPoints // From each data point
 ```
 
 - Tag: ColourFrom
 */
public enum ColourFrom {
    case barStyle
    case dataPoints
}
