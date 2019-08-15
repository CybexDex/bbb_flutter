part of charts;

/// AxisOrientation specifies the orientation of an axis either vertical or horizontal.
enum AxisOrientation { vertical, horizontal }

/// ChartRangePadding.auto, the horizontal numeric axis takes None as padding
/// calculation, while the vertical numeric axis takes Normal as padding
/// calculation, whereas ChartRangePadding.none, minimum and maximum of an axis is based
/// on the data, whereas ChartRangePadding.normal, padding is applied to the axis
/// based on default range calculation, whereas ChartRangePadding.additional, an interval
/// of an axis will be added to the minimum and maximum of the axis, and
/// ChartRangePadding.round, minimum and maximum will be rounded to the nearest possible
/// value, which is divisible by an interval.
enum ChartRangePadding { auto, none, normal, additional, round }

/// LabelPlacement.betweenTicks places the axis label between the ticks, and
/// LabelPlacement.onTicks places the axis label on the ticks.
enum LabelPlacement { betweenTicks, onTicks }

/// AxisLabelIntersectAction.none makes the axis labels overlap with the other when
/// intersects, whereas AxisLabelIntersectAction.hide makes the axis label to be hidden,
/// whereas AxisLabelIntersectAction.wrap makes the axis label wrapped to the next line,
/// whereas AxisLabelIntersectAction.multipleRows moves the axis label to the next line,
/// whereas AxisLabelIntersectAction.rotate45 rotates the axis label to 45°, and
/// AxisLabelIntersectAction.rotate90 rotates the axis label to 90°.
enum AxisLabelIntersectAction {
  none,
  hide,
  wrap,
  multipleRows,
  rotate45,
  rotate90
}

/// DateTimeIntervalType.auto intervals are calcualted based in the data points,
/// whereas DateTimeIntervalType.years intervals are calculated based on years,
/// whereas DateTimeIntervalType.months intervals are calculated based on months,
/// whereas DateTimeIntervalType.days intervals are calculated based on days,
/// whereas DateTimeIntervalType.hours intervals are calculated based on hours,
/// whereas DateTimeIntervalType.minutes intervals are calculated based on minutes, and
/// DateTimeIntervalType.seconds intervals are calculated based on seconds.
enum DateTimeIntervalType { auto, years, months, days, hours, minutes, seconds }

/// LabelPosition.inside places the axis label inside the plot area,
/// and LabelPosition.outside places the axis label outside the plot area.
enum LabelPosition { inside, outside }

/// DataMarkerType supports the below shapes. If the shape is DataMarkerType.image,
/// specify the image path in imageUrl property of markerSettings.
enum DataMarkerType {
  circle,
  rectangle,
  image,
  pentagon,
  verticalLine,
  horizontalLine,
  diamond,
  triangle,
  invertedTriangle
}

/// SplineType supports the following types. If SplineType.cardinal type is specified,
/// then specify the line tension using cardinalSplineTension of series property.
enum SplineType { natural, monotonic, cardinal, clamped }

/// EdgeLabelPlacement.none places the axis edge labels in normal position,
/// whereas EdgeLabelPlacement.hides hide the edge labels, and EdgeLabelPlacement.shift
/// shift the edge labels.
enum EdgeLabelPlacement { none, hide, shift }

/// EmptyPointMode.gap the point is considered as a gap, whereas EmptyPointMode.zero
/// y value is considered as zero whereas EmptyPointMode.drop y value drops to a minimum
/// of the axis, and EmptyPointMode.average y value is considered as the average of
/// two points.
enum EmptyPointMode { gap, zero, drop, average }

/// SortingOrder.ascending arranges the points in ascending order,
/// whereas SortingOrder.descending arranges the points in descending order,
/// and SortingOrder.none renders the points normally.
enum SortingOrder { ascending, descending, none }

/// TickPosition.inside places the ticks inside the plot area,
/// and TickPosition.outside places the ticks outside the plot area.
enum TickPosition { inside, outside }

/// ActivationMode.singleTap activates the acitvation mode on singleTap,
/// whereas ActivationMode.doubleTap activates the acitvation mode on doubleTap,
/// whereas ActivationMode.longPress activates the acitvation mode on longPress,
/// and ActivationMode.none touch activation will not work.
enum ActivationMode { singleTap, doubleTap, longPress, none }

/// TrackballDisplayMode.floatAllPoints points of different series are individually
/// shown, whereas TrackballDisplayMode.groupAllPoints points of different series
/// are grouped, whereas TrackballDisplayMode.nearestPoint nearest point is shown, and
/// TrackballDisplayMode.none trackball is not shown.
enum TrackballDisplayMode { none, floatAllPoints, groupAllPoints, nearestPoint }

/// CrosshairLineType.both horizotal and vertical lines are shown,
/// whereas CrosshairLineType.horizontal horizontal line is shown,
/// whereas CrosshairLineType.vertical vertical line is shown,
/// and CrosshairLineType.none crosshair line will not be shown.
enum CrosshairLineType { both, horizontal, vertical, none }

/// TrackballLineType.vertical vertical trackball line is shown,
/// whereas TrackballLineType.horizontal horizontal trackball line is shown,
/// and TrackballLineType.none trackball line is shown.
enum TrackballLineType { vertical, horizontal, none }

/// ZoomMode.x zooms in the x-direction, whereas ZoomMode.y zooms in the y-direction,
/// and ZoomMode.xy zooms in xy direction.
enum ZoomMode { x, y, xy }

/// SelectionType.point zooms selects the individual point, whereas SelectionType.series
/// selects the entire series, and SelectionType.cluster selects the cluster of points.
enum SelectionType { point, series, cluster }

/// CoordinateUnit.point places the annotation concerning points, and
/// CoordinateUnit.logicalPixel places the annotation concerning pixel value.
enum CoordinateUnit { point, logicalPixel }

/// AnnotationRegion.chart places the annotation anywhere in chart area,
/// and AnnotationRegion.logicalPixel places the annotation plot area.
enum AnnotationRegion { chart, plotArea }

/// AreaBorderMode.all zooms border for all sides of area series,
/// whereas AreaBorderMode.top border for only top,
/// and AreaBorderMode.excludeBottom border except for bottom.
enum AreaBorderMode { all, top, excludeBottom }
