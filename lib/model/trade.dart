class Trade {
  Trade({
    required this.TradeId,
    this.receiver_username,
    this.receiver_uid,
    this.receiver_pic,
    this.BTC,
    this.ETH,
    this.DOGE,
    this.SOL,
    this.take_profit,
    this.stop_loss,
    this.withdraw,
    this.sell,
    required this.date,
    this.margin,
    this.leverage,
    this.force_stop,
  });

  final String TradeId;
  String? receiver_username;
  String? receiver_uid;
  String? receiver_pic;
  double? BTC;
  double? ETH;
  double? DOGE;
  double? SOL;
  double? take_profit;
  double? stop_loss;
  bool? withdraw;
  bool? sell;
  final DateTime date;
  double? margin;
  double? leverage;
  double? force_stop;

  Map<String, dynamic> toMap() {
    return {
      'TradeId': TradeId,
      'receiver_username': receiver_username,
      'receiver_uid': receiver_uid,
      'receiver_pic': receiver_pic,
      'BTC': BTC,
      'ETH': ETH,
      'DOGE': DOGE,
      'SOL': SOL,
      'take_profit': take_profit,
      'stop_loss': stop_loss,
      'withdraw': withdraw,
      'sell': sell,
      'date': date,
      'margin': margin,
      'leverage': leverage,
      'force_stop': force_stop,
    };
  }

  factory Trade.fromMap(
    Map<String, dynamic> map,
  ) {
    return Trade(
      TradeId: map['TradeId'],
      receiver_username: map['receiver_username'] ?? '',
      receiver_uid: map['receiver_uid'] ?? '',
      receiver_pic: map['receiver_pic'] ?? '',
      BTC: map['BTC'] ?? 0,
      ETH: map['ETH'] ?? 0,
      DOGE: map['DOGE'] ?? 0,
      SOL: map['SOL'] ?? 0,
      take_profit: map['take_profit'] ?? 0,
      stop_loss: map['stop_loss'] ?? 0,
      withdraw: map['withdraw'] ?? false,
      sell: map['sell'] ?? false,
      date: map['date'].toDate(),
      margin: map['margin'] ?? 0,
      leverage: map['leverage'] ?? 0,
      force_stop: map['force_stop'] ?? 0,
    );
  }
}
