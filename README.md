# SwiftUICharts

A charts / plotting library for SwiftUI. Works on macOS, iOS,  watchOS, and tvOS and has accessibility and Localization features built in.

[Demo Project](https://github.com/willdale/SwiftUICharts-Demo)

[Documentation](https://willdale.github.io/SwiftUICharts/index.html)

Working on a [Version 3](https://github.com/willdale/SwiftUICharts/tree/release/3) with a more SwiftUI feel to the API. 

## Chart Types

- [Line Chart](#Line-Chart)
- [Filled Line Chart](#Filled-Line-Chart)
- [Multi Line Chart](#Multi-Line-Chart)
- [Ranged Line Chart](#Ranged-Line-Chart)

- [Bar Chart](#Bar-Chart)
- [Ranged Bar Chart](#Ranged-Bar-Chart)
- [Grouped Bar Chart](#Grouped-Bar-Chart)
- [Stacked Bar Chart](#Stacked-Bar-Chart)

- [Pie Chart](#Pie-Chart)
- [Doughnut Chart](#Doughnut-Chart)


### Line Charts

#### Line Chart
![Example of Line Chart](Resources/images/LineCharts/LineChart.png)

Uses `LineChartData` data model.

```swift
LineChart(chartData: LineChartData)
```

---


#### Filled Line Chart
![Example of Filled Line Chart](Resources/images/LineCharts/FilledLineChart.png)

Uses `LineChartData` data model.

```swift
FilledLineChart(chartData: LineChartData)
```


---


#### Multi Line Chart
![Example of Multi Line Chart](Resources/images/LineCharts/MultiLineChart.png)

Uses `MultiLineChartData` data model.

```swift
MultiLineChart(chartData: MultiLineChartData)
```


---


#### Ranged Line Chart
![Example of Ranged Line Chart](Resources/images/LineCharts/RangedLineChart.png)

Uses `RangedLineChart` data model.

```swift
RangedLineChart(chartData: RangedLineChartData)
```


---


### Bar Charts

#### Bar Chart
![Example of Bar Chart](Resources/images/BarCharts/BarChart.png)

Uses `BarChartData` data model.

```swift
BarChart(chartData: BarChartData)
```


---


#### Range Bar Chart
![Example of Range Bar Chart](Resources/images/BarCharts/RangeBarChart.png)

Uses `RangedBarChartData` data model.

```swift
RangedBarChart(chartData: RangedBarChartData)
```


---



#### Grouped Bar Chart
![Example of Grouped Bar Chart](Resources/images/BarCharts/GroupedBarChart.png)

Uses `GroupedBarChartData` data model.

```swift
GroupedBarChart(chartData: GroupedBarChartData)
```


---


#### Stacked Bar Chart
![Example of Stacked Bar Chart](Resources/images/BarCharts/StackedBarChart.png)

Uses `StackedBarChartData` data model.

```swift
StackedBarChart(chartData: StackedBarChartData)
```

---


### Pie Charts

#### Pie Chart
![Example of Pie Chart](Resources/images/PieCharts/PieChart.png)

Uses `PieChartData` data model.

```swift
PieChart(chartData: PieChartData)
```


---


#### Doughnut Chart
![Example of Doughnut Chart](Resources/images/PieCharts/DoughnutChart.png)

Uses `DoughnutChartData` data model.

```swift
DoughnutChart(chartData: DoughnutChartData)
```


---

## Documentation
### Installation

Swift Package Manager

```
File > Swift Packages > Add Package Dependency...
```
```swift
import SwiftUICharts
```

If you have trouble with views not updating correctly, add `.id()` to your View.
```swift
LineChart(chartData: LineChartData)
    .id(LineChartData.id)
```

---


## View Modifiers

- [Touch Overlay](#Touch-Overlay)
- [Info Box](#Info-Box) 
- [Floating Info Box](#Floating-Info-Box) 
- [Header Box](#Header-Box) 
- [Legends](#Legends) 

- [Average Line](#Average-Line) 
- [Y Axis Point Of Interest](#Y-Axis-Point-Of-Interest) 
- [X Axis Grid](#X-Axis-Grid) 
- [Y Axis Grid](#Y-Axis-Grid) 
- [X Axis Labels](#X-Axis-Labels) 
- [Y Axis Labels](#Y-Axis-Labels) 
- [Linear Trend Line](#Linear-Trend-Line) 

- [Point Markers](#Point-Markers) 

The order of the view modifiers is some what important as the modifiers are various types of stacks that wrap around the previous views.


---


### All Chart Types

#### Touch Overlay

Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information where specified. 

The location of the info box is set in `ChartStyle -> infoBoxPlacement`.

```swift
.touchOverlay(chartData: CTChartData, specifier: String, unit: TouchUnit)
```
- chartData: Chart data model.
- specifier: Decimal precision for labels.
- unit: Unit to put before or after the value.

Setup within  Chart Data --> Chart Style


---


#### Info Box

Displays the information from [Touch Overlay](#Touch-Overlay) if `InfoBoxPlacement` is set to `.infoBox`.

The location of the info box is set in `ChartStyle -> infoBoxPlacement`.

```swift
.infoBox(chartData: CTChartData)
```
- chartData: Chart data model.


---


#### Floating Info Box

Displays the information from [Touch Overlay](#Touch-Overlay) if `InfoBoxPlacement` is set to `.floating`.

The location of the info box is set in `ChartStyle -> infoBoxPlacement`.

```swift
.floatingInfoBox(chartData: CTChartData)
```
- chartData: Chart data model.


---


#### Header Box

Displays the metadata about the chart, set in `Chart Data -> ChartMetadata`

Displays the information from [Touch Overlay](#Touch-Overlay) if `InfoBoxPlacement` is set to `.header`.

The location of the info box is set in `ChartStyle -> infoBoxPlacement`.

```swift
.headerBox(chartData: CTChartData)
```


---


#### Legends

Displays legends.

```swift
.legends()
```
Lays out markers over each of the data point.


---


### Line and Bar Charts

#### Average Line

Shows a marker line at the average of all the data points.

```swift
.averageLine(chartData: CTLineBarChartDataProtocol,
             markerName: "Average",
             labelPosition: .yAxis(specifier: "%.0f"),
             lineColour: .primary,
             strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
```
- chartData: Chart data model.
- markerName: Title of marker, for the legend.
- labelPosition: Option to display the markers’ value inline with the marker.
- labelColour: Colour of the Text.
- labelBackground: Colour of the background.
- lineColour: Line Colour.
- strokeStyle: Style of Stroke.


---


#### Y Axis Point Of Interest

Configurable Point of interest

```swift
.yAxisPOI(chartData: CTLineBarChartDataProtocol,
          markerName: "Marker",
          markerValue: 123,
          labelPosition: .center(specifier: "%.0f"),
          labelColour: Color.black,
          labelBackground: Color.orange,
          lineColour: Color.orange,
          strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
```
- chartData: Chart data model.
- markerName: Title of marker, for the legend.
- markerValue: Value to mark
- labelPosition: Option to display the markers’ value inline with the marker.
- labelColour: Colour of the Text.
- labelBackground: Colour of the background.
- lineColour: Line Colour.
- strokeStyle: Style of Stroke.
- Returns: A  new view containing the chart with a marker line at a specified value.


---


#### X Axis Grid

Adds vertical lines along the X axis.

```swift
.xAxisGrid(chartData: CTLineBarChartDataProtocol)
```
Setup within  `ChartData -> ChartStyle`.


---


#### Y Axis Grid

Adds horizontal lines along the Y axis.

```swift
.yAxisGrid(chartData: CTLineBarChartDataProtocol)
```
Setup within  `ChartData -> ChartStyle`.


---


#### X Axis Labels

Labels for the X axis.

```swift
.xAxisLabels(chartData: CTLineBarChartDataProtocol)
```
Setup within  `ChartData -> ChartStyle`.


---


#### Y Axis Labels

Automatically generated labels for the Y axis

```swift
.yAxisLabels(chartData: CTLineBarChartDataProtocol, specifier: "%.0f")
```
- specifier: Decimal precision specifier.

Setup within  `ChartData -> ChartStyle`.

yAxisLabelType: 
```swift
case numeric // Auto generated, numeric labels.
case custom // Custom labels array
```
Custom is set from `ChartData -> yAxisLabels`

---


#### Linear Trend Line

A line across the chart to show the trend in the data.

```swift
.linearTrendLine(chartData: CTLineBarChartDataProtocol,
                 firstValue: Double,
                 lastValue: Double,
                 lineColour: ColourStyle,
                 strokeStyle: StrokeStyle)
```


---


### Line Charts

#### Point Markers

Lays out markers over each of the data point.

```swift
.pointMarkers(chartData: CTLineChartDataProtocol)
```
Setup within `Data Set -> PointStyle`.


---


#### Filled Top Line

Adds an independent line on top of FilledLineChart.

```swift
.filledTopLine(chartData: LineChartData,
               lineColour: ColourStyle,
               strokeStyle: StrokeStyle)
```
Allows for a hard line over the data point with a semi opaque fill.


---


## Examples

### Line Chart

```swift
struct LineChartDemoView: View {
    
    let data : LineChartData = weekOfData()
    
    var body: some View {
        VStack {
            LineChart(chartData: data)
                .pointMarkers(chartData: data)
                .touchOverlay(chartData: data, specifier: "%.0f")
                .yAxisPOI(chartData: data,
                          markerName: "Step Count Aim",
                          markerValue: 15_000,
                          labelPosition: .center(specifier: "%.0f"),
                          labelColour: Color.black,
                          labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
                          lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
                          strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                .yAxisPOI(chartData: data,
                          markerName: "Minimum Recommended",
                          markerValue: 10_000,
                          labelPosition: .center(specifier: "%.0f"),
                          labelColour: Color.white,
                          labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
                          lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
                          strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                .averageLine(chartData: data,
                             strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .xAxisLabels(chartData: data)
                .yAxisLabels(chartData: data)
                .infoBox(chartData: data)
                .headerBox(chartData: data)
                .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                .id(data.id)
                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 250, maxHeight: 400, alignment: .center)
        }
        .navigationTitle("Week of Data")
    }
    
    static func weekOfData() -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: 12000, xAxisLabel: "M", description: "Monday"),
            LineChartDataPoint(value: 10000, xAxisLabel: "T", description: "Tuesday"),
            LineChartDataPoint(value: 8000,  xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 17500, xAxisLabel: "T", description: "Thursday"),
            LineChartDataPoint(value: 16000, xAxisLabel: "F", description: "Friday"),
            LineChartDataPoint(value: 11000, xAxisLabel: "S", description: "Saturday"),
            LineChartDataPoint(value: 9000,  xAxisLabel: "S", description: "Sunday")
        ],
        legendTitle: "Steps",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        let metadata   = ChartMetadata(title: "Step Count", subtitle: "Over a Week")
        
        let gridStyle  = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        
                                        baseline            : .minimumWithMaximum(of: 5000),
                                        topLine             : .maximum(of: 20000),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        return LineChartData(dataSets       : data,
                             metadata       : metadata,
                             chartStyle     : chartStyle)
        
    }
}
```

# Accessibility

Inside certain elements are additional tags to help describe the chart for VoiceOver.

See [Localization of Accessibility](#Localization-of-Accessibility)

# Localization

All labels support localization. There are, however, some hidden labels that are there to support VoiceOver. See [Localization of Accessibility](#Localization-of-Accessibility)

# Localization of Accessibility

See the localization demo in the [Demo Project](https://github.com/willdale/SwiftUICharts-Demo).

---

Voice over description of a datapoint when the user touches the area closest to the data point.
The VoiceOver will say `<chart title>, <data point value>, <data point description>`.
```swift
"%@ <local_description_of_a_data_point>" = "%@, <Description of a data point>";
```


Read out before a `poiMarker`.
The VoiceOver will say `<p o i marker>, <marker legend title>, <marker value>`.
```swift
"P-O-I-Marker" = "P O I Marker";
"Average" = "Average";
```

Voice over description of a `poiMarker`.
The VoiceOver will say `<P-O-I-Marker>, <marker legend title>, <marker value>`.
```swift
"<local_marker_legend_title> %@" = "local_marker_legend_title, %@";
```



Read out before a `axisLabel`.
The VoiceOver will say `<axisLabel>, <marker value>`.
```
"X-Axis-Label" = "X Axis Label";
"Y-Axis-Label" = "Y Axis Label";
```

Read out before a `legend`.
The VoiceOver will say `<chart type legend>, <legend title>`.
```swift
"Line-Chart-Legend" = "Line Chart Legend";
"P-O-I-Marker-Legend" = "P O I Marker Legend";
"Bar-Chart-Legend" = "Bar Chart Legend";
"P-O-I-Marker-Legend" = "P O I Marker Legend";
"Pie-Chart-Legend" = "Pie Chart Legend";
"P-O-I-Marker-Legend" = "P O I Marker Legend";
```
