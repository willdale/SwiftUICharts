import XCTest
@testable import SwiftUICharts

final class GroupedBarChartTests: XCTestCase {
    
    // MARK: - Set Up
    enum Group {
        case one
        case two
        case three
        case four
        
        var data : GroupingData {
            switch self {
            case .one:
                return GroupingData(title: "One"  , colour: ColourStyle(colour: .blue))
            case .two:
                return GroupingData(title: "Two"  , colour: ColourStyle(colour: .red))
            case .three:
                return GroupingData(title: "Three", colour: ColourStyle(colour: .yellow))
            case .four:
                return GroupingData(title: "Four" , colour: ColourStyle(colour: .green))
            }
        }
    }
    
    let groups : [GroupingData] = [Group.one.data, Group.two.data, Group.three.data, Group.four.data]
    
    let data = MultiBarDataSets(dataSets: [
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", description: "One One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "1.2", description: "One Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "1.3", description: "One Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "1.4", description: "One Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", description: "Two One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.2", description: "Two Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "2.3", description: "Two Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.3", description: "Two Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", description: "Three One"  , group: Group.one.data),
            MultiBarChartDataPoint(value: 70, xAxisLabel: "3.2", description: "Three Two"  , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.3", description: "Three Three", group: Group.three.data),
            MultiBarChartDataPoint(value: 90, xAxisLabel: "3.4", description: "Three Four" , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", description: "Four One"   , group: Group.one.data),
            MultiBarChartDataPoint(value: 80, xAxisLabel: "4.2", description: "Four Two"   , group: Group.two.data),
            MultiBarChartDataPoint(value: 20, xAxisLabel: "4.3", description: "Four Three" , group: Group.three.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "4.3", description: "Four Four"  , group: Group.four.data)
        ])
    ])
        
    // MARK: - Data
    func testGroupedBarMaxValue() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.maxValue, 90)
    }
    func testGroupedBarMinValue() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.minValue, 10)
    }
    func testGroupedBarAverage() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.average, 45)
    }
    func testGroupedBarRange() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertEqual(chartData.range, 80.001)
    }
    
    // MARK: Greater
    func testGroupedBarIsGreaterThanTwoTrue() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        
        XCTAssertTrue(chartData.isGreaterThanTwo())
    }
    
    func testGroupedBarIsGreaterThanTwoFalse() {
       let data = MultiBarDataSets(dataSets: [
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", description: "One One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", description: "Two One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", description: "Three One", group: Group.one.data)

            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", description: "Four One" , group: Group.one.data)
            ])
        ])
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }

    // MARK: - Labels
    func testGroupedBarGetYLabels() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups,
                                                            chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))

        chartData.chartStyle.topLine  = .maximumValue
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.getYLabels()[0], 0.000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 45.00, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 90.00, accuracy: 0.01)
        
        chartData.chartStyle.baseline = .minimumValue
        XCTAssertEqual(chartData.getYLabels()[0], 10.00, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 50.00, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 90.00, accuracy: 0.01)
        
        chartData.chartStyle.baseline = .minimumWithMaximum(of: 5)
        XCTAssertEqual(chartData.getYLabels()[0], 5.00,   accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 47.50,  accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 90.00,  accuracy: 0.01)
        
        chartData.chartStyle.topLine  = .maximum(of: 100)
        chartData.chartStyle.baseline = .zero
        XCTAssertEqual(chartData.getYLabels()[0], 0.00,   accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 50.00,  accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 100.00, accuracy: 0.01)
    }
    // MARK: - Touch
    func testGroupedBarGetDataPoint() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        chartData.groupSpacing = 10
        
        // Group 1
        let touchLocationOne: CGPoint = CGPoint(x: 0, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationOne, chartSize: rect)
        let testOutputOne  = chartData.infoView.touchOverlayInfo
        let testAgainstOne = chartData.dataSets.dataSets[0].dataPoints
        XCTAssertEqual(testOutputOne[0], testAgainstOne[0])
        
        // Group 2
        let touchLocationTwo: CGPoint = CGPoint(x: 30, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationTwo, chartSize: rect)
        let testOutputTwo  = chartData.infoView.touchOverlayInfo
        let testAgainstTwo = chartData.dataSets.dataSets[1].dataPoints
        XCTAssertEqual(testOutputTwo[0], testAgainstTwo[0])
        
        // None
        let touchLocationThree: CGPoint = CGPoint(x: 50, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationThree, chartSize: rect)
        let testOutputThree  = chartData.infoView.touchOverlayInfo
        XCTAssertEqual(testOutputThree, [])
        
        // Group 3
        let touchLocationFour: CGPoint = CGPoint(x: 55, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFour, chartSize: rect)
        let testOutputFour  = chartData.infoView.touchOverlayInfo
        let testAgainstFour = chartData.dataSets.dataSets[2].dataPoints
        XCTAssertEqual(testOutputFour[0], testAgainstFour[0])
        
        // Group 4
        let touchLocationFive: CGPoint = CGPoint(x: 83, y: 25)
        chartData.infoView.touchOverlayInfo = []
        chartData.getDataPoint(touchLocation: touchLocationFive, chartSize: rect)
        let testOutputFive  = chartData.infoView.touchOverlayInfo
        let testAgainstFive = chartData.dataSets.dataSets[3].dataPoints
        XCTAssertEqual(testOutputFive[0], testAgainstFive[0])
    }
    
    func testGroupedBarGetPointLocation() {
        let rect: CGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        chartData.groupSpacing = 10
        
        // Group 1
        let touchLocationOne: CGPoint = CGPoint(x: 0, y: 25)

        let testOne: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationOne,
                                                          chartSize: rect)!
        let testAgainstOne = CGPoint(x: 2.18, y: 88.88)
        XCTAssertEqual(testOne.x, testAgainstOne.x, accuracy: 0.01)
        XCTAssertEqual(testOne.y, testAgainstOne.y, accuracy: 0.01)
        
        // Group 2
        let touchLocationTwo: CGPoint = CGPoint(x: 30, y: 25)
       
        let testTwo: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationTwo,
                                                          chartSize: rect)!
        let testAgainstTwo = CGPoint(x: 29.68, y: 77.77)
        XCTAssertEqual(testTwo.x, testAgainstTwo.x, accuracy: 0.01)
        XCTAssertEqual(testTwo.y, testAgainstTwo.y, accuracy: 0.01)

        // Group 3
        let touchLocationThree: CGPoint = CGPoint(x: 55, y: 25)
        
        let testThree: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationThree,
                                                          chartSize: rect)!
        let testAgainstThree = CGPoint(x: 57.18, y: 66.66)
        XCTAssertEqual(testThree.x, testAgainstThree.x, accuracy: 0.01)
        XCTAssertEqual(testThree.y, testAgainstThree.y, accuracy: 0.01)

        // Group 4
        let touchLocationFour: CGPoint =  CGPoint(x: 83, y: 25)
        
        let testFour: CGPoint = chartData.getPointLocation(dataSet: chartData.dataSets,
                                                          touchLocation: touchLocationFour,
                                                          chartSize: rect)!
        let testAgainstFour = CGPoint(x: 84.68, y: 55.55)
        XCTAssertEqual(testFour.x, testAgainstFour.x, accuracy: 0.01)
        XCTAssertEqual(testFour.y, testAgainstFour.y, accuracy: 0.01)
    }
    
    // MARK: - All Tests
    static var allTests = [
        // Data
        ("testGroupedBarMaxValue", testGroupedBarMaxValue),
        ("testGroupedBarMinValue", testGroupedBarMinValue),
        ("testGroupedBarAverage",  testGroupedBarAverage),
        ("testGroupedBarRange",    testGroupedBarRange),
        // Greater
        ("testGroupedBarIsGreaterThanTwoTrue",  testGroupedBarIsGreaterThanTwoTrue),
        ("testGroupedBarIsGreaterThanTwoFalse", testGroupedBarIsGreaterThanTwoFalse),
        // Labels
        ("testGroupedBarGetYLabels", testGroupedBarGetYLabels),
        // Touch
        ("testMultiLineGetDataPoint",      testGroupedBarGetDataPoint),
        ("testGroupedBarGetPointLocation", testGroupedBarGetPointLocation),
        
    ]
}
