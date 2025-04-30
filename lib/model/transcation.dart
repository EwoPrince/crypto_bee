class Transcation {
  Transcation({
    required this.transcationId,
    this.receiver_username,
    this.receiver_uid,
    this.receiver_pic,
    this.BTC,
    this.ETH,
    this.DOGE,
    this.SOL,
    this.BNB,
    this.withdraw,
    required this.date,
  });

  final String transcationId;
  String? receiver_username;
  String? receiver_uid;
  String? receiver_pic;
  double? BTC;
  double? ETH;
  double? DOGE;
  double? SOL;
  double? BNB;
  bool? withdraw;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'transcationId': transcationId,
      'receiver_username': receiver_username,
      'receiver_uid': receiver_uid,
      'receiver_pic': receiver_pic,
      'BTC': BTC,
      'ETH': ETH,
      'DOGE': DOGE,
      'SOL': SOL,
      "BNB": BNB,
      'withdraw': withdraw,
      'date': date,
    };
  }

  factory Transcation.fromMap(
    Map<String, dynamic> map,
  ) {
    return Transcation(
      transcationId: map['transcationId'],
      receiver_username: map['receiver_username'] ?? '',
      receiver_uid: map['receiver_uid'] ?? '',
      receiver_pic: map['receiver_pic'] ?? '',
      BTC: map['BTC'] ?? 0,
      ETH: map['ETH'] ?? 0,
      DOGE: map['DOGE'] ?? 0,
      SOL: map['SOL'] ?? 0,
      BNB: map['BNB'] ?? 0,
      withdraw: map['withdraw'] ?? false,
      date: map['date'].toDate(),
    );
  }
}
