import XCTest
@testable import SwiftUICharts

final class GroupedBarChartTests: XCTestCase {
    
    enum Group {
        case one
        case two
        case three
        case four
        
        var data : GroupingData {
            switch self {
            case .one:
                return GroupingData(title: "One"  , colour: .blue)
            case .two:
                return GroupingData(title: "Two"  , colour: .red)
            case .three:
                return GroupingData(title: "Three", colour: .yellow)
            case .four:
                return GroupingData(title: "Four" , colour: .green)
            }
        }
    }
    
    let groups : [GroupingData] = [Group.one.data, Group.two.data, Group.three.data, Group.four.data]
    
    let data = MultiBarDataSets(dataSets: [
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "1.2", pointLabel: "One Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", pointLabel: "Two One"    , group: Group.one.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.2", pointLabel: "Two Two"    , group: Group.two.data),
            MultiBarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three"  , group: Group.three.data),
            MultiBarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Four"   , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", pointLabel: "Three One"  , group: Group.one.data),
            MultiBarChartDataPoint(value: 70, xAxisLabel: "3.2", pointLabel: "Three Two"  , group: Group.two.data),
            MultiBarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", group: Group.three.data),
            MultiBarChartDataPoint(value: 90, xAxisLabel: "3.4", pointLabel: "Three Four" , group: Group.four.data)
        ]),
        
        MultiBarDataSet(dataPoints: [
            MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", pointLabel: "Four One"   , group: Group.one.data),
            MultiBarChartDataPoint(value: 80, xAxisLabel: "4.2", pointLabel: "Four Two"   , group: Group.two.data),
            MultiBarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three" , group: Group.three.data),
            MultiBarChartDataPoint(value: 50, xAxisLabel: "4.3", pointLabel: "Four Four"  , group: Group.four.data)
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
                MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", pointLabel: "Two One"  , group: Group.one.data)
            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", pointLabel: "Three One", group: Group.one.data)

            ]),
            
            MultiBarDataSet(dataPoints: [
                MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", pointLabel: "Four One" , group: Group.one.data)
            ])
        ])
        let chartData = GroupedBarChartData(dataSets: data, groups: groups)
        XCTAssertFalse(chartData.isGreaterThanTwo())
    }

    // MARK: Labels
    func testGroupedBarGetYLabels() {
        let chartData = GroupedBarChartData(dataSets: data, groups: groups,
                                                            chartStyle: BarChartStyle(yAxisNumberOfLabels: 3))

        XCTAssertEqual(chartData.getYLabels()[0], 0.00000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[1], 30.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[2], 60.0000, accuracy: 0.01)
        XCTAssertEqual(chartData.getYLabels()[3], 90.0000, accuracy: 0.01)
        
    }

    static var allTests = [
        // Data
        ("testGroupedBarMaxValue", testGroupedBarMaxValue),
        ("testGroupedBarMinValue", testGroupedBarMinValue),
        ("testGroupedBarAverage", testGroupedBarAverage),
        ("testGroupedBarRange", testGroupedBarRange),
        // Greater
        ("testGroupedBarIsGreaterThanTwoTrue", testGroupedBarIsGreaterThanTwoTrue),
        ("testGroupedBarIsGreaterThanTwoFalse", testGroupedBarIsGreaterThanTwoFalse),
        // Labels
        ("testGroupedBarGetYLabels", testGroupedBarGetYLabels),
        
        
    ]
}
