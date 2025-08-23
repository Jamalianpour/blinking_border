import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'enums.dart';

/// Custom painter for drawing animated borders
class BorderPainter extends CustomPainter {
  final double animationValue;
  final BlinkStyle blinkStyle;
  final StrokeStyle strokeStyle;
  final Color color;
  final double strokeWidth;
  final BorderRadius borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double dotRadius;
  final double dotSpace;
  final double pulseScale;

  BorderPainter({
    required this.animationValue,
    required this.blinkStyle,
    required this.strokeStyle,
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.dotRadius = 2.0,
    this.dotSpace = 4.0,
    this.pulseScale = 0.05,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    switch (blinkStyle) {
      case BlinkStyle.normal:
        _drawNormalBlink(canvas, rrect, paint);
        break;
      case BlinkStyle.cornerSweep:
        _drawCornerSweep(canvas, rrect, paint);
        break;
      case BlinkStyle.rainbow:
        _drawRainbow(canvas, rrect, paint);
        break;
      case BlinkStyle.pulsing:
        _drawPulsing(canvas, size, rrect, paint);
        break;
      case BlinkStyle.glowing:
        _drawGlowing(canvas, rrect, paint);
        break;
    }
  }

  void _drawNormalBlink(Canvas canvas, RRect rrect, Paint paint) {
    // Smooth sine wave for natural pulsing
    final opacity = (math.sin(animationValue * 2 * math.pi) + 1) / 2;
    paint.color = color.withOpacity(opacity);

    switch (strokeStyle) {
      case StrokeStyle.solid:
        canvas.drawRRect(rrect, paint);
        break;
      case StrokeStyle.dashed:
        _drawDashedRRect(canvas, rrect, paint);
        break;
      case StrokeStyle.dotted:
        _drawDottedRRect(canvas, rrect, paint);
        break;
    }
  }

  void _drawCornerSweep(Canvas canvas, RRect rrect, Paint paint) {
    paint.color = color;

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      final totalLength = metric.length;

      // Create a smooth sweep that travels around the border
      final sweepLength = totalLength * 0.3; // 30% of perimeter
      final startPosition = (animationValue * totalLength) % totalLength;

      // Draw the sweep segment
      for (double i = 0; i < sweepLength; i += 1) {
        final position = (startPosition + i) % totalLength;
        final tangent = metric.getTangentForOffset(position);

        if (tangent != null) {
          // Calculate opacity for smooth fade
          final fadeRatio = i / sweepLength;
          final opacity = math.sin(fadeRatio * math.pi);

          paint.color = color.withOpacity(opacity);

          switch (strokeStyle) {
            case StrokeStyle.solid:
              final segmentPath = metric.extractPath(
                position,
                math.min(position + 1, totalLength),
              );
              canvas.drawPath(segmentPath, paint);
              break;
            case StrokeStyle.dashed:
              if (i % (dashWidth + dashSpace) < dashWidth) {
                canvas.drawCircle(tangent.position, strokeWidth / 2, paint);
              }
              break;
            case StrokeStyle.dotted:
              if (i % (dotRadius * 2 + dotSpace) < dotRadius * 2) {
                canvas.drawCircle(tangent.position, dotRadius, paint);
              }
              break;
          }
        }
      }
    }
  }

  void _drawRainbow(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      final totalLength = metric.length;
      final segmentLength = strokeStyle == StrokeStyle.solid
          ? 2.0
          : strokeStyle == StrokeStyle.dashed
          ? dashWidth
          : dotRadius * 2;

      for (
        double distance = 0;
        distance < totalLength;
        distance += segmentLength
      ) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          // Calculate rainbow color based on position and animation
          final hue = ((distance / totalLength) + animationValue) % 1.0;
          paint.color = HSVColor.fromAHSV(1.0, hue * 360, 1.0, 1.0).toColor();

          switch (strokeStyle) {
            case StrokeStyle.solid:
              final segmentPath = metric.extractPath(
                distance,
                math.min(distance + segmentLength, totalLength),
              );
              canvas.drawPath(segmentPath, paint);
              break;
            case StrokeStyle.dashed:
              if ((distance / (dashWidth + dashSpace)).floor() % 2 == 0) {
                final segmentPath = metric.extractPath(
                  distance,
                  math.min(distance + dashWidth, totalLength),
                );
                canvas.drawPath(segmentPath, paint);
              }
              distance += dashSpace;
              break;
            case StrokeStyle.dotted:
              paint.style = PaintingStyle.fill;
              canvas.drawCircle(tangent.position, dotRadius, paint);
              paint.style = PaintingStyle.stroke;
              distance += dotSpace;
              break;
          }
        }
      }
    }
  }

  void _drawPulsing(Canvas canvas, Size size, RRect rrect, Paint paint) {
    // Calculate pulse effect
    final pulse = math.sin(animationValue * 2 * math.pi);
    final scale = 1.0 + (pulse * pulseScale);

    // Save canvas state
    canvas.save();

    // Apply scale transformation from center
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    // Draw with pulsing opacity
    final opacity = 0.3 + ((pulse + 1) / 2) * 0.7; // Range from 0.3 to 1.0
    paint.color = color.withOpacity(opacity);

    switch (strokeStyle) {
      case StrokeStyle.solid:
        canvas.drawRRect(rrect, paint);
        break;
      case StrokeStyle.dashed:
        _drawDashedRRect(canvas, rrect, paint);
        break;
      case StrokeStyle.dotted:
        _drawDottedRRect(canvas, rrect, paint);
        break;
    }

    // Restore canvas state
    canvas.restore();
  }

  void _drawGlowing(Canvas canvas, RRect rrect, Paint paint) {
    // Calculate glow intensity based on animation
    final glowIntensity = (math.sin(animationValue * 2 * math.pi) + 1) / 2;

    // Draw multiple layers for glow effect
    final layers = 5;
    for (int i = layers; i >= 0; i--) {
      final layerOpacity = (glowIntensity * 0.3) * (1 - (i / layers));
      final blurRadius = strokeWidth * (i + 1) * 1.5;

      paint
        ..color = color.withOpacity(layerOpacity)
        ..strokeWidth = strokeWidth + (i * 2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

      switch (strokeStyle) {
        case StrokeStyle.solid:
          canvas.drawRRect(rrect, paint);
          break;
        case StrokeStyle.dashed:
          _drawDashedRRect(canvas, rrect, paint);
          break;
        case StrokeStyle.dotted:
          _drawDottedRRect(canvas, rrect, paint);
          break;
      }
    }

    // Draw the main border on top
    paint
      ..color = color.withOpacity(0.8 + (glowIntensity * 0.2))
      ..strokeWidth = strokeWidth
      ..maskFilter = null;

    switch (strokeStyle) {
      case StrokeStyle.solid:
        canvas.drawRRect(rrect, paint);
        break;
      case StrokeStyle.dashed:
        _drawDashedRRect(canvas, rrect, paint);
        break;
      case StrokeStyle.dotted:
        _drawDottedRRect(canvas, rrect, paint);
        break;
    }
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final extractPath = metric.extractPath(
          distance,
          math.min(distance + length, metric.length),
        );

        if (draw) {
          canvas.drawPath(extractPath, paint);
        }

        distance += length;
        draw = !draw;
      }
    }
  }

  void _drawDottedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    paint.style = PaintingStyle.fill;

    for (final metric in pathMetrics) {
      double distance = 0;

      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, dotRadius, paint);
        }
        distance += dotRadius * 2 + dotSpace;
      }
    }
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        blinkStyle != oldDelegate.blinkStyle ||
        strokeStyle != oldDelegate.strokeStyle ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        borderRadius != oldDelegate.borderRadius;
  }
}
