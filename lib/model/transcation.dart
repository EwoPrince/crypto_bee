import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  Transaction({
    required this.transactionId,
    this.title,
    this.receiver_uid,
    this.BTC,
    this.ETH,
    this.DOGE,
    this.SOL,
    this.BNB,
    this.withdraw,
    this.processing,
    this.address,
    this.trade,
    required this.date,
  });

  final String transactionId;
  String? title;
  String? receiver_uid;
  double? BTC;
  double? ETH;
  double? DOGE;
  double? SOL;
  double? BNB;
  bool? withdraw;
  bool? processing;
  bool? trade;
  String? address;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'title': title,
      'receiver_uid': receiver_uid,
      'BTC': BTC,
      'ETH': ETH,
      'DOGE': DOGE,
      'SOL': SOL,
      'BNB': BNB,
      'processing': processing,
      'withdraw': withdraw,
      'trade': trade,
      'address': address,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transactionId'] ?? map['transactionId'] ?? '',
      title: map['title'] ?? '',
      receiver_uid: map['receiver_uid'] ?? '',
      BTC: map['BTC']?.toDouble() ?? 0.0,
      ETH: map['ETH']?.toDouble() ?? 0.0,
      DOGE: map['DOGE']?.toDouble() ?? 0.0,
      SOL: map['SOL']?.toDouble() ?? 0.0,
      BNB: map['BNB']?.toDouble() ?? 0.0,
      processing: map['processing'] ?? false,
      withdraw: map['withdraw'] ?? false,
      trade: map['trade'] ?? false,
      address: map['address'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
