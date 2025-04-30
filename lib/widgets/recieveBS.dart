import 'package:crypto_bee/view/Recieve/RecieveBTC.dart';
import 'package:crypto_bee/view/Recieve/RecieveDoge.dart';
import 'package:crypto_bee/view/Recieve/RecieveETH.dart';
import 'package:crypto_bee/view/Recieve/RecieveSOL.dart';
import 'package:crypto_bee/widgets/BSTile.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';

void showRecieveModalBottomSheet(BuildContext context) {
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
              'Recieve BTC',
              'Transfer Bitcoin from external wallet, or purchase with Debit card',
              true,
              false,
            ).onTap(() {
              goto(context, RecieveBTC.routeName, null);
            }),
            BSTile(
              context,
              'assets/images/eth.png',
              'Recieve ETH',
              'Transfer Ethereum from external wallet, or purchase with Debit card',
              false,
              false,
            ).onTap(() {
              goto(context, RecieveETH.routeName, null);
            }),
            BSTile(
              context,
              'assets/images/doge.png',
              'Recieve DOGE',
              'Transfer DOGE from external wallet, or purchase with Debit card',
              false,
              false,
            ).onTap(() {
              goto(context, RecieveDoge.routeName, null);
            }),
            BSTile(
              context,
              'assets/images/sol.png',
              'Recieve SOL',
              'Transfer Solana from external wallet, or purchase with Debit card',
              false,
              true,
            ).onTap(() {
              goto(context, RecieveSOl.routeName, null);
            }),
            SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
