import 'dart:async';
import 'dart:convert';
import 'package:crypto_bee/candlestick/models/candle.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';

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
  final Logger _logger = Logger();
  final http.Client _client = http.Client();

  WebSocketChannel? _channel;

  /// Establishes a WebSocket connection to Kraken for real-time updates.
  WebSocketChannel establishConnection(String pair) {
    _channel?.sink.close(); // Close any existing connections
    final channel = WebSocketChannel.connect(Uri.parse(_websocketUrl));

    _channel = channel;
    _subscribeToTicker(channel, pair);
    _handleWebSocketEvents(channel);

    return channel;
  }

  void _subscribeToTicker(WebSocketChannel channel, String pair) {
    channel.sink.add(jsonEncode({
      "event": "subscribe",
      "pair": [pair],
      "subscription": {"name": "ticker"},
    }));
  }

  void _handleWebSocketEvents(WebSocketChannel channel) {
    channel.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          if (data is List && data.length > 1) {
            _logger.i("Received Ticker Data: ${data[1]}");
          } else if (data is Map && data['event'] == 'subscriptionStatus') {
            _logger.i("Subscription status: ${data['status']}");
          }
        } on FormatException catch (e) {
          _logger.e('Error parsing JSON: $e, Message: $message');
        } catch (e) {
          _logger.e("An unexpected error has occurred: $e, Message: $message");
        }
      },
      onError: (error) {
        _logger.e("WebSocket error: $error");
        _channel = null; // Reset _channel on error
      },
      onDone: () {
        _logger.i("WebSocket connection closed.");
        _channel = null; // Reset _channel on close
      },
    );
  }

  void closeConnection() {
    _channel?.sink.close();
    _channel = null;
    _client.close();
  }

  /// Fetches historical candle data (OHLC) from Kraken.
  Future<List<Candle>> fetchCandles({
    required String productId,
    required Interval interval,
  }) async {
    final uri = Uri.parse(
      "${_corsProxyUrl}${_restApiUrl}/OHLC?pair=$productId&interval=${interval.value}",
    );
    _logger.d('Fetching candles from URI: $uri');

    try {
      final res = await _client.get(uri);
      if (res.statusCode == 200) {
        return _parseCandles(res.body);
      } else {
        _logger.e(
            'Failed to fetch candles: ${res.statusCode}, Message: ${res.body}');
        throw FetchDataException("Failed to fetch candles: ${res.statusCode}");
      }
    } catch (e) {
      _logger.e("Exception when fetching candles: $e");
      rethrow;
    }
  }

  List<Candle> _parseCandles(String body) {
    try {
      final data = jsonDecode(body);
      _validateResponse(data);

      final result = data['result'] as Map<String, dynamic>;
      final pairKey = result.keys.first;
      final ohlcData = result[pairKey] as List<dynamic>;

      return ohlcData
          .map((entry) => Candle(
                date: DateTime.fromMillisecondsSinceEpoch(entry[0] * 1000,
                    isUtc: true),
                open: double.parse(entry[1].toString()),
                high: double.parse(entry[2].toString()),
                low: double.parse(entry[3].toString()),
                close: double.parse(entry[4].toString()),
                volume: double.parse(entry[6].toString()),
              ))
          .toList()
          .reversed
          .toList();
    } on FormatException catch (e) {
      _logger.e("Error parsing JSON: $e, Message: $body");
      throw InvalidResponseException("Invalid JSON data received", body);
    } catch (e) {
      _logger.e("An unexpected error occurred when parsing candles: $e");
      throw InvalidResponseException(
          "An unexpected error occurred when parsing candles");
    }
  }

  void _validateResponse(Map<String, dynamic> data) {
    if (data.containsKey('error') && (data['error'] as List).isNotEmpty) {
      throw InvalidResponseException(
          "Kraken API returned an error: ${data['error']}", data);
    }
    if (!data.containsKey('result') || data['result'] == null) {
      throw InvalidResponseException(
          "Response does not contain 'result' key.", data);
    }
    if (data['result'] is! Map<String, dynamic>) {
      throw InvalidResponseException(
          "data['result'] is not a Map, Response data: ${data['result']}",
          data);
    }
    if ((data['result'] as Map).isEmpty) {
      throw InvalidResponseException("Response result map is empty", data);
    }
  }

  Future<double> getCryptoPrice(String coinId) async {
    final apiUrl =
        'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=usd';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey(coinId) &&
            jsonData[coinId].containsKey('usd')) {
          return jsonData[coinId]['usd'].toDouble();
        } else {
          throw Exception('USD price not found for $coinId');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow; // Re-throw the exception to be handled upstream if needed
    }
  }
}
