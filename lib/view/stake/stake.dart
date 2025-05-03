import 'dart:async';
import 'dart:convert';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/stakeBS.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto_beam/candlestick/candlesticks.dart';
import 'package:crypto_beam/candlestick/models/candle.dart';
import 'package:crypto_beam/candlestick/models/indicator.dart';
import 'package:crypto_beam/candlestick/utils/indicators/bollinger_bands_indicator.dart';
import 'package:crypto_beam/candlestick/widgets/toolbar_action.dart';
import 'package:crypto_beam/states/repository.dart';

class Stake extends ConsumerStatefulWidget {
  final String? symbol;
  const Stake({this.symbol, super.key});
  static const routeName = '/stake';

  @override
  ConsumerState<Stake> createState() => _StakeState();
}

class _StakeState extends ConsumerState<Stake> {
  final KrakenRepository repository = KrakenRepository();
  List<Candle> candles = [];
  bool _isCandlesLoading = false;
  bool _isSymbolsLoading = true;
  Interval currentInterval = Interval.oneHour;
  final List<Interval> intervals = Interval.values;
  final List<String> symbols = [
    'XBTUSD',
    'ETH/USD',
    'XDGUSD',
    'SOL/USD',
  ];
  String currentSymbol = "XBTUSD";
  double? _currentPrice;

  WebSocketChannel? _channel;
  final StreamController<dynamic> _streamController =
      StreamController.broadcast();
  StreamSubscription? _channelSubscription;
  final List<Indicator> indicators = [
    BollingerBandsIndicator(
      length: 20,
      stdDev: 2,
      upperColor: const Color(0xFF2962FF),
      basisColor: const Color(0xFFFF6D00),
      lowerColor: const Color(0xFF2962FF),
    ),
  ];

  // State variables for Zooming & Panning
  double _scale = 1.0;
  double _translateX = 0.0;
  Candle? _selectedCandle;
  bool _showCandleDetails = false;

  @override
  void dispose() {
    _channelSubscription?.cancel();
    repository.closeConnection();
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
    _fetchInitialData();
  }

  void _initializeState() {
    setState(() {
      _isSymbolsLoading = true;
      currentSymbol = widget.symbol ?? "XBTUSD";
    });
  }

  Future<void> _fetchInitialData() async {
    await _fetchCandlesAndSubscribe(currentSymbol, currentInterval);
    setState(() => _isSymbolsLoading = false);
  }

  Future<void> _fetchCandlesAndSubscribe(
      String symbol, Interval interval) async {
    _cancelSubscription();
    _resetCandleState();
    try {
      final data = await _fetchCandles(symbol, interval);
      _updateCandleData(data, symbol, interval);
      _subscribeToTicker(symbol);
    } catch (e) {
      _handleDataFetchingError(e);
    }
  }

  void _resetCandleState() {
    setState(() {
      candles = [];
      _isCandlesLoading = true;
      _scale = 1.0;
      _translateX = 0.0;
    });
  }

  void _updateCandleData(List<Candle> data, String symbol, Interval interval) {
    if (data.isNotEmpty) {
      setState(() {
        candles = data;
        currentSymbol = symbol;
        currentInterval = interval;
        _currentPrice = candles.first.close;
        _isCandlesLoading = false;
      });
    } else {
      _showErrorSnackBar('Error: No candle data received');
    }
  }

  void _handleDataFetchingError(dynamic e) {
    debugPrint("Error fetching candles: $e");
    setState(() {
      _isCandlesLoading = false;
    });
    // _showErrorSnackBar("Error fetching candles: $e"); // Commented out to avoid spam
  }

  Future<List<Candle>> _fetchCandles(String symbol, Interval interval) async {
    return await repository.fetchCandles(productId: symbol, interval: interval);
  }

  void _subscribeToTicker(String symbol) {
    _channel = repository.establishConnection(symbol);
    _channelSubscription = _channel?.stream.listen(
      _handleWebSocketMessage,
      onError: _handleWebSocketError,
      onDone: _handleWebSocketDone,
    );
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      _streamController.add(decoded);
      // Update the current price here if the message includes price data
      if (decoded is List && decoded.length > 1) {
        final tickerData = decoded[1] as Map<String, dynamic>;
        final price = _tryParseDouble(tickerData['c']?.toString());
        if (price != null) {
          setState(() {
            _currentPrice = price;
          });
        }
      }
    } catch (e) {
      debugPrint("Error decoding WebSocket message: $e");
      _showErrorSnackBar("Error decoding websocket message: $e");
    }
  }

  void _handleWebSocketError(Object error) {
    _channel = null;
    debugPrint("WebSocket error: $error");
    _showErrorSnackBar("Error from websocket: $error");
    setState(() {
      _isCandlesLoading = false;
    });
  }

  void _handleWebSocketDone() {
    _channel = null;
    debugPrint("WebSocket connection closed.");
    setState(() {
      _isCandlesLoading = false;
    });
  }

  void _cancelSubscription() {
    _channelSubscription?.cancel();
    _channelSubscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  Future<void> _loadMoreCandles() async {
    try {
      final data = await repository.fetchCandles(
        productId: currentSymbol,
        interval: currentInterval,
      );
      setState(() {
        if (candles.isNotEmpty) {
          candles.removeLast(); // Avoid duplication
        }
        candles.addAll(data);
      });
    } catch (e) {
      _showErrorSnackBar("Error loading more candles: $e");
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<dynamic> snapshot) {
    if (candles.isEmpty ||
        !snapshot.hasData ||
        !(snapshot.data is List) ||
        snapshot.data.length <= 1) return;
    try {
      final tickerData = (snapshot.data as List)[1] as Map<String, dynamic>;
      final price = _tryParseDouble(tickerData['c']?.toString());
      if (price == null) return;

      final newCandle = _createNewCandle(price);
      setState(() => _updateCandleList(newCandle, price));
    } catch (e) {
      _handleStreamError(e);
    }
  }

  Candle _createNewCandle(double price) {
    final intervalInMilliseconds = currentInterval.value * 60000;
    final now = DateTime.now();
    final alignedTimestamp = now.millisecondsSinceEpoch -
        (now.millisecondsSinceEpoch % intervalInMilliseconds);
    return Candle(
      date: DateTime.fromMillisecondsSinceEpoch(alignedTimestamp),
      open: price,
      high: price,
      low: price,
      close: price,
      volume: 0,
    );
  }

  void _updateCandleList(Candle newCandle, double price) {
    if (candles.isNotEmpty &&
        candles[0].date.isAtSameMomentAs(newCandle.date)) {
      candles[0] = _updateExistingCandle(candles[0], price);
    } else {
      candles.insert(0, newCandle);
    }
  }

  Candle _updateExistingCandle(Candle existingCandle, double price) {
    return existingCandle.copyWith(
      close: price,
      high: price > existingCandle.high ? price : existingCandle.high,
      low: price < existingCandle.low ? price : existingCandle.low,
    );
  }

  void _handleStreamError(Object e) {
    _showErrorSnackBar("Error from stream: $e");
  }

  double? _tryParseDouble(String? value) =>
      value == null ? null : double.tryParse(value);

  void _showErrorSnackBar(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cryptobee Stake'),
      ),
      body: Center(
        child: _isSymbolsLoading
            ? Loading()
            : StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  updateCandlesFromSnapshot(snapshot);
                  return Column(
                    children: [
                      _TickerHeader(
                        currentSymbol: currentSymbol,
                        candles: candles,
                        onSymbolChange: () =>
                            _showSymbolSelectionBottomSheet(context),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      Expanded(
                        child: Stack(
                          children: [
                            _isCandlesLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Candlesticks(
                                    key: Key(
                                        '$currentSymbol${currentInterval.toString()}'),
                                    indicators: indicators,
                                    candles: candles,
                                    onLoadMoreCandles: _loadMoreCandles,
                                    onRemoveIndicator: (indicator) => setState(
                                        () => indicators.removeWhere(
                                            (i) => i.name == indicator)),
                                    scale: _scale,
                                    translateX: _translateX,
                                    actions: _buildToolbarActions(),
                                  ),
                            if (_showCandleDetails && _selectedCandle != null)
                              _buildCandleDetailsView(
                                  context, _selectedCandle!),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _handleCandleTap(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final candleWidth = 10.0 * _scale;
    final scrollStart = _translateX;

    for (int i = 0; i < candles.length; i++) {
      final candlePosition = (i * candleWidth) + scrollStart;
      if (localOffset.dx >= candlePosition &&
          localOffset.dx <= candlePosition + candleWidth) {
        setState(() {
          _selectedCandle = candles[i];
          _showCandleDetails = true;
        });
        break;
      }
    }
  }

  List<ToolBarAction> _buildToolbarActions() {
    return [
      ToolBarAction(
        width: 55,
        onPressed: () => _showIntervalSelectionDialog(context),
        child: FittedBox(child: Text(currentInterval.name)),
      ),
      ToolBarAction(
        width: 100,
        onPressed: () => _showSymbolSelectionBottomSheet(context),
        child: Text(_formatSymbol(currentSymbol)),
      ),
      ToolBarAction(
        width: 65,
        color: Colors.green,
        onPressed: () =>
            showStakeBottomSheet(context, currentSymbol, _currentPrice ?? 0, 0),
        child: const Text('Buy'),
      ),
      ToolBarAction(
        width: 65,
        color: Colors.red,
        onPressed: () =>
            showStakeBottomSheet(context, currentSymbol, _currentPrice ?? 0, 1),
        child: const Text('Sell'),
      ),
    ];
  }

  String _formatSymbol(String symbol) {
    if (symbol == 'XBTUSD') return "BTC/USD";
    if (symbol == 'XDGUSD') return "DOGE/USD";
    return symbol;
  }

  void _showIntervalSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 600,
          color: Theme.of(context).badgeTheme.backgroundColor,
          child: Wrap(
            children:
                intervals.map((e) => _buildIntervalButton(context, e)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildIntervalButton(BuildContext context, Interval e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        height: 40,
        child: RawMaterialButton(
          elevation: 0,
          fillColor: const Color(0xFF494537),
          onPressed: () {
            _fetchCandlesAndSubscribe(currentSymbol, e);
            Navigator.of(context).pop();
          },
          child: Text(e.name, style: const TextStyle(color: Color(0xFFF0B90A))),
        ),
      ),
    );
  }

  void _showSymbolSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height * 0.75,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            child: ListView(
                children: symbols
                    .map((e) => _buildSymbolButton(context, e))
                    .toList()),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolButton(BuildContext context, String e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 70,
        height: 40,
        child: RawMaterialButton(
          elevation: 0,
          fillColor: const Color(0xFF494537),
          onPressed: () {
            _fetchCandlesAndSubscribe(e, currentInterval);
            Navigator.of(context).pop();
          },
          child: Text(_formatSymbol(e),
              style: const TextStyle(color: Color(0xFFF0B90A))),
        ),
      ),
    );
  }

  Widget _buildCandleDetailsView(BuildContext context, Candle candle) {
    return Positioned(
      left: 0,
      right: 0,
      top: 100,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${candle.date}'),
                Text('Open: ${candle.open.toStringAsFixed(2)}'),
                Text('High: ${candle.high.toStringAsFixed(2)}'),
                Text('Low: ${candle.low.toStringAsFixed(2)}'),
                Text('Close: ${candle.close.toStringAsFixed(2)}'),
                Text('Volume: ${candle.volume}'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => setState(() {
                      _showCandleDetails = false;
                      _selectedCandle = null;
                    }),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TickerHeader extends StatelessWidget {
  final String currentSymbol;
  final List<Candle> candles;
  final VoidCallback onSymbolChange;

  const _TickerHeader({
    Key? key,
    required this.currentSymbol,
    required this.candles,
    required this.onSymbolChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onSymbolChange,
            child: Text(
              _formatSymbol(currentSymbol),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 20),
          _buildPriceInfo(),
          const SizedBox(width: 10),
          ..._buildTickerData(),
        ],
      ),
    );
  }

  String _formatSymbol(String symbol) {
    if (symbol == 'XBTUSD') return "BTCUSD";
    if (symbol == 'XDGUSD') return "DOGEUSD";
    return symbol;
  }

  Widget _buildPriceInfo() {
    if (candles.isEmpty) {
      return const Text("0.00",
          style: TextStyle(fontSize: 15, color: Colors.grey));
    }
    final closePrice = candles.first.close;
    final lastClosePrice = candles.length > 1 ? candles[1].close : closePrice;

    print(closePrice);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          closePrice.toStringAsFixed(2),
          style: TextStyle(
              fontSize: 15,
              color: closePrice > lastClosePrice ? Colors.green : Colors.red),
        ),
        const SizedBox(height: 5),
        Text("\$${closePrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<Widget> _buildTickerData() {
    if (candles.isEmpty) {
      return List.generate(5, (_) => _TickerData(title: "", value: "0.00"));
    }
    final candle = candles.first;
    return [
      _TickerData(title: "Open", value: candle.open.toStringAsFixed(2)),
      _TickerData(title: "Close", value: candle.close.toStringAsFixed(2)),
      _TickerData(title: "High", value: candle.high.toStringAsFixed(2)),
      _TickerData(title: "Low", value: candle.low.toStringAsFixed(2)),
      _TickerData(
          title: "Change",
          value: (candle.close - candle.open).toStringAsFixed(2)),
    ];
  }
}

class _TickerData extends StatelessWidget {
  final String title;
  final String value;

  const _TickerData({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}

enum Interval {
  oneMinute,
  fiveMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  fourHours,
  oneDay,
  oneWeek,
  fifteenDays,
}

extension IntervalExtension on Interval {
  int get value {
    switch (this) {
      case Interval.oneMinute:
        return 1;
      case Interval.fiveMinutes:
        return 5;
      case Interval.fifteenMinutes:
        return 15;
      case Interval.thirtyMinutes:
        return 30;
      case Interval.oneHour:
        return 60;
      case Interval.fourHours:
        return 240;
      case Interval.oneDay:
        return 1440;
      case Interval.oneWeek:
        return 10080;
      case Interval.fifteenDays:
        return 21600;
      default:
        return 1;
    }
  }
}
