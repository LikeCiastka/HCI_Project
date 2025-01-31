import 'dart:math';

import 'package:flutter/material.dart';

class CustomTimerWidget extends LeafRenderObjectWidget {
  final double progress;
  final String remainingTime;
  final String label;
  final VoidCallback? onTap;

  const CustomTimerWidget({
    super.key,
    required this.progress,
    required this.remainingTime,
    this.label = 'Short Break',
    this.onTap,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomTimer(
      progress: progress,
      remainingTime: remainingTime,
      label: label,
      onTap: onTap,
      textTheme: Theme.of(context).textTheme,
      colorScheme: Theme.of(context).colorScheme,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomTimer renderObject) {
    renderObject
      ..progress = progress
      ..remainingTime = remainingTime
      ..label = label
      ..onTap = onTap
      ..textTheme = Theme.of(context).textTheme
      ..colorScheme = Theme.of(context).colorScheme;
  }
}

class RenderCustomTimer extends RenderBox {
  RenderCustomTimer({
    required double progress,
    required String remainingTime,
    required String label,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
  })  : _progress = progress,
        _remainingTime = remainingTime,
        _label = label,
        _textTheme = textTheme,
        _colorScheme = colorScheme,
        _onTap = onTap;

  double _progress;
  String _remainingTime;
  String _label;
  TextTheme _textTheme;
  ColorScheme _colorScheme;
  VoidCallback? _onTap;

  // Getters and setters
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsPaint();
  }

  set remainingTime(String value) {
    if (_remainingTime == value) return;
    _remainingTime = value;
    markNeedsPaint();
  }

  set label(String value) {
    if (_label == value) return;
    _label = value;
    markNeedsPaint();
  }

  set textTheme(TextTheme value) {
    if (_textTheme == value) return;
    _textTheme = value;
    markNeedsPaint();
  }

  set colorScheme(ColorScheme value) {
    if (_colorScheme == value) return;
    _colorScheme = value;
    markNeedsPaint();
  }

  set onTap(VoidCallback? value) {
    if (_onTap == value) return;
    _onTap = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrain(const Size(300, 300));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final center = size.center(offset);
    final radius = size.width / 2.5;

    // Draw outer glow background
    final outerGlowPaint = Paint()
      ..color = _colorScheme.primary.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10);
    canvas.drawCircle(center, radius + 10, outerGlowPaint);

    // Draw background circle with more visible border
    final backgroundPaint = Paint()
      ..color = _colorScheme.primary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw middle circle (new)
    final middleCirclePaint = Paint()
      ..color = _colorScheme.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 30, middleCirclePaint);

    // Draw middle circle border (new)
    final middleCircleBorderPaint = Paint()
      ..color = _colorScheme.tertiary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 30, middleCircleBorderPaint);

    // Draw progress arc with gradient and glow
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressGradient = SweepGradient(
      colors: [
        _colorScheme.primary.withOpacity(0.7),
        _colorScheme.secondary,
        _colorScheme.primary,
      ],
      stops: const [0.0, 0.5, 1.0],
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      transform: const GradientRotation(-pi / 2),
    ).createShader(rect);

    // Draw progress arc
    final progressPaint = Paint()
      ..shader = progressGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * _progress,
      false,
      progressPaint,
    );

    // Draw time text
    _drawText(
      canvas,
      center,
      _remainingTime,
      _textTheme.displayMedium!.copyWith(
        color: _colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );

    // Draw label text
    _drawText(
      canvas,
      center + const Offset(0, 40),
      _label,
      _textTheme.bodyLarge!.copyWith(
        color: _colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }

  void _drawText(Canvas canvas, Offset center, String text, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center.translate(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  @override
  bool hitTestSelf(Offset position) => true;
}
