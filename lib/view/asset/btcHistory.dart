import 'package:crypto_beam/model/transcation.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/provider/transcation_provider.dart';
import 'package:crypto_beam/widgets/he3.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/transcation_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BTCHistory extends ConsumerStatefulWidget {
  final String symbol;

  const BTCHistory(this.symbol, {super.key});

  @override
  ConsumerState<BTCHistory> createState() => _BTCHistoryState();
}

class _BTCHistoryState extends ConsumerState<BTCHistory> {
  late Future futureHolder;

  Future<bool> fetchdata() async {
    final user = ref.read(authProvider).user;
    await ref.read(transactionProvider).fetchTransactions(user!.uid);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> newLoad() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return true;
  }

  Future<void> onRefresh() async {
    setState(() {
      futureHolder = fetchdata();
    });
  }

  @override
  initState() {
    futureHolder = fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: futureHolder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(
                child: hes3(context),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: hes3(context),
              );
            }
            final data = ref.watch(transactionProvider).transactions;
            List<Transaction> newdata = [];
            if (widget.symbol == 'BTC') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.BTC != 0)
                  .toList();
            }
            if (widget.symbol == 'BNB') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.BNB != 0)
                  .toList();
            }
            if (widget.symbol == 'ETH') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.ETH != 0)
                  .toList();
            }
            if (widget.symbol == 'DOGE') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.DOGE != 0)
                  .toList();
            }
            if (widget.symbol == 'SOL') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.SOL != 0)
                  .toList();
            }
            if (widget.symbol == 'HMSTR') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.HMSTR != 0)
                  .toList();
            }
            if (widget.symbol == 'PEPE') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.PEPE != 0)
                  .toList();
            }
            if (widget.symbol == 'MNT') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.MNT != 0)
                  .toList();
            }
            if (widget.symbol == 'TRX') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.TRX != 0)
                  .toList();
            }
            if (widget.symbol == 'USDT') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.USDT != 0)
                  .toList();
            }
            if (widget.symbol == 'USDC') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.USDC != 0)
                  .toList();
            }
            if (widget.symbol == 'XRP') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.XRP != 0)
                  .toList();
            }
            if (widget.symbol == 'X') {
               newdata = data
                  .where((element) =>
                      element.transactionId.isNotEmpty && element.X != 0)
                  .toList();
            }

            return newdata.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        hes3(context),
                        // buy_recieve(context),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: newdata.length,
                    itemBuilder: (context, i) {
                      var us = newdata[i];
                      return TransactionTile(transaction: us);
                    },
                  );
          }),
    );
  }
}
