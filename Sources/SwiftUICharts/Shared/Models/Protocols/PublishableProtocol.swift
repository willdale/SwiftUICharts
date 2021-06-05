//
//  PublishableProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Foundation
import Combine

/**
 Protocol to enable publishing data streams over the Combine framework
 */
public protocol Publishable {
    
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    
    var subscription: Set<AnyCancellable> { get set }
    
    /**
     Streams the data points from touch overlay.
     
     Uses Combine
     */
    var touchedDataPointPublisher: PassthroughSubject<DataPoint, Never> { get }
}
