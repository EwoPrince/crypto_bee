/// Candle model which holds a single candle data.
/// It contains five required double variables that hold a single candle data: high, low, open, close, and volume.
/// It can be instantiated using its default constructor or fromJson named constructor.
class Candle {
  /// DateTime for the candle
  final DateTime date;

  /// The highest price during this candle lifetime.
  /// It is always more than or equal to low, open, and close.
  final double high;

  /// The lowest price during this candle lifetime.
  /// It is always less than or equal to high, open, and close.
  final double low;

  /// Price at the beginning of the period.
  final double open;

  /// Price at the end of the period.
  final double close;

  /// Volume is the number of shares of a security traded during a given period of time.
  final double volume;

  /// A boolean to tell if the candle is bull (price increasing) or bear (price decreasing).
  bool get isBull => open <= close;

  /// Default Constructor for creating a candle model
  Candle({
    required this.date,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
  });

  /// Factory Constructor for creating a candle model from a List of dynamic
  factory Candle.fromJson(List<dynamic> json) {
    if (json.length < 6) {
      throw const FormatException(
        'Invalid JSON format. Must contain at least 6 elements.',
      );
    }

    final date = json[0] is int ?
        DateTime.fromMillisecondsSinceEpoch(json[0]) : DateTime.tryParse(json[0]);
    final open = double.tryParse(json[1].toString());
    final high = double.tryParse(json[2].toString());
    final low = double.tryParse(json[3].toString());
    final close = double.tryParse(json[4].toString());
    final volume = double.tryParse(json[5].toString());

    if (date == null || open == null || high == null || low == null || close == null || volume == null) {
       throw const FormatException("Error on parsing candle data");
    }
    return Candle(
      date: date,
      high: high,
      low: low,
      open: open,
      close: close,
      volume: volume,
    );
  }

  Candle copyWith({
    DateTime? date,
    double? open,
    double? high,
    double? low,
    double? close,
     double? volume,
  }) {
    return Candle(
      date: date ?? this.date,
      high: high ?? this.high,
      low: low ?? this.low,
      open: open ?? this.open,
      close: close ?? this.close,
      volume: volume ?? this.volume
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Candle &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          high == other.high &&
          low == other.low &&
          open == other.open &&
          close == other.close &&
          volume == other.volume;

  @override
  int get hashCode =>
      date.hashCode ^
      open.hashCode ^
      high.hashCode ^
      low.hashCode ^
      close.hashCode ^
    volume.hashCode;
}