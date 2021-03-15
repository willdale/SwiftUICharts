import XCTest

import LineChartPathTests

var tests = [XCTestCaseEntry]()
tests += BarChartTests.allTests()
tests += GroupedBarChartTests.allTests()
tests += StackedBarChartTests.allTests()
tests += LineChartTests.allTests()
tests += MultiLineChartTest.allTests()
tests += LineChartPathTests.allTests()
XCTMain(tests)
