import 'package:crypto_beam/view/send/sendBTC.dart';
import 'package:crypto_beam/view/send/sendDOGE.dart';
import 'package:crypto_beam/view/send/sendETH.dart';
import 'package:crypto_beam/view/send/sendSOL.dart';
import 'package:crypto_beam/widgets/BSTile.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';

// Data structure for send currencies
const List<Map<String, dynamic>> sendCurrencies = [
  {
    'image': 'assets/images/btc.png',
    'name': 'Send BTC',
    'description': 'Transfer Bitcoin from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'first': true,
    'last': false,
  },
  {
    'image': 'assets/images/eth.png',
    'name': 'Send ETH',
    'description': 'Transfer Ethereum from your wallet to an external wallet',
    'route': Sendeth.routeName,
    'first': false,
    'last': false,
  },
  {
    'image': 'assets/images/doge.png',
    'name': 'Send DOGE',
    'description': 'Transfer DOGE from your wallet to an external wallet',
    'route': Senddoge.routeName,
    'first': false,
    'last': false,
  },
  {
    'image': 'assets/images/sol.png',
    'name': 'Send SOL',
    'description': 'Transfer Solana from your wallet to an external wallet',
    'route': Sendsol.routeName,
    'first': false,
    'last': true,
  },
];

void showSendModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return  Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...sendCurrencies.map((currency) {
              return BottomsheetTile(
             image:    currency['image'],
             name:    currency['name'],
             description:    currency['description'],
             top:    currency['first'],
             bottom:    currency['last'],
            onTap:  () {
                goto(context, currency['route'], null);
              },
              color: Theme.of(context).primaryColor,);
            }),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
