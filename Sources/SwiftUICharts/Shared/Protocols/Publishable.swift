//
//  PublishableProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Combine
import SwiftUI


/// Protocol to enable publishing data streams over the Combine framework
public protocol Publishable {
    associatedtype DataPoint: CTDataPointBaseProtocol
    var touchedData: TouchedData<DataPoint> { get set }
}
