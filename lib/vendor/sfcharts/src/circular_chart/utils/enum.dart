part of charts;

/// CircularChartGroupMode.point groups the points based on length, and
/// CircularChartGroupMode.value groups the points based on the y-value.
enum CircularChartGroupMode { point, value }

/// Position.left places the data label to the left side, and Position.right
/// places the data label to the right side.
enum Position { left, right }

/// LabelIntersectAction.hide data label is hidden on intersection,
/// and LabelIntersectAction.none data label is not shown on intersection.
enum LabelIntersectAction { hide, none }

/// ConnectorType.curve data label connector line shape is of curve type,
/// and ConnectorType.line data label connector line shape is of line type.
enum ConnectorType { curve, line }

/// CornerStyle.bothFlat corner style of radial bar at start and end is of plot type,
/// whereas CornerStyle.bothCurve corner style of radial bar at start and end is of curve type,
/// whereas CornerStyle.startCurve corner style of radial bar at start is of curve type,
/// and CornerStyle.endCurve corner style of radial bar at end is of curve type.
enum CornerStyle { bothFlat, bothCurve, startCurve, endCurve }
