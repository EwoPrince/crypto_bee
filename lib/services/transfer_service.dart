import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_beam/model/trade.dart';
import 'package:crypto_beam/model/transcation.dart' as t;
import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/states/repository.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;

// Utility class for symbol mapping and price handling
class SymbolUtils {
  // Map Kraken symbols to display names (aligned with candlestick chart)
  static const Map<String, String> _symbolMap = {
    'XBTUSD': 'BTC',
    'XDGUSD': 'DOGE',
    'SOLUSD': 'SOL',
    'ETHUSD': 'ETH',
    'BNBUSD': 'BNB',
  };

  // Maximum leverage per symbol (based on typical Kraken limits)
  static const Map<String, double> _maxLeverage = {
    'BTC': 2.0,
    'ETH': 3.0,
    'DOGE': 6.0,
    'SOL': 5.0,
    'BNB': 3.0,
  };

  static String getValueForSymbol(String krakenSymbol) {
    return _symbolMap[krakenSymbol] ?? krakenSymbol.replaceAll('USD', '');
  }

  static String getKrakenSymbol(String symbol) {
    return _symbolMap.entries
        .firstWhere(
          (entry) => entry.value == symbol,
          orElse: () => MapEntry(symbol, symbol),
        )
        .key;
  }

  static double getMaxLeverage(String symbol) {
    return _maxLeverage[symbol] ?? 5.0;
  }

  static double getPriceForSymbol(
    String symbol,
    Map<String, double> prices,
  ) {
    final krakenSymbol = getKrakenSymbol(symbol);
    final price = prices[krakenSymbol];

    return price ?? 0;
  }

  // Fetch supported symbols from Kraken (aligned with candlestick chart)
  static Future<List<String>> fetchSupportedSymbols() async {
    final pairs = await KrakenRepository().fetchTradingPairs();
    final supportedSymbols = _symbolMap.keys.toList();
    return pairs.where((pair) => supportedSymbols.contains(pair)).toList();
  }
}

class TransferService {
  // Calculate the total USD value of a user's cryptocurrency holdings
  static double calculateUserDollarValue(
      User user, Map<String, double> prices) {
    return (user.BTC * (prices['XBTUSD'] ?? 0.0)) +
        (user.ETH * (prices['ETHUSD'] ?? 0.0)) +
        (user.DOGE * (prices['XDGUSD'] ?? 0.0)) +
        (user.SOL * (prices['SOLUSD'] ?? 0.0)) +
        (user.BNB * (prices['BNBUSD'] ?? 0.0));
  }

  // Stream a user's transaction history from Firestore
  static Stream<List<t.Transaction>> getTransactionStream(String uid) {
    if (uid.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    return FirebaseFirestore.instance
        .collection('transaction')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => t.Transaction.fromMap(doc.data()))
            .where((transaction) => transaction.receiver_uid == uid)
            .toList());
  }

  // Stream a user's trade history from Firestore
  static Stream<List<Trade>> getTradeStream(String uid) {
    if (uid.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    return FirebaseFirestore.instance
        .collection('trade')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Trade.fromMap(doc.data()))
            .where((trade) => trade.receiver_uid == uid)
            .toList());
  }

  // Initiate a margin trade with validation and Firestore updates
  static Future<TradeResult> initiateMarginTrade(
    BuildContext context,
    WidgetRef ref,
    User? user,
    double? tp,
    double? sl,
    double margin,
    String symbol,
    bool sell,
    double leverage,
  ) async {
    try {
      final currentId = x.FirebaseAuth.instance.currentUser?.uid;
      final newSymbol = SymbolUtils.getValueForSymbol(symbol);
      if (currentId == null) {
        throw 'User not authenticated';
      }
      if (user == null) {
        throw 'User not found';
      }
      if (leverage <= 0.1 || leverage > SymbolUtils.getMaxLeverage(symbol)) {
        throw 'Leverage must be between 1 and ${SymbolUtils.getMaxLeverage(symbol)} for $symbol';
      }

      final prices = ref.read(priceProvider);

      _validateMarginTrade(margin, user, prices, newSymbol, leverage, context);

      if (newSymbol.isEmpty) {
        throw 'Invalid trading symbol';
      }

      final cryptoPrice = SymbolUtils.getPriceForSymbol(
        newSymbol,
        prices,
      );
      if (tp != null) {
        validatePrice(
            context, tp, sl ?? cryptoPrice-1, sell ? 'Sell' : 'Buy', cryptoPrice);
      }
      if (sl != null) {
        validatePrice(
            context, tp ?? cryptoPrice+1, sl, sell ? 'Sell' : 'Buy', cryptoPrice);
      }

      final cryptoAmount = margin / cryptoPrice;
      final positionSize = cryptoAmount * leverage;

      await _performMarginTrade(
        context,
        ref,
        positionSize,
        margin,
        user,
        tp,
        sl,
        newSymbol,
        sell,
        leverage,
        currentId,
      );

      // Monitor trade for automatic closure
      // final trade = Trade(
      //   TradeId:  Uuid().v1(),
      //   receiver_username: user.name,
      //   receiver_uid: user.uid,
      //   receiver_pic: user.photoUrl,

      //   newSymbol  : positionSize,
      //   take_profit: tp,
      //   stop_loss: sl,
      //   withdraw: false,
      //   sell: sell,
      //   date: DateTime.now(),
      //   margin: margin,
      //   leverage: leverage,
      // );
      // await monitorTrade(context, ref, trade, candles);

      showMessage(context,
          'Trade placed successfully, observe at the trade history tab');
      return TradeResult(success: true);
    } catch (e) {
      showMessage(context, e.toString());
      return TradeResult(success: false, errorMessage: e.toString());
    }
  }

  // Validate margin trade parameters
  static void _validateMarginTrade(
    double margin,
    User user,
    Map<String, double> prices,
    String symbol,
    double leverage,
    BuildContext context,
  ) {
    if (margin <= 0) {
      throw 'Margin must be greater than zero';
    }
    final cryptoPrice = SymbolUtils.getPriceForSymbol(
      symbol,
      prices,
    );
    final cryptoMargin = margin / cryptoPrice;
    final userCryptoBalance = _getUserCryptoBalance(user, symbol);
    if (cryptoMargin > userCryptoBalance) {
      throw 'Insufficient $symbol balance $cryptoMargin against $userCryptoBalance for margin';
    }
  }

  // Perform margin trade with Firestore transaction
  static Future<void> _performMarginTrade(
    BuildContext context,
    WidgetRef ref,
    double positionSize,
    double margin,
    User user,
    double? tp,
    double? sl,
    String symbol,
    bool sell,
    double leverage,
    String currentId,
  ) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(currentId);
        final cryptoPrice = SymbolUtils.getPriceForSymbol(
          symbol,
          ref.read(priceProvider),
        );
        final cryptoMargin = margin / cryptoPrice;

        transaction
            .update(userRef, {symbol: FieldValue.increment(-cryptoMargin)});

        final tradeId = const Uuid().v1();
        final transactionId = const Uuid().v1();
        final datePublished = DateTime.now();

        transaction
            .set(FirebaseFirestore.instance.collection('trade').doc(tradeId), {
          'TradeId': tradeId,
          'receiver_username': user.name,
          'receiver_uid': user.uid,
          'receiver_pic': user.photoUrl,
          symbol: positionSize,
          'take_profit': tp,
          'stop_loss': sl,
          'withdraw': false,
          'sell': sell,
          'date': datePublished,
          'margin': margin,
          'leverage': leverage,
        });

        transaction.set(
            FirebaseFirestore.instance
                .collection('transaction')
                .doc(transactionId),
            {
              'transactionId': transactionId,
              'title': 'Margin trading',
              'receiver_uid': user.uid,
              symbol: -positionSize,
              'withdraw': false,
              'processing': false,
              'date': datePublished,
              'trade': true,
            });
      });
    } catch (e) {
      _handleError(context, 'Error placing trade: $e');
      throw 'An error occurred while placing the trade. Please try again.';
    }
  }

  // Get user's balance for a specific cryptocurrency
  static double _getUserCryptoBalance(User user, String symbol) {
    switch (symbol) {
      case 'BTC':
        return user.BTC;
      case 'XBTUSD':
        return user.BTC;
      case 'BTCUSD':
        return user.BTC;
      case 'ETH':
        return user.ETH;
      case 'ETHUSD':
        return user.ETH;
      case 'DOGE':
        return user.DOGE;
      case 'XDGUSD':
        return user.DOGE;
      case 'SOL':
        return user.SOL;
      case 'SOLUSD':
        return user.SOL;
      case 'BNB':
        return user.BNB;
      case 'BNBUSD':
        return user.BNB;
      default:
        return 0.0;
    }
  }

  // Monitor trade for take-profit or stop-loss triggers

  // static Future<void> monitorTrade(
  //   BuildContext context,
  //   WidgetRef ref,
  //   Trade trade,
  //   List<Candle> candles,
  // ) async {
  // final symbol = trade.symbol;
  // final tp = trade.takeProfit;
  // final sl = trade.stopLoss;
  // final sell = trade.sell;

  // ref.listen(priceProvider, (previous, next) {
  //   try {
  //     final currentPrice = SymbolUtils.getPriceForSymbol(symbol, next, candles);
  //     if (tp != null && ((sell && currentPrice <= tp) || (!sell && currentPrice >= tp))) {
  //       endTrade(context, ref, trade.amount, null, trade.receiver_uid, symbol, trade.tradeId, trade.date, null, candles);
  //     } else if (sl != null && ((sell && currentPrice >= sl) || (!sell && currentPrice <= sl))) {
  //       endTrade(context, ref, null, trade.amount, trade.receiver_uid, symbol, trade.tradeId, trade.date, null, candles);
  //     }
  //   } catch (e) {
  //     showMessage(context, 'Error monitoring trade: $e');
  //   }
  // });
  // }

  // End a trade, updating balance and history
  static Future<TradeResult> endTrade(
    BuildContext context,
    WidgetRef ref,
    double? amount,
    double? stopLoss,
    double? leverage,
    String? userId,
    String symbol,
    String tradeId,
    DateTime date,
    double? forceStop,
    // List<Candle> candles, // Added for price fallback
  ) async {
    try {
      final currentId = x.FirebaseAuth.instance.currentUser?.uid;
      if (currentId == null) {
        throw 'User not authenticated';
      }
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentId)
          .get();
      if (!userDoc.exists) {
        throw 'User not found';
      }
      final user = User.fromMap(userDoc.data()!);

      final prices = ref.read(priceProvider);
      final cryptoPrice = SymbolUtils.getPriceForSymbol(
        symbol,
        prices,
      );

      double cryptoAmount = 0.0;
      if (forceStop != null && forceStop != 0) {
        cryptoAmount = forceStop / cryptoPrice;
      } else if (stopLoss != null && stopLoss != 0 && stopLoss <= amount!) {

        cryptoAmount = stopLoss / cryptoPrice;

      } else if (amount != null) {
        cryptoAmount = amount / cryptoPrice;
      } else {
        throw 'No valid amount provided to end trade';
      }

      await _transferGain((cryptoAmount * (leverage ?? 1)), symbol, user, currentId);
      await _saveHistoryCollection(
          (cryptoAmount * (leverage ?? 1)), user, symbol, tradeId);

      return TradeResult(success: true);
    } catch (e) {
      _handleError(context, 'Error ending trade: $e');
      return TradeResult(success: false, errorMessage: e.toString());
    }
  }

  // Transfer gains back to user balance
  static Future<void> _transferGain(
    double cryptoAmount,
    String symbol,
    User user,
    String currentId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentId)
          .update({
        symbol: FieldValue.increment(cryptoAmount),
      });
    } catch (e) {
      throw 'Error transferring gain: $e';
    }
  }

  // Save trade closure to history
  static Future<void> _saveHistoryCollection(
    double? amount,
    User user,
    String symbol,
    String tradeId,
  ) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final datePublished = DateTime.now();
        transaction.update(
            FirebaseFirestore.instance.collection('trade').doc(tradeId), {
          'withdraw': true,
          'date': datePublished,
          // symbol: amount,
        });

        final transactionId = const Uuid().v1();
        transaction.set(
            FirebaseFirestore.instance
                .collection('transaction')
                .doc(transactionId),
            {
              'transactionId': transactionId,
              'title': 'Trade reflect',
              'address': 'Internal Trade Transcation',
              'receiver_uid': user.uid,
              'receiver_pic': user.photoUrl,
              'processing': false,
              symbol: amount,
              'trade': true,
              'withdraw': false,
              'date': datePublished,
            });
      });
    } catch (e) {
      throw 'Error saving history: $e';
    }
  }

  // Validate price for buy/sell orders
  static void validatePrice(
    BuildContext context,
    double tp,
    double sl,
    String action,
    double currentPrice,
  ) {
    if (action == 'Buy' && tp <= sl) {
      throw 'Price must be greater than the current price for buy orders';
    }
    if (action == 'Sell' && sl >= currentPrice) {
      throw 'Price must be less than the current price for sell orders';
    }
  }

  // Process a withdrawal request
  static Future<void> withdrawRequest(
    // BuildContext context,
    String address,
    String amount,
    String name,
    String page,
    Map<String, double> prices,
  ) async {
    try {
      final currentId = x.FirebaseAuth.instance.currentUser?.uid;
      if (currentId == null) {
        throw 'User not authenticated';
      }
      final amountValue = double.tryParse(amount);
      if (amountValue == null || amountValue <= 0) {
        throw 'Invalid withdrawal amount';
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentId)
          .get();
      if (!userDoc.exists) {
        throw 'User not found';
      }
      final user = User.fromMap(userDoc.data()!);

      final dollarValue = calculateUserDollarValue(user, prices);
      if (amountValue > dollarValue) {
        throw 'Insufficient funds for withdrawal';
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(
            FirebaseFirestore.instance.collection('users').doc(currentId), {
          page: FieldValue.increment(-amountValue),
        });

        transaction.set(
            FirebaseFirestore.instance.collection('withdrawal').doc(currentId),
            {
              'address': address,
              'amount': double.tryParse(amount),
              'uid': currentId,
              'name': name,
              'page': page,
            });

        final transactionId = const Uuid().v1();
        final datePublished = DateTime.now();
        transaction.set(
            FirebaseFirestore.instance
                .collection('transaction')
                .doc(transactionId),
            {
              'transactionId': transactionId,
              'address': address,
              'title':
                  'Your withdrawal is being processed, this may take up to 20 minutes.',
              'receiver_uid': currentId,
              page: double.tryParse(amount),
              'processing': true,
              'withdraw': true,
              'trade': false,
              'date': datePublished,
            });
      });

      // showMessage(context, 'Withdrawal request submitted successfully');
    } catch (e) {
      // _handleError(context, 'Error processing withdrawal: $e');
      throw e;
    }
  }

  // Process a swap request
  static Future<void> swapRequest(
    // BuildContext context,
    String exchangeAmount,
    String recoveryAmount,
    String label,
    String page,
    // Map<String, double> prices,
  ) async {
    try {
      final currentId = x.FirebaseAuth.instance.currentUser?.uid;
      if (currentId == null) {
        throw 'User not authenticated';
      }
      final count = double.tryParse(exchangeAmount);
      if (count == null || count <= 0) {
        throw 'Invalid swap amount';
      }

      final mount = double.tryParse(recoveryAmount);
      if (mount == null || count <= 0) {
        throw 'Invalid swap amount';
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentId)
          .get();
      if (!userDoc.exists) {
        throw 'User not found';
      }
      final user = User.fromMap(userDoc.data()!);
      final pageBalance = _getUserCryptoBalance(user, page);
      if (count > pageBalance) {
        throw 'Insufficient $page balance for swap';
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(
            FirebaseFirestore.instance.collection('users').doc(currentId), {
          label: FieldValue.increment(mount),
          page: FieldValue.increment(-count),
        });

        final transactionId = const Uuid().v1();
        final transactionId2 = const Uuid().v1();
        final datePublished = DateTime.now();

        
        transaction.set(
            FirebaseFirestore.instance
                .collection('transaction')
                .doc(transactionId2),
            {
              'transactionId': transactionId2,
              'title': 'Your swap transcation was processed successfully.',
              'receiver_uid': currentId,
              page: -count,
              'withdraw': true,
              'processing': false,
              'address': 'Interal Convert Transcation',
              'date': datePublished,
            });

        transaction.set(
            FirebaseFirestore.instance
                .collection('transaction')
                .doc(transactionId),
            {
              'transactionId': transactionId,
              'title': 'Your swap transcation was processed successfully.',
              'receiver_uid': currentId,
              label: mount,
              'withdraw': false,
              'processing': false,
              'address': 'Interal Convert Transcation',
              'date': datePublished,
            });

      });

      // showMessage(context, 'Swap transaction processed successfully');
    } catch (e) {
      // _handleError(context, 'Error processing swap: $e');
      throw e;
    }
  }

  // Display error messages via SnackBar
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Handle errors with user-friendly messages
  static void _handleError(BuildContext context, String message) {
    showMessage(context, message);
  }
}

class TradeResult {
  final bool success;
  final String? errorMessage;

  TradeResult({required this.success, this.errorMessage});
}
