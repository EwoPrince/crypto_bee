import 'package:crypto_bee/candlestick/models/candle.dart';

class CandleTickerModel {
  final int eventTime;
  final String symbol;
  final Candle candle;

  const CandleTickerModel({
    required this.eventTime,
    required this.symbol,
    required this.candle,
  });

  factory CandleTickerModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('E') ||
        !json.containsKey('s') ||
        !json.containsKey('k') ||
        (json['k'] is! Map)) {
      throw FormatException(
          'Invalid JSON format. Missing keys: E, s, or k are missing or invalid.');
    }

    final candleData = json['k'] as Map<String, dynamic>;

    if (!candleData.containsKey('t') ||
        !candleData.containsKey('h') ||
        !candleData.containsKey('l') ||
        !candleData.containsKey('o') ||
        !candleData.containsKey('c') ||
        !candleData.containsKey('v')) {
      throw const FormatException("Candle data is missing or invalid");
    }

    final eventTime =
        json['E'] is int ? json['E'] : int.tryParse(json['E'].toString());
    final symbol = json['s'] as String;

    final high = double.tryParse(candleData["h"].toString());
    final low = double.tryParse(candleData["l"].toString());
    final open = double.tryParse(candleData["o"].toString());
    final close = double.tryParse(candleData["c"].toString());
    final volume = double.tryParse(candleData["v"].toString());

    if (eventTime == null) {
      throw const FormatException("Event time is invalid");
    }

    if (high == null ||
        low == null ||
        open == null ||
        close == null ||
        volume == null) {
      throw const FormatException("Candle data is missing or invalid");
    }

    return CandleTickerModel(
      eventTime: eventTime,
      symbol: symbol,
      candle: Candle(
        date: DateTime.fromMillisecondsSinceEpoch(candleData["t"] as int),
        high: high,
        low: low,
        open: open,
        close: close,
        volume: volume,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'E': eventTime,
      's': symbol,
      'k': {
        't': candle.date.millisecondsSinceEpoch,
        'h': candle.high,
        'l': candle.low,
        'o': candle.open,
        'c': candle.close,
        'v': candle.volume,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CandleTickerModel &&
          runtimeType == other.runtimeType &&
          eventTime == other.eventTime &&
          symbol == other.symbol &&
          candle == other.candle;

  @override
  int get hashCode => eventTime.hashCode ^ symbol.hashCode ^ candle.hashCode;
}
