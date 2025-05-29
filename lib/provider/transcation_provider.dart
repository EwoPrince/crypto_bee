import 'dart:async';
import 'dart:math';
import 'package:crypto_beam/model/trade.dart';
import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:flutter/material.dart';
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
      _transactionSubscription = dataStream.listen((data) {
        _transactions = data;
        notifyListeners();
      }, onError: (e) {});
    } catch (e) {}
  }

  Future<void> fetchTrades(String uid) async {
    _tradeSubscription?.cancel();
    try {
      final Stream<List<Trade>> dataStream =
          TransferService.getTradeStream(uid);
      _tradeSubscription = dataStream.listen((data) {
        _trade = data;
        notifyListeners();
      }, onError: (e) {});
    } catch (e) {}
  }

  


  void _startPnlUpdates() {
    _pnlTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updatePnl();
    });
  }

  void _updatePnl() {
    double change = (_random.nextDouble() - 0.5) * 10;
    _apnl = _calculatePnl();
    _pnl = max(_apnl + change, _apnl - change);
    notifyListeners();
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
        totalPnl +=
            trade.BTC! + trade.ETH! + trade.SOL! + trade.DOGE! - trade.margin!;
      }
    }
    return totalPnl;
  }
}
