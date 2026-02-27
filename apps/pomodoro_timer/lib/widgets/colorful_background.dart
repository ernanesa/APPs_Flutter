import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorfulBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const ColorfulBackground({
    super.key,
    required this.child,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  @override
  State<ColorfulBackground> createState() => _ColorfulBackgroundState();
}

class _ColorfulBackgroundState extends State<ColorfulBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.primaryColor,
                Color.lerp(widget.primaryColor, widget.secondaryColor, 0.5)!,
                widget.secondaryColor,
                widget.accentColor.withValues(alpha: 0.8),
              ],
              stops: [
                0.0,
                0.3 + (_controller.value * 0.1),
                0.6 + (_controller.value * 0.1),
                1.0,
              ],
              transform: GradientRotation(
                _controller.value * 2 * math.pi * 0.05,
              ),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GradientRotation extends GradientTransform {
  final double radians;

  const GradientRotation(this.radians);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final Offset center = bounds.center;
    // We don't need sin/cos for simple rotation around center using Matrix4
    // But GradientRotation usually means rotating the gradient shading.
    // The default LinearGradient rotation uses radians.

    // Standard implementation for GradientRotation:
    // It seems Flutter's GradientRotation class (internal) does some math.
    // But here we just want to rotate around the center.

    return Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..rotateZ(radians)
      ..translate(-center.dx, -center.dy);
  }
}
