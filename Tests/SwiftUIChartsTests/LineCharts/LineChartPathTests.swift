import XCTest
import SwiftUI
@testable import SwiftUICharts

final class LineChartPathTests: XCTestCase {
    
    let chartData = LineChartData(dataSets: LineDataSet(dataPoints: [
        LineChartDataPoint(value: 0),
        LineChartDataPoint(value: 25),
        LineChartDataPoint(value: 50),
        LineChartDataPoint(value: 75),
        LineChartDataPoint(value: 100)
    ]))
    
    let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
    let touchLocation: CGPoint = CGPoint(x: 25, y: 25)
    
    func testGetIndicatorLocation() {
        
        let test = LineChartData.getIndicatorLocation(rect: rect,
                                                      dataPoints: chartData.dataSets.dataPoints,
                                                      touchLocation: touchLocation,
                                                      lineType: .line,
                                                      minValue: chartData.minValue,
                                                      range: chartData.range,
                                                      ignoreZero: false)
        
        XCTAssertEqual(test.x, 25, accuracy: 0.1)
        XCTAssertEqual(test.y, 75, accuracy: 0.1)
    }
    
    
    func testGetPercentageOfPath() {
        
        let path = Path.straightLine(rect: rect,
                                     dataPoints: chartData.dataSets.dataPoints,
                                     minValue: chartData.minValue,
                                     range: chartData.range,
                                     isFilled: false)
        
        let test = LineChartData.getPercentageOfPath(path: path, touchLocation: touchLocation)
        
        XCTAssertEqual(test, 0.25, accuracy: 0.1)
    }
    
    func testGetTotalLength() {
        
        let path = Path.straightLine(rect: rect,
                                     dataPoints: chartData.dataSets.dataPoints,
                                     minValue: chartData.minValue,
                                     range: chartData.range,
                                     isFilled: false)
        
        let test = LineChartData.getTotalLength(of: path)
        
        XCTAssertEqual(test, 141.42, accuracy: 0.01)
    }
    
    func testGetLengthToTouch() {
        
        let path = Path.straightLine(rect: rect,
                                     dataPoints: chartData.dataSets.dataPoints,
                                     minValue: chartData.minValue,
                                     range: chartData.range,
                                     isFilled: false)
        
        let test = LineChartData.getLength(to: touchLocation, on: path)
        
        XCTAssertEqual(test, 35.35, accuracy: 0.01)
    }
    
    func testRelativePoint() {
        
        let pointOne = CGPoint(x: 0.0, y: 0.0)
        let pointTwo = CGPoint(x: 100, y: 100)
        
        let test = LineChartData.relativePoint(from: pointOne, to: pointTwo, touchX: touchLocation.x)
        
        XCTAssertEqual(test.x, 25, accuracy: 0.01)
        XCTAssertEqual(test.y, 25, accuracy: 0.01)
    }
    
    func testDistanceToTouch() {
        
        let pointOne = CGPoint(x: 0.0, y: 0.0)
        let pointTwo = CGPoint(x: 100, y: 100)
        
        let test = LineChartData.distanceToTouch(from: pointOne, to: pointTwo, touchX: touchLocation.x)
        
        XCTAssertEqual(test, 35.355, accuracy: 0.01)
    }
    
    func testDistance() {
        
        let pointOne = CGPoint(x: 0.0, y: 0.0)
        let pointTwo = CGPoint(x: 100, y: 100)
        
        let test = LineChartData.distance(from: pointOne, to: pointTwo)
        
        XCTAssertEqual(test, 141.421356237309, accuracy: 0.01)
    }
    
    func testGetLocationOnPath() {
        
        let path = Path.straightLine(rect: rect,
                                     dataPoints: chartData.dataSets.dataPoints,
                                     minValue: chartData.minValue,
                                     range: chartData.range,
                                     isFilled: false)
        
        let test = LineChartData.locationOnPath(0.5, path)
        
        XCTAssertEqual(test.x, 50, accuracy: 0.1)
        XCTAssertEqual(test.y, 50, accuracy: 0.1)
    }
}
