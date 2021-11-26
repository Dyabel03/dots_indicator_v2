import 'package:flutter/material.dart';
import 'dart:math' as math;

class DotIndicatorPainter extends CustomPainter {
  final Offset offset;
  final int currentIndex;

  DotIndicatorPainter(this.offset, this.currentIndex);
  static const dotSize = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rects =
        dotBoxes(size: size, offset: offset.dx, currentIndex: currentIndex);
    var k = 0;
    for (final rect in rects) {
      var rrect = RRect.fromRectAndRadius(rect, Radius.circular(dotSize * .5));
      final dotPaint = Paint()
        ..color = Colors.blue.withOpacity(1.0)
        ..style = PaintingStyle.fill
        ..strokeWidth = 1.0;

      // if (k < 3 && offset.dx >= 0.0) {
      //   dotPaint = Paint()
      //     ..color = Colors.blue.withOpacity(0.0)
      //     ..style = PaintingStyle.fill
      //     ..strokeWidth = 1.0;
      // }

      // shrink first and last
      if (k == 0 || k == rects.length - 1) {
        rrect = rrect.deflate(1.0 - offset.dx.abs());
      }

      if (k == rects.length - 2 && offset.dx > 0) {
        rrect = rrect.deflate(offset.dx.abs());
      }

      if (k == 1 && offset.dx < 0) {
        rrect = rrect.deflate(offset.dx.abs());
      }

      canvas.drawRRect(rrect, dotPaint);
      k++;
    }

    // final paint1 = Paint()
    //   ..color = Colors.green.withOpacity(offset.dx.clamp(0.0, 1.0))
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 1.0;

    // final paint2 = Paint()
    //   ..color = Colors.green.withOpacity(offset.dx.clamp(-1.0, 0.0) * -1.0)
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 1.0;

    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //       Rect.fromLTWH(dotSize * offset.dx - dotSize, 0, dotSize, dotSize),
    //       Radius.circular(dotSize * .5),
    //     ).deflate(1),
    //     paint1);

    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //       Rect.fromLTWH(
    //           size.width - (dotSize * offset.dx * -1), 0, dotSize, dotSize),
    //       Radius.circular(dotSize * .5),
    //     ).deflate(1),
    //     paint2);
  }

  @override
  bool shouldRepaint(DotIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DotIndicatorPainter oldDelegate) => false;

  static List<Rect> dotBoxes({
    required Size size,
    required double offset,
    int numDots = 7,
    double dotSize = 8.0,
    double activeDotMaxWidth = 40.0,
    int currentIndex = 0,
  }) {
    final maxExpansion = activeDotMaxWidth - dotSize;
    final dotOccupiedSpace = numDots * dotSize + maxExpansion;
    // ds = (w - os) / (n - 1)
    final dotSeparation =
        ((size.width - dotOccupiedSpace) / (numDots - 1).toDouble());
    const activeDotIndex = 3;
    final adjacentRightIndex = activeDotIndex + 1;
    final adjacentLeftIndex = activeDotIndex - 1;

    //Offset in range [-1, 1]

    final movingLeft = offset < 0.0;
    final movingRight = offset > 0.0;
    final expansion = maxExpansion * (1 - offset.abs().clamp(-1, 1));

    var rects = <Rect>[];

    for (var i = 0; i < numDots; i++) {
      if (i < activeDotIndex - currentIndex - i) {
        continue;
      }
      final isRightDot = i > activeDotIndex;

      final translation = offset * (dotSeparation + dotSize);
      final remainingExpansion = maxExpansion - expansion;

      double xPos = i.toDouble() * (dotSize + dotSeparation) +
          (isRightDot ? maxExpansion : 0.0) +
          translation;

      var width = dotSize;
      if (i == activeDotIndex && movingRight) {
        xPos += remainingExpansion;
      }
      if (i == adjacentRightIndex && movingLeft) {
        xPos -= remainingExpansion;
      }

      if (i == activeDotIndex) {
        width = dotSize + expansion;
      } else if (i == adjacentLeftIndex && movingRight) {
        width = dotSize + remainingExpansion;
      } else if (i == adjacentRightIndex && movingLeft) {
        width = dotSize + remainingExpansion;
      }

      var rect = Rect.fromLTWH(xPos, 0, width, dotSize);

      rects.add(rect);
    }

    if (movingLeft) {
      rects.add(Rect.fromLTWH(size.width, 0, dotSize, dotSize));
    }

    return rects;
  }
}
