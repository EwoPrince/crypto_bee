import 'package:crypto_beam/view/Recieve/RecieveBTC.dart';
import 'package:crypto_beam/view/Recieve/RecieveDoge.dart';
import 'package:crypto_beam/view/Recieve/RecieveETH.dart';
import 'package:crypto_beam/view/Recieve/RecieveSOL.dart';
import 'package:crypto_beam/widgets/BSTile.dart';
import 'package:crypto_beam/x.dart';
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

            BottomsheetTile(
        image:       'assets/images/btc.png',
          name:     'Recieve BTC',
          description:     'Transfer Bitcoin from external wallet, or purchase with Debit card',
         top:      true,
         bottom:      false,
           onTap: () {
              goto(context, RecieveBTC.routeName, null);
            },
            color: Theme.of(context).primaryColor,),
            BottomsheetTile(
           image:     'assets/images/eth.png',
           name:    'Recieve ETH',
             description:    'Transfer Ethereum from external wallet, or purchase with Debit card',
             top:    false,
            bottom:   false,
         onTap: () {
              goto(context, RecieveETH.routeName, null);
            },
            color: Theme.of(context).primaryColor,),
            BottomsheetTile(
            image:   'assets/images/doge.png',
            name:   'Recieve DOGE',
            description:   'Transfer DOGE from external wallet, or purchase with Debit card',
           top:    false,
           bottom:    false,
          onTap: () {
              goto(context, RecieveDoge.routeName, null);
            },
            color: Theme.of(context).primaryColor,),
            BottomsheetTile(
           image: 
              'assets/images/sol.png',
           name:    'Recieve SOL',
           description:    'Transfer Solana from external wallet, or purchase with Debit card',
           top:    false,
           bottom:    true,
            onTap: () {
              goto(context, RecieveSOl.routeName, null);
            },
            color: Theme.of(context).primaryColor,),
            SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
