import XCTest
@testable import SwiftUICharts

final class MultiLineChartTest: XCTestCase {
    
    // MARK: - Data
    func testMultiLineMaxValue() {
        
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ])
                                            ]))
        
        XCTAssertEqual(chartData.maxValue, 100)
    }
    func testMultiLineMinValue() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ])
                                            ]))
        
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testMultiLineAverage() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ])
                                            ]))
        
        XCTAssertEqual(chartData.average, 53.75)
    }
    func testMultiLineRange() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ])
                                            ]))
        
        XCTAssertEqual(chartData.range, 90.001)
    }
    // MARK: Greater
    func testMultiIsGreaterThanTwoTrue() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ])
                                            ]))
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testMultiIsGreaterThanTwoFalse() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                ]),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50)
                                                ])
                                            ]))
        
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }
    
    
    
    static var allTests = [
        // Data
        ("testMultiLineMaxValue", testMultiLineMaxValue),
        ("testMultiLineMinValue", testMultiLineMinValue),
        ("testMultiLineAverage", testMultiLineAverage),
        ("testMultiLineRange", testMultiLineRange),
        // Greater
        ("testMultiLineIsGreaterThanTwoTrue", testMultiIsGreaterThanTwoTrue),
        ("testMultiLineIsGreaterThanTwoFalse", testMultiIsGreaterThanTwoFalse),
    ]
}
