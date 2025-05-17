import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const int _kIndeterminateLinearDuration = 1800;

abstract class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color? backgroundColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [ProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  /// {@endtemplate}
  final String? semanticsValue;

  Color _getValueColor(BuildContext context, {Color? defaultColor}) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        defaultColor ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value, showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    this.value,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    this.showTooltip = false,
    this.tooltipText = "",
  });

  final Color backgroundColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry indicatorBorderRadius;
  final bool? showTooltip;
  final String tooltipText;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    paint.color = valueColor;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left = switch (textDirection) {
        TextDirection.rtl => size.width - width - x,
        TextDirection.ltr => x,
      };

      final Rect rect = Offset(left, 0.0) & Size(width, size.height);
      if (indicatorBorderRadius != BorderRadius.zero) {
        final RRect rrect = indicatorBorderRadius.resolve(textDirection).toRRect(rect);
        canvas.drawRRect(rrect, paint);
      } else {
        canvas.drawRect(rect, paint);
      }
    }

    if (value != null) {
      final double clampedValue = clampDouble(value!, 0.0, 1.0);
      final double barWidth = clampedValue * size.width;
      drawBar(0.0, barWidth);

      if(showTooltip == true) {
        // Tooltip drawing
        final double tooltipX = switch (textDirection) {
          TextDirection.rtl => size.width - barWidth,
          TextDirection.ltr => barWidth,
        };

        Color tooltipFillColor = Colors.white;
        Color tooltipBorderColor = const Color(0xFFDDDDDD);

        final Paint fillPaint = Paint()
          ..color = tooltipFillColor
          ..style = PaintingStyle.fill;

        final Paint borderPaint = Paint()
          ..color = tooltipBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        final textSpan = TextSpan(
          text: tooltipText,
          style: const TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: textDirection,
        );
        textPainter.layout();

        final double bubbleWidth = textPainter.width + 20;

        final path = Path();
        path.moveTo(tooltipX, 0);
        path.lineTo(tooltipX-8, -8);
        path.lineTo(tooltipX-15, -8);
        path.arcToPoint(Offset(tooltipX-18, -12), radius: const Radius.circular(4));
        path.lineTo(tooltipX-18, -(bubbleWidth-5));
        path.arcToPoint(Offset(tooltipX-15, -bubbleWidth), radius: const Radius.circular(4));
        path.lineTo(tooltipX+15, -bubbleWidth);
        path.arcToPoint(Offset(tooltipX+18, -(bubbleWidth-5)), radius: const Radius.circular(4));
        path.lineTo(tooltipX+18, -12);
        path.arcToPoint(Offset(tooltipX+15, -8), radius: const Radius.circular(4));
        path.lineTo(tooltipX+8, -8);

        path.close();
        // Draw filled bubble
        canvas.drawPath(path, fillPaint);
        // Draw border
        canvas.drawPath(path, borderPaint);
        canvas.save();
        canvas.rotate(math.pi*3/2);
        final Offset textOffset = Offset(
          15,
          tooltipX-8,
        );
        textPainter.paint(canvas, textOffset);
        canvas.restore();
      }
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 = size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 = size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor
        || oldPainter.valueColor != valueColor
        || oldPainter.value != value
        || oldPainter.animationValue != animationValue
        || oldPainter.textDirection != textDirection
        || oldPainter.indicatorBorderRadius != indicatorBorderRadius;
  }
}

class LinearProgressIndicatorWithTooltip extends ProgressIndicator {
  /// Creates a linear progress indicator.
  ///
  /// {@macro flutter.material.ProgressIndicator.ProgressIndicator}
  const LinearProgressIndicatorWithTooltip({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    this.borderRadius = BorderRadius.zero,
    required this.showTooltip,
    required this.tooltipText
  }) : assert(minHeight == null || minHeight > 0);

  /// {@template flutter.material.LinearProgressIndicator.trackColor}
  /// Color of the track being filled by the linear indicator.
  ///
  /// If [LinearProgressIndicator.backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.background]
  /// will be used to draw the track.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// {@template flutter.material.LinearProgressIndicator.minHeight}
  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [LinearProgressIndicator.minHeight] is null then it will use the
  /// ambient [ProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  /// {@endtemplate}
  final double? minHeight;

  /// The border radius of both the indicator and the track.
  ///
  /// By default it is [BorderRadius.zero], which produces a rectangular shape
  /// with a rectangular indicator.
  final BorderRadiusGeometry borderRadius;

  /// If you want to show the current progress value or any mapping value
  /// you can enable this tooltip which will attach a box shape view
  /// that showing the progress value
  final bool showTooltip;

  ///The text you want to show in the tooltip
  final String tooltipText;

  @override
  State<LinearProgressIndicatorWithTooltip> createState() => _LinearProgressIndicatorWithTooltipState();
}

class _LinearProgressIndicatorWithTooltipState extends State<LinearProgressIndicatorWithTooltip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LinearProgressIndicatorWithTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue, TextDirection textDirection) {
    final ProgressIndicatorThemeData defaults = Theme.of(context).useMaterial3
        ? _LinearProgressIndicatorDefaultsM3(context)
        : _LinearProgressIndicatorDefaultsM2(context);

    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        defaults.linearTrackColor!;
    final double minHeight = widget.minHeight ??
        indicatorTheme.linearMinHeight ??
        defaults.linearMinHeight!;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        // Clip is only needed with indeterminate progress indicators
        clipBehavior: (widget.borderRadius != BorderRadius.zero && widget.value == null)
            ? Clip.antiAlias
            : Clip.none,
        decoration: ShapeDecoration(
          color: trackColor,
          shape: RoundedRectangleBorder(borderRadius: widget.borderRadius,),
        ),
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context, defaultColor: defaults.color),
            value: widget.value, // may be null
            animationValue: animationValue, // ignored if widget.value is not null
            textDirection: textDirection,
            indicatorBorderRadius: widget.borderRadius,
            showTooltip: widget.showTooltip,
            tooltipText: widget.tooltipText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _LinearProgressIndicatorDefaultsM2 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM2(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.background;

  @override
  double get linearMinHeight => 4.0;
}
class _LinearProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.secondaryContainer;

  @override
  double get linearMinHeight => 4.0;
}

// END GENERATED TOKEN PROPERTIES - ProgressIndicator
