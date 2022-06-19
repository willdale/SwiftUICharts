import XCTest
import SwiftUI
@testable import SwiftUICharts

final class BarChartTests: XCTestCase {
    // MARK: - Set Up
    let dataPoints = [
        BarChartDataPoint(value: 10),
        BarChartDataPoint(value: 40),
        BarChartDataPoint(value: 30),
        BarChartDataPoint(value: 60)
    ]
    
    // MARK: - Data
    func testBarMaxValue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.maxValue, 60)
    }
    func testBarMinValue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testBarAverage() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.average, 35)
    }
    func testBarRange() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertEqual(chartData.range, 50)
    }
    func testBarIsGreaterThanTwoTrue() {
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    // MARK: - Labels
    func testBarGetYLabels() {
        
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints),
                                     chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))
        chartData.viewData.yAxisSpecifier = "%.2f"
        
        chartData.chartStyle.topLine  = .maximumValue
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00")
        XCTAssertEqual(chartData.labelsArray[1], "30.00")
        XCTAssertEqual(chartData.labelsArray[2], "60.00")
        
        chartData.chartStyle.baseline = .minimumValue
        XCTAssertEqual(chartData.labelsArray[0], "10.00")
        XCTAssertEqual(chartData.labelsArray[1], "35.00")
        XCTAssertEqual(chartData.labelsArray[2], "60.00")
        
        chartData.chartStyle.baseline = .minimumWithMaximum(of: 5)
        XCTAssertEqual(chartData.labelsArray[0], "5.00" )
        XCTAssertEqual(chartData.labelsArray[1], "32.50")
        XCTAssertEqual(chartData.labelsArray[2], "60.00")
        
        chartData.chartStyle.topLine  = .maximum(of: 100)
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.labelsArray[0], "0.00"  )
        XCTAssertEqual(chartData.labelsArray[1], "50.00" )
        XCTAssertEqual(chartData.labelsArray[2], "100.00")
    }
    
    // MARK: - Touch
    func testBarGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        
        let touchLocationOne: CGPoint = CGPoint(x: 5, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOne, chartSize: rect)
        let testOutputOne  = chartData.infoView.touchOverlayInfo
        let testAgainstOne = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputOne[0], testAgainstOne[0])
        
        let touchLocationTwo: CGPoint = CGPoint(x: 25, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwo, chartSize: rect)
        let testOutputTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstTwo = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputTwo[0], testAgainstTwo[1])
        
        let touchLocationThree: CGPoint = CGPoint(x: 50, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThree, chartSize: rect)
        let testOutputThree  = chartData.infoView.touchOverlayInfo
        let testAgainstThree = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputThree[0], testAgainstThree[2])
        
        let touchLocationFour: CGPoint = CGPoint(x: 85, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFour, chartSize: rect)
        let testOutputFour  = chartData.infoView.touchOverlayInfo
        let testAgainstFour = chartData.dataSets.dataPoints
        XCTAssertEqual(testOutputFour[0], testAgainstFour[3])
    }
    
    func testBarGetPointLocation() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = BarChartData(dataSets: BarDataSet(dataPoints: dataPoints))
        
        // Data point 1
        let touchLocationOne: CGPoint = CGPoint(x: 5, y: 25)
        let testOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationOne,
                                                          chartSize: rect)!
        let testAgainstOne = CGPoint(x: 12.5, y: 83.33)
        XCTAssertEqual(testOne.x, testAgainstOne.x, accuracy: 0.01)
        XCTAssertEqual(testOne.y, testAgainstOne.y, accuracy: 0.01)
        
        // Data point 3
        let touchLocationTwo: CGPoint = CGPoint(x: 62.5, y: 25)
        let testTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationTwo,
                                                          chartSize: rect)!
        let testAgainstTwo = CGPoint(x: 62.50, y: 50.00)
        XCTAssertEqual(testTwo.x, testAgainstTwo.x, accuracy: 0.01)
        XCTAssertEqual(testTwo.y, testAgainstTwo.y, accuracy: 0.01)
    }
}
