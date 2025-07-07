import 'dart:math';
import 'package:flutter/material.dart';
import '../models/candle.dart';

class VolumeWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double barWidth;
  final double high;
  final Color bullColor;
  final Color bearColor;
  final double? indicatorX;

  const VolumeWidget({
    super.key,
    required this.candles,
    required this.index,
    required this.barWidth,
    required this.high,
    required this.bearColor,
    required this.bullColor,
    this.indicatorX,
  }) : assert(barWidth > 1, 'barWidth must be greater than 1');

  @override
  RenderObject createRenderObject(BuildContext context) {
    return VolumeRenderObject(
      candles,
      index,
      barWidth,
      high,
      bearColor,
      bullColor,
      indicatorX,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant VolumeRenderObject renderObject) {
    renderObject
      .._candles = candles
      .._index = index
      .._barWidth = barWidth
      .._high = high
      .._bearColor = bearColor
      .._bullColor = bullColor
      .._indicatorX = indicatorX
      ..markNeedsPaint();
  }
}

class VolumeRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _barWidth;
  late double _high;
  late Color _bearColor;
  late Color _bullColor;
  double? _indicatorX;

  VolumeRenderObject(
    List<Candle> candles,
    int index,
    double barWidth,
    double high,
    Color bearColor,
    Color bullColor,
    double? indicatorX,
  ) {
    _candles = candles;
    _index = index;
    _barWidth = barWidth;
    _high = high;
    _bearColor = bearColor;
    _bullColor = bullColor;
    _indicatorX = indicatorX;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_high <= 0 || size.height <= 0) return;
    double range = _high / size.height;
    int? highlightedIndex;
    if (_indicatorX != null) {
      highlightedIndex = ((size.width - _indicatorX!) / _barWidth).floor();
    }
    for (int i = 0; (i + 1) * _barWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 0) continue;
      var candle = _candles[i + _index];
      if (candle.volume <= 0) continue;
      paintBar(context, offset, i, candle, range, i == highlightedIndex);
    }
  }

  void paintBar(PaintingContext context, Offset offset, int index, Candle candle, double range, bool isHighlighted) {
    Color color = candle.isBull ? _bullColor : _bearColor;
    double x = size.width + offset.dx - (index + 1) * _barWidth;
    double barHeight = (candle.volume / range).clamp(0, size.height);
    context.canvas.drawRect(
      Rect.fromLTWH(
        x,
        offset.dy + size.height - barHeight,
        max(_barWidth - 1, 0.5),
        barHeight,
      ),
      Paint()
        ..color = isHighlighted ? color.withOpacity(0.8) : color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }
}