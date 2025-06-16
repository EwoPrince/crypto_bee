// ignore_for_file: library_private_types_in_public_api

import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/candle.dart';
import 'models/candle_sticks_style.dart';
import 'models/indicator.dart';
import 'models/main_window_indicator.dart';
import 'widgets/desktop_chart.dart';
import 'widgets/mobile_chart.dart';
import 'widgets/toolbar.dart';
import 'widgets/toolbar_action.dart';

/// StatefulWidget that holds Chart's State (index of
/// current position and candles width).
class Candlesticks extends StatefulWidget {
  /// The arrangement of the array should be such that
  /// the newest item is in position 0
  final List<Candle> candles;

  /// This callback calls when the last candle gets visible
  final Future<void> Function()? onLoadMoreCandles;

  /// List of buttons you want to add on top tool bar
  final List<ToolBarAction> actions;

  /// List of indicators to draw
  final List<Indicator>? indicators;

  /// This callback calls when ever user clicks a specific indicator close button (X)
  final void Function(String)? onRemoveIndicator;

  /// How chart price range will be adjusted when moving chart
  final ChartAdjust chartAdjust;

  /// Will zoom buttons be displayed in toolbar
  final bool displayZoomActions;

  /// Custom loading widget
  final Widget? loadingWidget;

  final CandleSticksStyle? style;

  /// Callback for tap events on the chart
  final void Function(TapUpDetails)? onTapUp;

  /// Current scale of the chart
  final double scale;

  /// Current horizontal translation of the chart
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
  /// Will adjust chart size by max and min value from visible area
  visibleRange,

  /// Will adjust chart size by max and min value from the whole data
  fullRange
}

class _CandlesticksState extends State<Candlesticks> {
  /// index of the newest candle to be displayed
  /// changes when user scrolls along the chart
  int index = -10;
  double lastX = 0;
  int lastIndex = -10;

  /// candleWidth controls the width of the single candles.
  /// range: [2...20]
  double candleWidth = 6;

  /// true when widget.onLoadMoreCandles is fetching new candles.
  bool isCallingLoadMore = false;

  MainWindowDataContainer? mainWindowDataContainer;

  void updateCandleWidth(double newWidth) {
    setState(() {
      candleWidth = newWidth.clamp(2.0, 20.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        (Theme.of(context).brightness == Brightness.dark
            ? CandleSticksStyle.dark()
            : CandleSticksStyle.light());
    return Column(
      children: [
        if (widget.displayZoomActions || widget.actions.isNotEmpty) ...[
          ToolBar(
            color: style.toolBarColor,
            children: [
              if (widget.displayZoomActions) ...[
                ToolBarAction(
                  onPressed: () => updateCandleWidth(candleWidth - 2),
                  child: Icon(
                    Icons.remove,
                    color: style.borderColor,
                  ),
                ),
                ToolBarAction(
                  onPressed: () => updateCandleWidth(candleWidth + 2),
                  child: Icon(
                    Icons.add,
                    color: style.borderColor,
                  ),
                ),
              ],
              ...widget.actions
            ],
          ),
        ],
        if (widget.candles.isEmpty || mainWindowDataContainer == null)
          Expanded(
            child: Center(
              child: widget.loadingWidget ??
                  Loading(),
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
                    if (kIsWeb ||
                        Platform.isMacOS ||
                        Platform.isWindows ||
                        Platform.isLinux) {
                      return DesktopChart(
                        style: style,
                        onRemoveIndicator: widget.onRemoveIndicator,
                        mainWindowDataContainer: mainWindowDataContainer!,
                        chartAdjust: widget.chartAdjust,
                        // onTapUp: widget.onTapUp,
                        onScaleUpdate: (double scale) {
                          scale = scale.clamp(0.9, 1.1);
                          updateCandleWidth(candleWidth * scale);
                        },
                        onPanEnd: () {
                          lastIndex = index;
                        },
                        onHorizontalDragUpdate: (double x) {
                          setState(() {
                            x = x - lastX;
                            index =
                                lastIndex + (x ~/ (candleWidth * widget.scale));
                            index = max(index, -(widget.candles.length - 1));
                            index = min(index, widget.candles.length - 1);
                          });
                        },
                        onPanDown: (double value) {
                          // last Committee's
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
                      ).onTap(() => widget.onTapUp);
                    } else {
                      return MobileChart(
                        style: style,
                        onRemoveIndicator: widget.onRemoveIndicator,
                        mainWindowDataContainer: mainWindowDataContainer!,
                        chartAdjust: widget.chartAdjust,
                        // onTapUp: widget.onTapUp,
                        onScaleUpdate: (double scale) {
                          scale = scale.clamp(0.9, 1.1);
                          updateCandleWidth(candleWidth * scale);
                        },
                        onPanEnd: () {
                          lastIndex = index;
                        },
                        onHorizontalDragUpdate: (double x) {
                          setState(() {
                            x = x - lastX;
                            index =
                                lastIndex + (x ~/ (candleWidth * widget.scale));
                            index = max(index, -(widget.candles.length - 1));
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
                      ).onTap(() => widget.onTapUp);
                    }
                  },
                ),
                if (isCallingLoadMore)
                  const Positioned(
                    bottom: 10,
                    right: 10,
                    child: Loading(),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant Candlesticks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.candles.isEmpty) {
      return;
    }
    if (mainWindowDataContainer == null) {
      mainWindowDataContainer =
          MainWindowDataContainer(widget.indicators ?? [], widget.candles);
    } else {
      final currentIndicators = widget.indicators ?? [];
      final oldIndicators = oldWidget.indicators ?? [];
      if (currentIndicators.length != oldIndicators.length ||
          currentIndicators
              .asMap()
              .entries
              .any((entry) => entry.value != oldIndicators[entry.key])) {
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
  void initState() {
    super.initState();
    if (widget.candles.isNotEmpty) {
      mainWindowDataContainer =
          MainWindowDataContainer(widget.indicators ?? [], widget.candles);
    }
  }
}
