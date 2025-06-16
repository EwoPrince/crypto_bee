import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:crypto_beam/model/trade.dart';
import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final transactionProvider = ChangeNotifierProvider<TransactionProviders>(
    (ref) => TransactionProviders());

class TransactionProviders extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Trade> _trade = [];
  double _pnl = 0;
  double _apnl = 0;
  Timer? _pnlTimer;
  final _random = Random();
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  StreamSubscription<List<Trade>>? _tradeSubscription;

  TransactionProviders() {
    _startPnlUpdates();
  }

  List<Transaction> get transactions => _transactions;
  List<Trade> get trade => _trade;

  double get pnl => _pnl;
  double get apnl => _apnl;

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    _tradeSubscription?.cancel();
    _pnlTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTransactions(String uid) async {
    _transactionSubscription?.cancel();
    try {
      final Stream<List<Transaction>> dataStream =
          TransferService.getTransactionStream(uid);
      _transactionSubscription = dataStream.listen(
        (data) {
          _transactions = data;
          notifyListeners();
        },
        onError: (e) {},
      );
    } catch (e) {}
  }

  Future<void> fetchTrades(String uid) async {
    _tradeSubscription?.cancel();
    try {
      final Stream<List<Trade>> dataStream =
          TransferService.getTradeStream(uid);
      _tradeSubscription = dataStream.listen(
        (data) {
          _trade = data;
          notifyListeners();
        },
        onError: (e) {},
      );
    } catch (e) {}
  }

  void _startPnlUpdates() {
    _pnlTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _updatePnl();
    });
  }

  void _updatePnl() async {
    double change = (_random.nextDouble() - 0.5) * 10;
    double calc = _calculatePnl();
    double digits = await _getDigits();
    _apnl = calc;
    _pnl =  change + digits;
    print(_pnl);
    notifyListeners();
  }

  Future<double> _getDigits() async {
    double number = 0;
    final userDoc = await f.FirebaseFirestore.instance
        .collection('extras')
        .doc('pnl')
        .get();
    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>;
      number = data['one'] ?? 0;
      print(number.toString());
    }
    notifyListeners();
    return number;
  }

  double _calculatePnl() {
    double totalPnl = 0;
    for (var trade in _trade) {
      if (trade.withdraw == false &&
          trade.margin != null &&
          trade.SOL != null &&
          trade.BTC != null &&
          trade.ETH != null &&
          trade.DOGE != null) {
        totalPnl += trade.margin!;
        print(totalPnl.toString());
      }
    }
    return totalPnl;
  }
}
