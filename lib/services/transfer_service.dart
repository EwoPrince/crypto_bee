import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_bee/model/trade.dart';
import 'package:crypto_bee/model/transcation.dart';
import 'package:crypto_bee/model/user.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;

// Enum for symbol conversion
enum TradingSymbol {
  btcUsd,
  dogeUsd,
  solUsd,
  ethUsd,
}

extension TradingSymbolExtension on TradingSymbol {
  String get value {
    switch (this) {
      case TradingSymbol.btcUsd:
        return "BTC";
      case TradingSymbol.dogeUsd:
        return "DOGE";
      case TradingSymbol.solUsd:
        return "SOL";
      case TradingSymbol.ethUsd:
        return "ETH";
      default:
        return "";
    }
  }

  static TradingSymbol fromString(String symbol) {
    switch (symbol) {
      case 'BTC/USD':
      case 'XBTUSD':
        return TradingSymbol.btcUsd;
      case 'XDGUSD':
        return TradingSymbol.dogeUsd;
      case 'SOL/USD':
        return TradingSymbol.solUsd;
      case 'ETH/USD':
        return TradingSymbol.ethUsd;
      default:
        throw ArgumentError('Invalid trading symbol: $symbol');
    }
  }
}

/// A service for handling cryptocurrency trading and transactions.
class TransferService {
  // Constants for symbol conversion

  /// Retrieves a stream of transactions for a given user ID.
  static Stream<List<Transcation>> getTranscationStream(String uid) {
    return FirebaseFirestore.instance
        .collection('transcation')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transcation.fromMap(doc.data()))
            .where((transcation) => transcation.receiver_uid == uid)
            .toList());
  }

  /// Retrieves a stream of trades for a given user ID.
  static Stream<List<Trade>> getTradeStream(String uid) {
    return FirebaseFirestore.instance
        .collection('trade')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Trade.fromMap(doc.data()))
            .where((trade) => trade.receiver_uid == uid)
            .toList());
  }

  /// Initiates a margin trade.
  static Future<TradeResult> initiateMarginTrade(
    BuildContext context,
    User? user,
    double? tp,
    double? sl,
    double margin,
    String symbol,
    bool sell,
    double leverage,
  ) async {
    try {
      _validateMarginTrade(margin, user, context);

      final newSymbol = TradingSymbolExtension.fromString(symbol);
      // Calculate the total position size based on leverage
      double positionSize = margin * leverage;

      await _performMarginTrade(
        context,
        positionSize,
        margin,
        user,
        tp,
        sl,
        newSymbol.value,
        sell,
        leverage,
      );
      showMessage(context,
          'Trade placed successfully, observe at the trade history tab');
      return TradeResult(success: true);
    } catch (e) {
      showMessage(context, e.toString());
      return TradeResult(success: false, errorMessage: e.toString());
    }
  }

  static void _validateMarginTrade(
      double margin, User? user, BuildContext context) {
    if (margin > (user?.dollar ?? 0)) {
      throw 'Insufficient Funds for Margin';
    }
  }

  static Future<void> _performMarginTrade(
    BuildContext context,
    double positionSize,
    double margin,
    User? user,
    double? tp,
    double? sl,
    String symbol,
    bool sell,
    double leverage,
  ) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    try {
      // Deduct only the margin from the user's balance, not the full position size
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CurrentId)
          .update({
        'dollar': FieldValue.increment(-margin),
        if (symbol.isNotEmpty) symbol: FieldValue.increment(-margin),
      });
    } catch (e) {
      _handleError(context, 'Error in performMarginTrade: $e');
      throw "An error occurred while placing the trade. Please try again.";
    }

    await _saveTradeCollection(
      user,
      tp,
      sl,
      symbol,
      sell,
      margin,
      leverage,
      positionSize,
    );
  }

  static Future<void> _saveTradeCollection(
    User? user,
    double? tp,
    double? sl,
    String symbol,
    bool sell,
    double margin,
    double leverage,
    double positionSize,
  ) async {
    var tradeId = const Uuid().v1();
    var datePublished = DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('trade').doc(tradeId).set({
        "TradeId": tradeId,
        "receiver_username": user!.name,
        "receiver_uid": user.uid,
        "receiver_pic": user.photoUrl,
        symbol: positionSize,
        "take_profit": tp,
        "stop_loss": sl,
        "withdraw": false,
        "sell": sell,
        "date": datePublished,
        "margin": margin,
        "leverage": leverage,
      });
    } catch (e) {
      // showMessage(context, 'Error saving trade: $e');
      throw "An error occurred while placing the trade. Please try again.";
    }
  }

  static Future<TradeResult> EndTrade(
    BuildContext context,
    double? amount,
    double? stopLoss,
    User? user,
    String symbol,
    String tradeid,
    DateTime date,
    double? force_stop,
  ) async {
    if (force_stop != 0) {
      await transferGain(force_stop!.toInt(), symbol);
      await _savehistoryCollection(force_stop, user, symbol, tradeid);
    } else {
      try {
        if (stopLoss != null) {
          await transferGain(stopLoss.toInt(), symbol);
          await _savehistoryCollection(stopLoss, user, symbol, tradeid);
        } else {
          await _savehistoryCollection(0, user, symbol, tradeid);
        }

        return TradeResult(success: true);
      } catch (e) {
        _handleError(context, 'Error ending trade: $e');
        return TradeResult(success: false, errorMessage: e.toString());
      }
    }
    _handleError(context, 'Error ending trade: ');
    return TradeResult(success: false, errorMessage: 'error');
  }

  /// Transfers gains back to the user's account.
  static Future<void> transferGain(int amount, String symbol) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CurrentId)
          .update({
        'dollar': FieldValue.increment(amount),
        if (symbol.isNotEmpty) symbol: FieldValue.increment(amount),
      });
    } catch (e) {
      print('Error transferring gain: $e');
      rethrow;
    }
  }

  /// Saves a trade completion to the 'trade' and 'transcation' collections in Firestore.
  static Future<void> _savehistoryCollection(
    double? amount,
    User? user,
    String symbol,
    String tradeid,
  ) async {
    var transcationId = const Uuid().v1();
    var datePublished = DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('trade').doc(tradeid).update({
        "withdraw": true,
        "date": datePublished,
        symbol: amount,
      });

      await FirebaseFirestore.instance
          .collection('transcation')
          .doc(transcationId)
          .set({
        "transcationId": transcationId,
        "receiver_username": user!.name,
        "receiver_uid": user.uid,
        "receiver_pic": user.photoUrl,
        symbol: amount,
        "withdraw": false,
        "date": datePublished,
      });
    } catch (e) {
      //  _handleError(context, 'Error saving history: $e');
      rethrow;
    }
  }

  static Function()? validatePrice(BuildContext context, String label,
      double price, String action, double currentPrice) {
    if (action == 'Buy' && price <= currentPrice) {
      return () => showMessage(context,
          "Price must be greater than the current price for buy orders");
    }
    if (action == 'Sell' && price >= currentPrice) {
      return () => showMessage(
          context, "Price must be less than the current price for sell orders");
    }
    return null;
  }

  static void _handleError(BuildContext context, String message) {
    // showMessage(context, message);
    print(message);
  }
}

class TradeResult {
  final bool success;
  final String? errorMessage;

  TradeResult({required this.success, this.errorMessage});
}
