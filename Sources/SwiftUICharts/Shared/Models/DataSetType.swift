//
//  DataSetType.swift
//  
//
//  Created by Will Dale on 01/01/2022.
//

import Foundation

/**
 The type of `DataSet` being used
 ```
 case single // Single data set - i.e LineDataSet
 case multi // Multi data set - i.e MultiLineDataSet
 ```
 */
public enum DataSetType {
    case single
    case multi
}
