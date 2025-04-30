import 'package:crypto_bee/view/send/sendBTC.dart';
import 'package:crypto_bee/view/send/sendDOGE.dart';
import 'package:crypto_bee/view/send/sendETH.dart';
import 'package:crypto_bee/view/send/sendSOL.dart';
import 'package:crypto_bee/widgets/BSTile.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';

void showSendModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BSTile(
              context,
              'assets/images/btc.png',
              'Send BTC',
              'Transfer Bitcoin from your wallet to an external wallet',
              true,
              false,
            ).onTap(() {
              goto(context, Sendbtc.routeName, null);
              // showUpMessage(
              //     context, 'First Purchase Bitcoin to transfer', 'Send BTC');
            }),
            BSTile(
              context,
              'assets/images/eth.png',
              'Send ETH',
              'Transfer Ethereum from your wallet to an external wallet',
              false,
              false,
            ).onTap(() {
              goto(context, Sendeth.routeName, null);
              // showUpMessage(
              //     context, 'First Purchase Ethereum to transfer', 'Send ETH');
            }),
            BSTile(
              context,
              'assets/images/doge.png',
              'Send DOGE',
              'Transfer DOGE from your wallet to an external wallet',
              false,
              false,
            ).onTap(() {
              goto(context, Senddoge.routeName, null);
              // showUpMessage(
              //     context, 'First Purchase Doge to transfer', 'Send DOGE');
            }),
            BSTile(
              context,
              'assets/images/sol.png',
              'Send SOL',
              'Transfer Solana from your wallet to an external wallet',
              false,
              true,
            ).onTap(() {
              goto(context, Sendsol.routeName, null);
              // showUpMessage(
              //     context, 'First Purchase Solana to transfer', 'Send SOL');
            }),
            SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
