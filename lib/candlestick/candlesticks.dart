// ignore_for_file: library_private_types_in_public_api
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/candlestick/models/candle.dart';
import 'package:crypto_beam/candlestick/models/candle_sticks_style.dart';
import 'package:crypto_beam/candlestick/models/indicator.dart';
import 'package:crypto_beam/candlestick/models/main_window_indicator.dart';
import 'package:crypto_beam/candlestick/widgets/desktop_chart.dart';
import 'package:crypto_beam/candlestick/widgets/mobile_chart.dart';
import 'package:crypto_beam/candlestick/widgets/toolbar.dart';
import 'package:crypto_beam/candlestick/widgets/toolbar_action.dart';

class Candlesticks extends StatefulWidget {
  final List<Candle> candles;
  final Future<void> Function()? onLoadMoreCandles;
  final List<ToolBarAction> actions;
  final List<Indicator>? indicators;
  final void Function(String)? onRemoveIndicator;
  final ChartAdjust chartAdjust;
  final bool displayZoomActions;
  final Widget? loadingWidget;
  final CandleSticksStyle? style;
  final void Function(TapUpDetails)? onTapUp;
  final double scale;
  final double translateX;

  const Candlesticks({
    Key? key,
    required this.candles,
    this.onLoadMoreCandles,
    this.actions = const [],
    this.chartAdjust = ChartAdjust.visibleRange,
    this.displayZoomActions = true,
    this.loadingWidget,
    this.indicators,
    this.onRemoveIndicator,
    this.style,
    this.onTapUp,
    this.scale = 1.0,
    this.translateX = 0.0,
  })  : assert(candles.length == 0 || candles.length > 1,
            "Please provide at least 2 candles"),
        super(key: key);

  @override
  _CandlesticksState createState() => _CandlesticksState();
}

enum ChartAdjust {
  visibleRange,
  fullRange,
}

class _CandlesticksState extends State<Candlesticks> {
  int index = -10;
  double lastX = 0;
  int lastIndex = -10;
  double candleWidth = 7;
  bool isCallingLoadMore = false;
  MainWindowDataContainer? mainWindowDataContainer;

  double getCandleWidth() => candleWidth * widget.scale;

  void updateCandleWidth(double newWidth) {
    setState(() {
      candleWidth = newWidth.clamp(2.0, 20.0);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.candles.isNotEmpty) {
      mainWindowDataContainer =
          MainWindowDataContainer(widget.indicators ?? [], widget.candles);
    }
  }

  @override
  void didUpdateWidget(covariant Candlesticks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.candles.isEmpty) {
      mainWindowDataContainer = null;
      return;
    }
    if (mainWindowDataContainer == null) {
      mainWindowDataContainer =
          MainWindowDataContainer(widget.indicators ?? [], widget.candles);
    } else {
      final currentIndicators = widget.indicators ?? [];
      final oldIndicators = oldWidget.indicators ?? [];
      bool indicatorsChanged = currentIndicators.length !=
              oldIndicators.length ||
          currentIndicators.asMap().entries.any(
              (entry) => entry.value.name != oldIndicators[entry.key].name
              // ||
              // entry.value.parameters != oldIndicators[entry.key].parameters
              );
      if (indicatorsChanged) {
        mainWindowDataContainer =
            MainWindowDataContainer(widget.indicators ?? [], widget.candles);
      } else {
        try {
          mainWindowDataContainer!.tickUpdate(widget.candles);
        } catch (e) {
          debugPrint('Error updating candles: $e');
          mainWindowDataContainer =
              MainWindowDataContainer(widget.indicators ?? [], widget.candles);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        (Theme.of(context).brightness == Brightness.dark
            ? CandleSticksStyle.dark()
            : CandleSticksStyle.light());
    return Semantics(
      label: 'Candlestick chart',
      child: Column(
        children: [
          if (widget.displayZoomActions || widget.actions.isNotEmpty)
            ToolBar(
              color: style.toolBarColor,
              height: 34,
              children: [
                if (widget.displayZoomActions) ...[
                  ToolBarAction(
                    onPressed: () => updateCandleWidth(candleWidth - 2),
                    child: Icon(Icons.remove, color: style.borderColor),
                    semanticsLabel: 'Zoom out',
                  ),
                  ToolBarAction(
                    onPressed: () => updateCandleWidth(candleWidth + 2),
                    child: Icon(Icons.add, color: style.borderColor),
                    semanticsLabel: 'Zoom in',
                  ),
                ],
                ...widget.actions,
              ],
            ),
          if (widget.candles.isEmpty || mainWindowDataContainer == null)
            Expanded(
              child: Center(
                child: widget.loadingWidget ?? const Loading(),
              ),
            )
          else
            Expanded(
              child: Stack(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween(begin: 6.0, end: candleWidth),
                    duration: const Duration(milliseconds: 120),
                    builder: (_, double width, __) {
                      final chart = (kIsWeb ||
                              Platform.isMacOS ||
                              Platform.isWindows ||
                              Platform.isLinux)
                          ? DesktopChart(
                              style: style,
                              onRemoveIndicator: widget.onRemoveIndicator,
                              mainWindowDataContainer: mainWindowDataContainer!,
                              chartAdjust: widget.chartAdjust,
                              // onReachEnd: () => widget.onTapUp,
                              onScaleUpdate: (double scale) {
                                scale = scale.clamp(0.5, 2.0);
                                updateCandleWidth(candleWidth * scale);
                              },
                              onPanEnd: () {
                                lastIndex = index;
                              },
                              onHorizontalDragUpdate: (double x) {
                                setState(() {
                                  x = x - lastX + widget.translateX;
                                  index = lastIndex +
                                      (x ~/ (candleWidth * widget.scale));
                                  index =
                                      max(index, -(widget.candles.length - 1));
                                  index = min(index, widget.candles.length - 1);
                                });
                              },
                              onPanDown: (double value) {
                                lastX = value;
                                lastIndex = index;
                              },
                              onReachEnd: () {
                                if (!isCallingLoadMore &&
                                    widget.onLoadMoreCandles != null) {
                                  setState(() => isCallingLoadMore = true);
                                  widget.onLoadMoreCandles!().then((_) {
                                    setState(() => isCallingLoadMore = false);
                                  });
                                }
                              },
                              candleWidth: width * widget.scale,
                              candles: widget.candles,
                              index: index,
                            )
                          : MobileChart(
                              style: style,
                              onRemoveIndicator: widget.onRemoveIndicator,
                              mainWindowDataContainer: mainWindowDataContainer!,
                              chartAdjust: widget.chartAdjust,
                              // onTapUp: widget.onTapUp,
                              onScaleUpdate: (double scale) {
                                scale = scale.clamp(0.5, 2.0);
                                updateCandleWidth(candleWidth * scale);
                              },
                              onPanEnd: () {
                                lastIndex = index;
                              },
                              onHorizontalDragUpdate: (double x) {
                                setState(() {
                                  x = x - lastX + widget.translateX;
                                  index = lastIndex +
                                      (x ~/ (candleWidth * widget.scale));
                                  index =
                                      max(index, -(widget.candles.length - 1));
                                  index = min(index, widget.candles.length - 1);
                                });
                              },
                              onPanDown: (double value) {
                                lastX = value;
                                lastIndex = index;
                              },
                              onReachEnd: () {
                                if (!isCallingLoadMore &&
                                    widget.onLoadMoreCandles != null) {
                                  setState(() => isCallingLoadMore = true);
                                  widget.onLoadMoreCandles!().then((_) {
                                    setState(() => isCallingLoadMore = false);
                                  });
                                }
                              },
                              candleWidth: width * widget.scale,
                              candles: widget.candles,
                              index: index,
                            );
                      return Semantics(
                        label: 'Chart content',
                        child: chart,
                      );
                    },
                  ),
                  if (isCallingLoadMore)
                    Positioned.fill(
                      child: Center(
                        child: widget.loadingWidget ?? const Loading(),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
