import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'border_painter.dart';
import 'enums.dart';

/// A customizable widget that displays an animated border around its child.
///
/// The border can be configured with different animation styles, stroke patterns,
/// colors, and timing parameters. It supports pulsing, sweeping, rainbow, scale, and glowing animations.
///
/// Example:
/// ```dart
/// BlinkingBorder(
///   child: Container(
///     width: 200,
///     height: 100,
///     child: Center(child: Text('Hello World')),
///   ),
///   color: Colors.blue,
///   blinkStyle: BlinkStyle.glowing,
/// )
/// ```
class BlinkingBorder extends StatefulWidget {
  /// The widget to be wrapped with the blinking border.
  final Widget child;

  /// The color of the border. Defaults to the primary color.
  /// Note: This is ignored when using [BlinkStyle.rainbow].
  final Color? color;

  /// The width of the border stroke. Defaults to 2.0.
  final double strokeWidth;

  /// The style of the blinking animation. Defaults to [BlinkStyle.normal].
  final BlinkStyle blinkStyle;

  /// The style of the border stroke. Defaults to [StrokeStyle.solid].
  final StrokeStyle strokeStyle;

  /// The duration of one complete animation cycle. Defaults to 2 seconds.
  final Duration duration;

  /// The border radius for rounded corners. Defaults to BorderRadius.zero.
  final BorderRadius borderRadius;

  /// Whether the animation should start automatically. Defaults to true.
  final bool autoStart;

  /// Whether the animation should repeat. Defaults to true.
  final bool repeat;

  /// The width of dashes when using [StrokeStyle.dashed]. Defaults to 5.0.
  final double dashWidth;

  /// The space between dashes when using [StrokeStyle.dashed]. Defaults to 3.0.
  final double dashSpace;

  /// The radius of dots when using [StrokeStyle.dotted]. Defaults to 2.0.
  final double dotRadius;

  /// The space between dots when using [StrokeStyle.dotted]. Defaults to 4.0.
  final double dotSpace;

  /// The curve for the animation. Defaults to [Curves.linear].
  final Curve curve;

  /// Optional padding between the child and the border.
  final EdgeInsetsGeometry? padding;

  /// The scale factor for the pulsing animation. Defaults to 0.05 (5% scale).
  /// Only used when [blinkStyle] is [BlinkStyle.pulsing].
  final double pulseScale;

  /// Creates a blinking border widget.
  const BlinkingBorder({
    super.key,
    required this.child,
    this.color,
    this.strokeWidth = 2.0,
    this.blinkStyle = BlinkStyle.normal,
    this.strokeStyle = StrokeStyle.solid,
    this.duration = const Duration(seconds: 2),
    this.borderRadius = BorderRadius.zero,
    this.autoStart = true,
    this.repeat = true,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.dotRadius = 2.0,
    this.dotSpace = 4.0,
    this.curve = Curves.linear,
    this.padding,
    this.pulseScale = 0.05,
  });

  @override
  State<BlinkingBorder> createState() => _BlinkingBorderState();
}

class _BlinkingBorderState extends State<BlinkingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.autoStart) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(BlinkingBorder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.curve != oldWidget.curve) {
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }

    if (widget.autoStart != oldWidget.autoStart ||
        widget.repeat != oldWidget.repeat) {
      _controller.stop();
      if (widget.autoStart) {
        if (widget.repeat) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Starts the animation.
  void start() {
    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  /// Stops the animation.
  void stop() {
    _controller.stop();
  }

  /// Resets the animation to the beginning.
  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // For pulsing style, we need to transform the entire widget
        if (widget.blinkStyle == BlinkStyle.pulsing) {
          final pulse = math.sin(_animation.value * 2 * math.pi);
          final scale = 1.0 + (pulse * widget.pulseScale);

          return Transform.scale(
            scale: scale,
            child: CustomPaint(
              painter: BorderPainter(
                animationValue: _animation.value,
                blinkStyle: widget.blinkStyle,
                strokeStyle: widget.strokeStyle,
                color: effectiveColor,
                strokeWidth: widget.strokeWidth,
                borderRadius: widget.borderRadius,
                dashWidth: widget.dashWidth,
                dashSpace: widget.dashSpace,
                dotRadius: widget.dotRadius,
                dotSpace: widget.dotSpace,
                pulseScale: widget.pulseScale,
              ),
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(widget.strokeWidth),
                child: widget.child,
              ),
            ),
          );
        }

        // For other styles, just paint the border
        return CustomPaint(
          painter: BorderPainter(
            animationValue: _animation.value,
            blinkStyle: widget.blinkStyle,
            strokeStyle: widget.strokeStyle,
            color: effectiveColor,
            strokeWidth: widget.strokeWidth,
            borderRadius: widget.borderRadius,
            dashWidth: widget.dashWidth,
            dashSpace: widget.dashSpace,
            dotRadius: widget.dotRadius,
            dotSpace: widget.dotSpace,
            pulseScale: widget.pulseScale,
          ),
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(widget.strokeWidth),
            child: widget.child,
          ),
        );
      },
    );
  }
}
