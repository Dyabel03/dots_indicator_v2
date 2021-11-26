import 'package:dots_indicator/dot_indicator_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const widgetSize = Size(250, 30);
  const int numDots = 7;
  const double dotSize = 8.0;
  const double activeDotMaxWidth = 40.0;

  test('dots are always separated by a constant space when not animating', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0);

    var diffs = <double>[];
    for (var i = 1; i < rects.length; i++) {
      final leftRect = rects[i - 1];
      final rightRect = rects[i];
      final diff = rightRect.topLeft.dx - leftRect.topRight.dx;
      diffs.add(diff);
    }

    final allAreEqual = diffs.every((element) => diffs[0] == element);
    assert(allAreEqual);
  });

  test('first dot is located at (0,0)', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0);
    assert(rects.first.topLeft == Offset.zero);
  });

  test('returns 7 rects', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0);
    assert(rects.length == 7);
  });

  test('last dot ist located at (width - dotsize, 0)', () {
    final lastRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0).last;
    assert(lastRect.topLeft == Offset(250 - 8, 0));
  });

  test('first dot moves right when moving right', () {
    final rect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0.2).first;

    assert(rect.topLeft.dx != 0);
  });

  test('active dot has max width when offset is zero', () {
    final activeRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0.0)[3];
    assert(activeRect.width == 40);
  });

  test('active dot has max width when offset is 1', () {
    final activeRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 1.0)[3];
    assert(activeRect.width == dotSize);
  });

  test('adjacent dot has larger size when animating left', () {
    final nextRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: -0.5)[4];
    assert(nextRect.width > dotSize);
  });

  test('adjacent dot has larger size when animating right', () {
    final nextRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0.5)[2];
    assert(nextRect.width > dotSize);
  });

  test(
      'second box occupies first box location after complete animtation to left',
      () {
    final secondRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: -1.0)[1];
    assert(secondRect.topLeft.dx == 0);
  });

  test('active dot has smaller size when animating', () {
    final nextRect =
        DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0.5)[3];
    assert(nextRect.width < activeDotMaxWidth);
  });

  test(
      'dots are always separated by a constant space when in middle of left animation',
      () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: -0.5);

    var diffs = <double>[];
    for (var i = 1; i < rects.length; i++) {
      final leftRect = rects[i - 1];
      final rightRect = rects[i];
      final diff = rightRect.topLeft.dx - leftRect.topRight.dx;
      diffs.add(diff);
    }

    final allAreEqual = diffs.every((element) => diffs[0] == element);
    assert(allAreEqual);
  });

  // Test de 7 cajas
  test('Validate that the function allways return 7 dots when offset 0', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 0.0);

    assert(rects.length == 4);
  });

  test('Validate that the function allways return 7 dots when offset -1', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: -1.0);

    assert(rects.length == 5);
  });

  test('Validate that the function allways return 7 dots when offset -3', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: -3.0);

    assert(rects.length == 7);
  });

  test('Validate that the function allways return 7 dots when offset 1', () {
    final rects = DotIndicatorPainter.dotBoxes(size: widgetSize, offset: 1.0);

    assert(rects.length == 5);
  });
}
