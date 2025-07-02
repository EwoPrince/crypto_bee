import 'package:crypto_beam/view/send/sendBTC.dart';
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
    'extra': 'BTC',
    'first': true,
    'last': false,
  },
  {
    'image': 'assets/images/eth.png',
    'name': 'Send ETH',
    'description': 'Transfer Ethereum from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'ETH',
    'first': false,
    'last': false,
  },
  {
    'image': 'assets/images/doge.png',
    'name': 'Send DOGE',
    'description': 'Transfer DOGE from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'DOGE',
    'first': false,
    'last': false,
  },
  {
    'image': 'assets/images/sol.png',
    'name': 'Send SOL',
    'description': 'Transfer Solana from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'SOL',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/bnb.png',
    'name': 'Send BNB',
    'description':
        'Transfer Binance coin from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'BNB',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/hmstr.png',
    'name': 'Send HMSTR',
    'description':
        'Transfer Hamster Kombat from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'HMSTR',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/pepe.jpeg',
    'name': 'Send PEPE',
    'description': 'Transfer PEPE from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'PEPE',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/mnt.jpg',
    'name': 'Send MNT',
    'description': 'Transfer Mantle from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'MNT',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/TRX.png',
    'name': 'Send TRX',
    'description': 'Transfer TRON from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'TRX',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/usdt.png',
    'name': 'Send USDT',
    'description': 'Transfer Tether from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'USDT',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/usdc.png',
    'name': 'Send USDC',
    'description': 'Transfer USDC from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'USDC',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/xrp.png',
    'name': 'Send XRP',
    'description': 'Transfer Ripple from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'XRP',
    'first': false,
    'last': true,
  },
  {
    'image': 'assets/images/x.png',
    'name': 'Send X',
    'description': 'Transfer X from your wallet to an external wallet',
    'route': Sendbtc.routeName,
    'extra': 'X',
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
      return Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...sendCurrencies.map((currency) {
                return BottomsheetTile(
                  image: currency['image'],
                  name: currency['name'],
                  description: currency['description'],
                  top: currency['first'],
                  bottom: currency['last'],
                  onTap: () {
                    goto(context, currency['route'], currency['extra']);
                  },
                  color: Theme.of(context).cardColor,
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}
