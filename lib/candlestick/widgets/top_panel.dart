import 'package:crypto_beam/candlestick/widgets/toolbar_action.dart';
import 'package:flutter/material.dart';
import '../models/candle.dart';
import '../models/candle_sticks_style.dart';
import '../models/indicator.dart';
import '../widgets/candle_info_text.dart';

class TopPanel extends StatefulWidget {
  final Candle? currentCandle;
  final List<Indicator> indicators;
  final void Function(String indicatorName) toggleIndicatorVisibility;
  final List<String> unvisibleIndicators;
  final void Function(String indicatorName)? onRemoveIndicator;
  final CandleSticksStyle style;

  const TopPanel({
    Key? key,
    required this.currentCandle,
    required this.indicators,
    required this.toggleIndicatorVisibility,
    required this.unvisibleIndicators,
    required this.onRemoveIndicator,
    required this.style,
  }) : super(key: key);

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  bool showIndicatorNames = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chart top panel',
      child: DefaultTextStyle(
        style: TextStyle(color: widget.style.primaryTextColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: widget.currentCandle != null
                  ? CandleInfoText(
                      candle: widget.currentCandle!,
                      bullColor: widget.style.primaryBull,
                      bearColor: widget.style.primaryBear,
                      defaultStyle: TextStyle(
                          color: widget.style.borderColor, fontSize: 10),
                      // indicators: widget.indicators
                      //     .where((e) => !widget.unvisibleIndicators.contains(e.name))
                      //     .map((e) => IndicatorValue(
                      //         e.name,
                      //         e.values[widget.currentCandle!.index] ?? 0))
                      //     .toList(),
                    )
                  : Container(),
            ),
            if (showIndicatorNames)
              SingleChildScrollView(
                child: Column(
                  children: widget.indicators
                      .map(
                        (e) => ToolBarAction(
                          width: 120,
                          height: 30,
                          onPressed: () => widget.toggleIndicatorVisibility(e.name),
                          semanticsLabel: 'Toggle ${e.name} visibility',
                          color: widget.unvisibleIndicators.contains(e.name)
                              ? widget.style.background
                              : widget.style.borderColor,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.name),
                              const SizedBox(width: 10),
                              Icon(
                                widget.unvisibleIndicators.contains(e.name)
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 16,
                                color: widget.style.primaryTextColor,
                              ),
                              const SizedBox(width: 10),
                              if (widget.onRemoveIndicator != null)
                                GestureDetector(
                                  onTap: () => widget.onRemoveIndicator!(e.name),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: widget.style.primaryTextColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            if (widget.indicators.length > 1)
              ToolBarAction(
                width: 60,
                height: 30,
                onPressed: () {
                  setState(() {
                    showIndicatorNames = !showIndicatorNames;
                  });
                },
                semanticsLabel: 'Toggle indicator list',
                color: widget.style.borderColor.withOpacity(0.2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      showIndicatorNames
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: widget.style.primaryTextColor,
                    ),
                    Text(widget.indicators.length.toString()),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}