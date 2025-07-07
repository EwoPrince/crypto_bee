import 'dart:async';
import 'dart:convert';
import 'package:crypto_beam/candlestick/models/candle.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import 'package:crypto_beam/view/stake/stake.dart';

class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);
  @override
  String toString() => 'FetchDataException: $message';
}

class InvalidResponseException implements Exception {
  final String message;
  final dynamic data;
  InvalidResponseException(this.message, [this.data]);
  @override
  String toString() => 'InvalidResponseException: $message. Data: $data';
}

class KrakenRepository {
  final String _corsProxyUrl = "https://api.allorigins.win/raw?url=";
  final String _restApiUrl = "https://api.kraken.com/0/public";
  final String _websocketUrl = "wss://ws.kraken.com/";
  static final Logger _logger = Logger();
  final http.Client _client = http.Client();
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  String? _currentPair;
  static const _reconnectDelay = Duration(seconds: 5);
  static const _maxReconnectAttempts = 5;
  static const _rateLimitRetryDelay = Duration(seconds: 30);
  static const _maxRetryAttempts = 3;
  int _reconnectAttempts = 0;
  int _retryAttempts = 0;

  WebSocketChannel establishConnection(String pair, {Function(String)? onError}) {
    _channel?.sink.close();
    _reconnectAttempts = 0;
    _currentPair = pair;
    final channel = WebSocketChannel.connect(Uri.parse(_websocketUrl));
    _channel = channel;
    _subscribeToTicker(channel, pair);
    _handleWebSocketEvents(channel, onError: onError);
    return channel;
  }

  void _subscribeToTicker(WebSocketChannel channel, String pair) {
    channel.sink.add(jsonEncode({
      "event": "subscribe",
      "pair": [pair],
      "subscription": {"name": "ticker"},
    }));
    _logger.i("Subscribed to ticker for pair: $pair");
  }

  void _handleWebSocketEvents(WebSocketChannel channel, {Function(String)? onError}) {
    channel.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          if (data is Map && data['event'] == 'subscriptionStatus') {
            _logger.i("Subscription status for pair $_currentPair: ${data['status']}");
            if (data['status'] == 'error') {
              final errorMessage = "WebSocket subscription failed: ${data['errorMessage']}";
              onError?.call(errorMessage);
              throw FetchDataException(errorMessage);
            }
          } else if (data is List && data.length > 1 && data[1] is Map) {
            final tickerData = data[1] as Map<String, dynamic>;
            if (tickerData.containsKey('c') && tickerData.containsKey('v')) {
              _logger.i("Received Ticker Data for pair $_currentPair: $tickerData");
            } else {
              _logger.w("Invalid ticker data format for pair $_currentPair: $tickerData");
            }
          } else {
            _logger.w("Unexpected WebSocket message format for pair $_currentPair: $data");
          }
        } catch (e) {
          _logger.e("Error parsing WebSocket message for pair $_currentPair: $e, Message: $message");
          onError?.call("Error parsing WebSocket message: $e");
        }
      },
      onError: (error) {
        _logger.e("WebSocket error for pair $_currentPair: $error");
        _channel = null;
        onError?.call("WebSocket error: $error");
        _attemptReconnect();
      },
      onDone: () {
        _logger.i("WebSocket connection closed for pair $_currentPair.");
        _channel = null;
        onError?.call("WebSocket connection closed.");
        _attemptReconnect();
      },
    );
  }

  void _attemptReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.e("Max reconnect attempts reached for pair $_currentPair.");
      return;
    }
    _reconnectAttempts++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay * _reconnectAttempts, () {
      _logger.i("Attempting WebSocket reconnect ($_reconnectAttempts/$_maxReconnectAttempts) for pair $_currentPair");
      if (_currentPair != null) {
        establishConnection(_currentPair!, onError: (error) {
          _logger.e("Reconnect error: $error");
        });
      }
    });
  }

  void closeConnection() {
    _channel?.sink.close();
    _channel = null;
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;
    _currentPair = null;
    _logger.i("Closed WebSocket connection.");
  }

  void dispose() {
    closeConnection();
    _client.close();
    _logger.i("KrakenRepository disposed.");
  }

  Future<List<Candle>> fetchCandles({
    required String productId,
    required Interval interval,
  }) async {
    final uri = Uri.parse(
      "${_corsProxyUrl}${_restApiUrl}/OHLC?pair=$productId&interval=${interval.value}",
    );
    _logger.d('Fetching candles for pair: $productId, interval: ${interval.value} from URI: $uri');

    try {
      final res = await _client.get(uri);
      if (res.statusCode == 200) {
        _retryAttempts = 0;
        return await _parseCandles(res.body);
      } else if (res.statusCode == 429) {
        if (_retryAttempts >= _maxRetryAttempts) {
          throw FetchDataException("Rate limit exceeded after max retries.");
        }
        _retryAttempts++;
        _logger.w("Rate limit exceeded for pair $productId. Retrying in ${_rateLimitRetryDelay.inSeconds} seconds...");
        await Future.delayed(_rateLimitRetryDelay);
        return fetchCandles(productId: productId, interval: interval);
      } else {
        throw FetchDataException("Failed to fetch candles for pair $productId: ${res.statusCode}");
      }
    } catch (e) {
      _logger.e("Exception when fetching candles for pair $productId: $e");
      rethrow;
    }
  }

  Future<List<Candle>> _parseCandles(String body) async {
    int retryCount = 0;
    const maxRetries = 3;
    while (retryCount < maxRetries) {
      try {
        final data = jsonDecode(body);
        _validateResponse(data);

        final result = data['result'] as Map<String, dynamic>;
        final pairKey = result.keys.firstWhere((key) => key != 'last', orElse: () {
          throw InvalidResponseException("No valid pair key found in response", data);
        });
        final ohlcData = result[pairKey] as List<dynamic>;

        final candles = ohlcData
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final item = entry.value;
              if (item is! List || item.length < 7) {
                throw InvalidResponseException("Invalid candle data format at index $index", item);
              }
              if (item[0] is! int) {
                throw InvalidResponseException("Invalid timestamp format at index $index", item);
              }
              return Candle(
                date: DateTime.fromMillisecondsSinceEpoch(item[0] * 1000, isUtc: true),
                open: double.parse(item[1].toString()),
                high: double.parse(item[2].toString()),
                low: double.parse(item[3].toString()),
                close: double.parse(item[4].toString()),
                volume: double.parse(item[6].toString()),
                // index: index,
              );
            })
            .toList()
            .reversed
            .toList();

        if (candles.isEmpty) {
          throw InvalidResponseException("No candles parsed from response", body);
        }
        return candles;
      } catch (e) {
        retryCount++;
        _logger.e("Error parsing candle data (attempt $retryCount/$maxRetries): $e");
        if (retryCount >= maxRetries) {
          throw InvalidResponseException("Error parsing candle data after $maxRetries retries", body);
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    return [];
  }

  void _validateResponse(Map<String, dynamic> data) {
    if (data.containsKey('error') && (data['error'] as List).isNotEmpty) {
      throw InvalidResponseException("Kraken API returned error: ${data['error']}", data);
    }
    if (!data.containsKey('result') || data['result'] == null) {
      throw InvalidResponseException("Missing 'result' key", data);
    }
  }

  Future<List<String>> fetchTradingPairs() async {
    final uri = Uri.parse("${_corsProxyUrl}${_restApiUrl}/AssetPairs");
    _logger.d('Fetching trading pairs from URI: $uri');

    try {
      final res = await _client.get(uri);
      if (res.statusCode == 200) {
        _retryAttempts = 0;
        final data = jsonDecode(res.body);
        _validateResponse(data);
        final result = data['result'] as Map<String, dynamic>;
        return result.keys.where((key) => key != 'last').toList();
      } else if (res.statusCode == 429) {
        if (_retryAttempts >= _maxRetryAttempts) {
          throw FetchDataException("Rate limit exceeded after max retries.");
        }
        _retryAttempts++;
        _logger.w("Rate limit exceeded for trading pairs. Retrying in ${_rateLimitRetryDelay.inSeconds} seconds...");
        await Future.delayed(_rateLimitRetryDelay);
        return fetchTradingPairs();
      } else {
        throw FetchDataException("Failed to fetch trading pairs: ${res.statusCode}, Response: ${res.body}");
      }
    } catch (e) {
      _logger.e("Exception when fetching trading pairs: $e, URI: $uri");
      rethrow;
    }
  }

  Future<(Map<String, double>, Map<String, double>)> getCryptoPriceChanges(List<String> coinIds) async {
    final ids = coinIds.join(',');
    final apiUrl = 'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true';
    _logger.d('Fetching price changes for coins: $ids from URI: $apiUrl');

    try {
      final response = await _client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        Map<String, double> changes = {};
        Map<String, double> prices = {};

        for (var id in coinIds) {
          changes[id] = jsonData[id]?['usd_24h_change']?.toDouble() ?? 0.0;
          prices[id] = jsonData[id]?['usd']?.toDouble() ?? 0.0;
        }
        return (changes, prices);
      } else {
        throw FetchDataException("Failed to load price changes from CoinGecko: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e('Error fetching price changes from CoinGecko: $e');
      rethrow;
    }
  }
}