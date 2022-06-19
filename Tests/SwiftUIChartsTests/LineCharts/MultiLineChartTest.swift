import XCTest
import SwiftUI
@testable import SwiftUICharts

final class MultiLineChartTest: XCTestCase {
    
    // MARK: - Set Up
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
        XCTAssertEqual(chartData.range, 90)
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
    func testMultiLineGetYLabels() {
        let chartData = MultiLineChartData(dataSets: dataSet,
                                           chartStyle: LineChartStyle(yAxisNumberOfLabels: 3))
        chartData.viewData.yAxisSpecifier = "%.2f"
        
        chartData.chartStyle.topLine  = .maximumValue
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "50.00")
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
        
        chartData.chartStyle.baseline = .minimumValue
        XCTAssertEqual(chartData.labelsArray[0], "10.00")
        XCTAssertEqual(chartData.labelsArray[1], "55.00")
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
        
        chartData.chartStyle.baseline = .minimumWithMaximum(of: 5)
        XCTAssertEqual(chartData.labelsArray[0], "5.00")
        XCTAssertEqual(chartData.labelsArray[1], "52.50")
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
        
        chartData.chartStyle.topLine  = .maximum(of: 100)
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "50.00")
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
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
    
    func testMultiLineGetPointLocation() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = MultiLineChartData(dataSets: dataSet)
        
        // Data set 1 - point 1
        let touchLocationOneOne: CGPoint = CGPoint(x: 5, y: 25)
        let testOneOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets.dataSets[0],
                                                             touchLocation: touchLocationOneOne,
                                                             chartSize: rect)!
        let testAgainstOneOne = CGPoint(x: 0, y: 100)
        XCTAssertEqual(testOneOne.x, testAgainstOneOne.x)
        XCTAssertEqual(testOneOne.y, testAgainstOneOne.y)
        
        // Data set 1 - point 3
        let touchLocationOneThree: CGPoint = CGPoint(x: 66, y: 25)
        let testOneThree: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets.dataSets[0],
                                                               touchLocation: touchLocationOneThree,
                                                               chartSize: rect)!
        let testAgainstOneThree = CGPoint(x: 66.66, y: 77.77)
        XCTAssertEqual(testOneThree.x, testAgainstOneThree.x, accuracy: 0.01)
        XCTAssertEqual(testOneThree.y, testAgainstOneThree.y, accuracy: 0.01)
        
        
        
        
        // Data set 2 - point 2
        let touchLocationTwoTwo: CGPoint = CGPoint(x: 66, y: 25)
        let testTwoTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets.dataSets[0],
                                                             touchLocation: touchLocationTwoTwo,
                                                             chartSize: rect)!
        let testAgainstTwoTwo = CGPoint(x: 66.66, y: 77.77)
        XCTAssertEqual(testTwoTwo.x, testAgainstTwoTwo.x, accuracy: 0.01)
        XCTAssertEqual(testTwoTwo.y, testAgainstTwoTwo.y, accuracy: 0.01)
        
        // Data set 2 - point 4
        let touchLocationTwoFour: CGPoint = CGPoint(x: 5, y: 25)
        let testTwoFour: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets.dataSets[0],
                                                              touchLocation: touchLocationTwoFour,
                                                              chartSize: rect)!
        let testAgainstTwoFour = CGPoint(x: 0, y: 100)
        XCTAssertEqual(testTwoFour.x, testAgainstTwoFour.x)
        XCTAssertEqual(testTwoFour.y, testAgainstTwoFour.y)
    }
}
