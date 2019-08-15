part of charts;

/// LegendPosition.auto places the legend either at the bottom when the height is
/// greater than the width, or at right when the width is greater than height,
/// whereas LegendPosition.bottom places the legend at the bottom of the plot area,
/// whereas LegendPosition.left places the legend at the left of the plot area,
/// whereas LegendPosition.right places the legend at the right of the plot area, and
/// LegendPosition.top places the legend at the top of the plot area.
enum LegendPosition { auto, bottom, left, right, top }

/// ChartAlignment.near aligns to the near position,
/// whereas ChartAlignment.center aligns to the center position,
/// and ChartAlignment.far aligns to the far position.
enum ChartAlignment { near, center, far }

/// LegendItemOverflowMode.wrap legends are wrapped to next line, whereas
/// LegendItemOverflowMode.scroll legends are placed in a single line that can be
/// scrolled, and LegendItemOverflowMode.none legend's position which exceeds the size
/// will not be visible.
enum LegendItemOverflowMode { wrap, scroll, none }

/// LegendItemOrientation.auto aligns the legend items based on size, whereas
/// LegendItemOrientation.horizontal aligns horizontally aligns the legend, and
/// LegendItemOrientation.vertical vertically aligns the legend.
enum LegendItemOrientation { auto, horizontal, vertical }

/// LegendIconType supports the below shapes.
enum LegendIconType {
  seriesType,
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

/// CartesianLabelPosition.auto places the data label either top or bottom position
/// of a point based on the position, whereas CartesianLabelPosition.outer places the
/// data label at the outer side of a point, whereas CartesianLabelPosition.top places
/// the data label at the top position of a point, whereas CartesianLabelPosition.bottom
/// places the data label at the bottom position of a point and
/// CartesianLabelPosition.middle places the data label at the middle position of a point.
enum CartesianLabelPosition { auto, outer, top, bottom, middle }

/// CircularLabelPosition.curve places the data label inside the point,
/// and CircularLabelPosition.line places the data label outside of the point.
enum CircularLabelPosition { inside, outside }
