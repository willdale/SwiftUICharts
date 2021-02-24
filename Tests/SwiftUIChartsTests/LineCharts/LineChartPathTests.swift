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
    
    let rect         : CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
    let touchLocation: CGPoint = CGPoint(x: 25, y: 25)
    
    func testGetIndicatorLocation() {
        
        let test = chartData.getIndicatorLocation(rect: rect,
                                                  dataPoints: chartData.dataSets.dataPoints,
                                                  touchLocation: touchLocation,
                                                  lineType: .line)
                
        XCTAssertEqual(test.x, 25, accuracy: 0.1)
        XCTAssertEqual(test.y, 75, accuracy: 0.1)
    }
    
    
    func testGetPercentageOfPath() {
        
        let path = Path.straightLine(rect       : rect,
                                     dataPoints : chartData.dataSets.dataPoints,
                                     minValue   : chartData.minValue,
                                     range      : chartData.range,
                                     isFilled   : false)
        
        let test = chartData.getPercentageOfPath(path: path, touchLocation: touchLocation)
        
        XCTAssertEqual(test, 0.25, accuracy: 0.1)
    }
    
    func testGetTotalLength() {
        
        let path = Path.straightLine(rect       : rect,
                                     dataPoints : chartData.dataSets.dataPoints,
                                     minValue   : chartData.minValue,
                                     range      : chartData.range,
                                     isFilled   : false)
                
        let test = chartData.getTotalLength(of: path)
        
        XCTAssertEqual(test, 141.42, accuracy: 0.01)
    }
    
    func testGetLengthToTouch() {
        
        let path = Path.straightLine(rect       : rect,
                                     dataPoints : chartData.dataSets.dataPoints,
                                     minValue   : chartData.minValue,
                                     range      : chartData.range,
                                     isFilled   : false)
                        
        let test = chartData.getLength(to: touchLocation, on: path)
        
        XCTAssertEqual(test, 35.35, accuracy: 0.01)
    }
    
    func testRelativePoint() {
        
        let pointOne = CGPoint(x: 0.0, y: 0.0)
        let pointTwo = CGPoint(x: 100, y: 100)
        
        let test = chartData.relativePoint(from: pointOne, to: pointTwo, touchX: touchLocation.x)
        
        XCTAssertEqual(test.x, 25, accuracy: 0.01)
        XCTAssertEqual(test.y, 25, accuracy: 0.01)
    }
    
    
    static var allTests = [
        ("testGetIndicatorLocation", testGetIndicatorLocation),
        ("testGetPercentageOfPath", testGetPercentageOfPath),
        ("testGetTotalLength", testGetTotalLength),
        ("testGetLengthToTouch", testGetLengthToTouch),
        ("testRelativePoint", testRelativePoint),
    ]
}
