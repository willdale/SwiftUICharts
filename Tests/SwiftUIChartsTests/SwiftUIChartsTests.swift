import XCTest
@testable import SwiftUICharts

final class SwiftUIChartsTests: XCTestCase {
    
    // MARK: - Single Line Data
    func testMaxValue() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 30),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        XCTAssertEqual(chartData.getMaxValue(), 60)
    }
    func testMinValue() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 30),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        XCTAssertEqual(chartData.getMinValue(), 10)
    }
    func testAverage() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 30),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        XCTAssertEqual(chartData.getAverage(), 35)
    }
    func testRange() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 30),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        XCTAssertEqual(chartData.getRange(), 50.001)
    }

    
    
    // MARK: - Multi Line Data
    func testMultiLineMaxValue() {
        
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertEqual(chartData.getMaxValue(), 100)
    }
    func testMultiLineMinValue() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertEqual(chartData.getMinValue(), 10)
    }
    func testMultiLineAverage() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertEqual(chartData.getAverage(), 53.75)
    }
    func testMultiLineRange() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertEqual(chartData.getRange(), 90.001)
    }
    // MARK: - Labels
    func testLineGetYLabels() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 50),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 80)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints),
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3))

        XCTAssertEqual(chartData.getYLabels()[0], 10.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 33.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 56.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    func testBarGetYLabels() {
        let dataPoints = [
            BarChartDataPoint(value: 10),
            BarChartDataPoint(value: 50),
            BarChartDataPoint(value: 40),
            BarChartDataPoint(value: 80)
        ]
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints, legendTitle: "Test"),
                                      chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))

        XCTAssertEqual(chartData.getYLabels()[0], 0.00000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 26.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 53.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 80.0000, accuracy: 0.01)
        
    }
    
    // MARK: - Chart Data
    func testIsGreaterThanTwoTrue() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 40),
            LineChartDataPoint(value: 30),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testIsGreaterThanTwoFalse() {
        let dataPoints = [
            LineChartDataPoint(value: 10),
            LineChartDataPoint(value: 60)
        ]
        let chartData = LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }
    
    func testMultiIsGreaterThanTwoTrue() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                    LineChartDataPoint(value: 40),
                                                    LineChartDataPoint(value: 30),
                                                    LineChartDataPoint(value: 60)
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50),
                                                    LineChartDataPoint(value: 60),
                                                    LineChartDataPoint(value: 80),
                                                    LineChartDataPoint(value: 100)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testMultiIsGreaterThanTwoFalse() {
        let chartData = MultiLineChartData(dataSets:
                                            MultiLineDataSet(dataSets: [
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 10),
                                                ],
                                                legendTitle: "Bob"),
                                                LineDataSet(dataPoints: [
                                                    LineChartDataPoint(value: 50)
                                                ],
                                                legendTitle: "Bob")
                                            ]))
        
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }
    
    static var allTests = [
        // Single Line Chart Data
        ("testMaxValue", testMaxValue),
        ("testMinValue", testMinValue),
        ("testAverage", testAverage),
        ("testRange", testRange),
        ("testIsGreaterThanTwoTrue", testIsGreaterThanTwoTrue),
        ("testIsGreaterThanTwoFalse", testIsGreaterThanTwoFalse),
        // Multi Line Chart Data
        ("testMultiLineMaxValue", testMultiLineMaxValue),
        ("testMultiLineMinValue", testMultiLineMinValue),
        ("testMultiLineAverage", testMultiLineAverage),
        ("testMultiLineRange", testMultiLineRange),
        
        // Labels
        ("testLineGetYLabels", testLineGetYLabels),
        ("testBarGetYLabels", testBarGetYLabels),
        
        // Chart Data
        ("testMultiIsGreaterThanTwoTrue", testIsGreaterThanTwoTrue),
        ("testMultiIsGreaterThanTwoFalse", testIsGreaterThanTwoFalse),
    ]
}
