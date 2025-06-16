import 'dart:async';
import 'dart:convert';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/stakeBS.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto_beam/candlestick/candlesticks.dart';
import 'package:crypto_beam/candlestick/models/candle.dart';
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

  // State variables for Zooming & Panning
  double _scale = 1.0;
  double _translateX = 0.0;
  Candle? _selectedCandle;
  bool _showCandleDetails = false;

  @override
  void dispose() {
    _channelSubscription?.cancel();
    _channel?.sink.close();
    _streamController.close();
    _streamController.stream.drain();
    repository.closeConnection();
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
      _selectedCandle = null;
      _showCandleDetails = false;
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
      setState(() {
        _isCandlesLoading = false;
      });
      _showErrorSnackBar('No candle data received');
    }
  }

  void _handleDataFetchingError(dynamic e) {
    debugPrint("Error fetching candles: $e");
    setState(() {
      _isCandlesLoading = false;
    });
    _showErrorSnackBar("Failed to load candles: $e");
  }

  Future<List<Candle>> _fetchCandles(String symbol, Interval interval) async {
    return await repository.fetchCandles(productId: symbol, interval: interval);
  }

  void _subscribeToTicker(String symbol) {
    try {
      _channel = repository.establishConnection(symbol);
      _channelSubscription = _channel?.stream.listen(
        _handleWebSocketMessage,
        onError: _handleWebSocketError,
        onDone: _handleWebSocketDone,
      );
    } catch (e) {
      _handleWebSocketError(e);
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      _streamController.add(decoded);
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
      _showErrorSnackBar("Error decoding WebSocket message: $e");
    }
  }

  void _handleWebSocketError(Object error) {
    debugPrint("WebSocket error: $error");
    _channel = null;
    _channelSubscription = null;
    setState(() {
      _isCandlesLoading = false;
    });
    _showErrorSnackBar("WebSocket error: $error");
  }

  void _handleWebSocketDone() {
    debugPrint("WebSocket connection closed.");
    _channel = null;
    _channelSubscription = null;
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
      setState(() => _isCandlesLoading = true);
      final data = await repository.fetchCandles(
        productId: currentSymbol,
        interval: currentInterval,
      );
      setState(() {
        if (candles.isNotEmpty && data.isNotEmpty && candles.last.date == data.first.date) {
          candles.removeLast();
        }
        candles.addAll(data);
        _isCandlesLoading = false;
      });
    } catch (e) {
      setState(() => _isCandlesLoading = false);
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

  void _showErrorSnackBar(String message) {} 
  // ScaffoldMessenger.of(context)
      // .showSnackBar(SnackBar(content: Text(message))
      // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
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
                      if (_channel == null && !_isCandlesLoading && candles.isEmpty)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Failed to connect to WebSocket'),
                              ElevatedButton(
                                onPressed: () => _subscribeToTicker(currentSymbol),
                                child: const Text('Retry Connection'),
                              ),
                            ],
                          ),
                        )
                      else if (candles.isEmpty && !_isCandlesLoading)
                        const Center(child: Text('No data available'))
                      else
                        Expanded(
                          child: Stack(
                            children: [
                              Candlesticks(
                                key: Key('$currentSymbol${currentInterval.toString()}'),
                                candles: candles,
                                onLoadMoreCandles: _loadMoreCandles,
                                scale: _scale,
                                translateX: _translateX,
                                onTapUp: _handleCandleTap,
                                actions: _buildToolbarActions(),
                              ),
                              if (_showCandleDetails && _selectedCandle != null)
                                _buildCandleDetailsView(context, _selectedCandle!),
                              if (_isCandlesLoading)
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
                },
              ),
      ),
    );
  }

  void _handleCandleTap(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final candleWidth = (6.0 * _scale).clamp(2.0, 20.0); // Sync with Candlesticks
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
        width: 120,
        onPressed: () => _showSymbolSelectionBottomSheet(context),
        child: Text(_formatSymbol(currentSymbol)),
      ),
      // ToolBarAction(
      //   width: 100,
      //   onPressed: () => _showIntervalSelectionBottomSheet(context),
      //   child: Text(currentInterval.toString().split('.').last),
      // ),
      ToolBarAction(
        width: 85,
        color: Colors.red,
        onPressed: () =>
            showStakeBottomSheet(context, currentSymbol, _currentPrice ?? 0, ),
        child: const Text('Sell'),
      ),
      ToolBarAction(
        width: 85,
        color: Color(0xFF26A69A),
        onPressed: () =>
            showStakeBottomSheet(context, currentSymbol, _currentPrice ?? 0, ),
        child: const Text('Buy'),
      ),
    ];
  }

  String _formatSymbol(String symbol) {
    if (symbol == 'XBTUSD') return "BTC/USD";
    if (symbol == 'XDGUSD') return "DOGE/USD";
    return symbol;
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
                  .toList(),
            ),
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
          child: Text(
            _formatSymbol(e),
            style: const TextStyle(color: Color(0xFFF0B90A)),
          ),
        ),
      ),
    );
  }

  // void _showIntervalSelectionBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) => Center(
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           width: 300,
  //           height: MediaQuery.of(context).size.height * 0.75,
  //           color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
  //           child: ListView(
  //             children: intervals
  //                 .map((e) => Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: SizedBox(
  //                         width: 70,
  //                         height: 40,
  //                         child: RawMaterialButton(
  //                           elevation: 0,
  //                           fillColor: const Color(0xFF494537),
  //                           onPressed: () {
  //                             _fetchCandlesAndSubscribe(currentSymbol, e);
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Text(
  //                             e.toString().split('.').last,
  //                             style: const TextStyle(color: Color(0xFFF0B90A)),
  //                           ),
  //                         ),
  //                       ),
  //                     ))
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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