import XCTest
@testable import SwiftUICharts

final class MultiLineChartTest: XCTestCase {
    
    let dataSet = MultiLineDataSet(dataSets: [
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
    ])
    
    // MARK: - Data
    func testMultiLineMaxValue() {
        let chartData = MultiLineChartData(dataSets: dataSet)
        
        XCTAssertEqual(chartData.maxValue, 100)
    }
    func testMultiLineMinValue() {
        let chartData = MultiLineChartData(dataSets: dataSet)
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testMultiLineAverage() {
        let chartData = MultiLineChartData(dataSets: dataSet)
        XCTAssertEqual(chartData.average, 53.75)
    }
    func testMultiLineRange() {
        let chartData = MultiLineChartData(dataSets: dataSet)
        XCTAssertEqual(chartData.range, 90.001)
    }
    // MARK: Greater
    func testMultiIsGreaterThanTwoTrue() {
        let chartData = MultiLineChartData(dataSets: dataSet)
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
    
    // MARK: - Labels
    func testMultiLineGetYLabelsMinimumValue() {
        let chartData = MultiLineChartData(dataSets: dataSet,
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .minimumValue))

        XCTAssertEqual(chartData.getYLabels()[0], 10.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 40.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 70.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 100.0000, accuracy: 0.01)
        
    }
    
    func testMultiLineGetYLabelsMinimumWithMax() {
        let chartData = MultiLineChartData(dataSets: dataSet,
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .minimumWithMaximum(of: 5)))

        XCTAssertEqual(chartData.getYLabels()[0], 5.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 36.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 68.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 100.0000, accuracy: 0.01)
        
    }
    
    func testMultiLineGetYLabelsZero() {
        let chartData = MultiLineChartData(dataSets: dataSet,
                                      chartStyle: LineChartStyle(yAxisNumberOfLabels: 3,
                                                                 baseline: .zero))

        XCTAssertEqual(chartData.getYLabels()[0], 0.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 33.3333, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 66.6666, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 100.0000, accuracy: 0.01)
        
    }
    // MARK: - Touch
    func testMultiLineGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = MultiLineChartData(dataSets: dataSet)
        
        let touchLocationOne: CGPoint = CGPoint(x: 5, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOne, chartSize: rect)
        let testOutputOne  = chartData.infoView.touchOverlayInfo
        let testAgainstOneOne = chartData.dataSets.dataSets[0].dataPoints
        let testAgainstOneTwo = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputOne[0], testAgainstOneOne[0])
        XCTAssertEqual(testOutputOne[1], testAgainstOneTwo[0])
        
        let touchLocationTwo: CGPoint = CGPoint(x: 25, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwo, chartSize: rect)
        let testOutputTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstTwoOne = chartData.dataSets.dataSets[0].dataPoints
        let testAgainstTwoTwo = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputTwo[0], testAgainstTwoOne[1])
        XCTAssertEqual(testOutputTwo[1], testAgainstTwoTwo[1])
        
        let touchLocationThree: CGPoint = CGPoint(x: 50, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThree, chartSize: rect)
        let testOutputThree  = chartData.infoView.touchOverlayInfo
        let testAgainstThreeOne = chartData.dataSets.dataSets[0].dataPoints
        let testAgainstThreeTwo = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputThree[0], testAgainstThreeOne[2])
        XCTAssertEqual(testOutputThree[1], testAgainstThreeTwo[2])
        
        let touchLocationFour: CGPoint = CGPoint(x: 85, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFour, chartSize: rect)
        let testOutputFour  = chartData.infoView.touchOverlayInfo
        let testAgainstFourOne = chartData.dataSets.dataSets[0].dataPoints
        let testAgainstFourTwo = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputFour[0], testAgainstFourOne[3])
        XCTAssertEqual(testOutputFour[1], testAgainstFourTwo[3])
    }
    
    static var allTests = [
        // Data
        ("testMultiLineMaxValue", testMultiLineMaxValue),
        ("testMultiLineMinValue", testMultiLineMinValue),
        ("testMultiLineAverage" , testMultiLineAverage),
        ("testMultiLineRange"   , testMultiLineRange),
        // Greater
        ("testMultiLineIsGreaterThanTwoTrue" , testMultiIsGreaterThanTwoTrue),
        ("testMultiLineIsGreaterThanTwoFalse", testMultiIsGreaterThanTwoFalse),
        // Labels
        ("testMultiLineGetYLabelsMinimumValue"  , testMultiLineGetYLabelsMinimumValue),
        ("testMultiLineGetYLabelsMinimumWithMax", testMultiLineGetYLabelsMinimumWithMax),
        ("testMultiLineGetYLabelsZero"          , testMultiLineGetYLabelsZero),
        // Touch
        ("testMultiLineGetDataPoint", testMultiLineGetDataPoint),
    ]
}
