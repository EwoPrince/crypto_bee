
class AssetPairModel {
  final String altname;
  final String wsname;
  final String aclassBase;
  final String base;
  final String aclassQuote;
  final String quote;
  final String lot;
  final int costDecimals;
  final int pairDecimals;
  final int lotDecimals;
  final int lotMultiplier;
  final List<int> leverageBuy;
  final List<int> leverageSell;
  final List<List<double>> fees;
  final List<List<double>> feesMaker;
  final String feeVolumeCurrency;
  final int marginCall;
  final int marginStop;
  final String ordermin;
  final String costmin;
  final String tickSize;
  final String status;
  final int longPositionLimit;
  final int shortPositionLimit;

  AssetPairModel(
      {required this.altname,
      required this.wsname,
      required this.aclassBase,
      required this.base,
      required this.aclassQuote,
      required this.quote,
      required this.lot,
      required this.costDecimals,
      required this.pairDecimals,
      required this.lotDecimals,
      required this.lotMultiplier,
      required this.leverageBuy,
      required this.leverageSell,
      required this.fees,
      required this.feesMaker,
      required this.feeVolumeCurrency,
      required this.marginCall,
      required this.marginStop,
      required this.ordermin,
      required this.costmin,
      required this.tickSize,
      required this.status,
      required this.longPositionLimit,
      required this.shortPositionLimit});
  factory AssetPairModel.fromJson(Map<String, dynamic> json) {
    final leverageBuy = json['leverage_buy'] is List
        ? (json['leverage_buy'] as List).map((item) => item as int).toList()
        : <int>[];
    final leverageSell = json['leverage_sell'] is List
        ? (json['leverage_sell'] as List).map((item) => item as int).toList()
        : <int>[];
    final fees = json['fees'] is List
        ? (json['fees'] as List)
            .map((item) => (item as List)
                .map((e) => double.tryParse(e.toString()) ?? 0.0)
                .toList())
            .toList()
        : <List<double>>[];
    final feesMaker = json['fees_maker'] is List
        ? (json['fees_maker'] as List)
            .map((item) => (item as List)
                .map((e) => double.tryParse(e.toString()) ?? 0.0)
                .toList())
            .toList()
        : <List<double>>[];
    return AssetPairModel(
      altname: json['altname'],
      wsname: json['wsname'],
      aclassBase: json['aclass_base'],
      base: json['base'],
      aclassQuote: json['aclass_quote'],
      quote: json['quote'],
      lot: json['lot'],
      costDecimals: json['cost_decimals'],
      pairDecimals: json['pair_decimals'],
      lotDecimals: json['lot_decimals'],
      lotMultiplier: json['lot_multiplier'],
      leverageBuy: leverageBuy,
      leverageSell: leverageSell,
      fees: fees,
      feesMaker: feesMaker,
      feeVolumeCurrency: json['fee_volume_currency'],
      marginCall: json['margin_call'],
      marginStop: json['margin_stop'],
      ordermin: json['ordermin'],
      costmin: json['costmin'],
      tickSize: json['tick_size'],
      status: json['status'],
      longPositionLimit: json['long_position_limit'] is int
          ? json['long_position_limit']
          : int.tryParse(json['long_position_limit'].toString()) ?? 0,
      shortPositionLimit: json['short_position_limit'] is int
          ? json['short_position_limit']
          : int.tryParse(json['short_position_limit'].toString()) ?? 0,
    );
  }
}
