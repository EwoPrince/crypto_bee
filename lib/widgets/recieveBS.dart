import 'package:crypto_beam/view/Recieve/RecieveBNB.dart';
import 'package:crypto_beam/view/Recieve/RecieveBTC.dart';
import 'package:crypto_beam/view/Recieve/RecieveDoge.dart';
import 'package:crypto_beam/view/Recieve/RecieveETH.dart';
import 'package:crypto_beam/view/Recieve/RecieveHMSTR.dart';
import 'package:crypto_beam/view/Recieve/RecieveMNT.dart';
import 'package:crypto_beam/view/Recieve/RecievePEPE.dart';
import 'package:crypto_beam/view/Recieve/RecieveSOL.dart';
import 'package:crypto_beam/view/Recieve/RecieveTRX.dart';
import 'package:crypto_beam/view/Recieve/RecieveUSDC.dart';
import 'package:crypto_beam/view/Recieve/RecieveUSDT.dart';
import 'package:crypto_beam/view/Recieve/RecieveX.dart';
import 'package:crypto_beam/view/Recieve/RecieveXRP.dart';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BottomsheetTile(
                image: 'assets/images/btc.png',
                name: 'Recieve BTC',
                description:
                    'Transfer Bitcoin from external wallet, or purchase with Debit card',
                top: true,
                bottom: false,
                onTap: () {
                  goto(context, RecieveBTC.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/eth.png',
                name: 'Recieve ETH',
                description:
                    'Transfer Ethereum from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveETH.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/doge.png',
                name: 'Recieve DOGE',
                description:
                    'Transfer DOGE from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveDoge.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/sol.png',
                name: 'Recieve SOL',
                description:
                    'Transfer Solana from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveSOl.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/bnb.png',
                name: 'Recieve BNB',
                description:
                    'Transfer Binance Coin from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveBNB.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/hmstr.png',
                name: 'Recieve HMSTR',
                description:
                    'Transfer Hamster Kombat from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveHMSTR.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/pepe.jpeg',
                name: 'Recieve PEPE',
                description:
                    'Transfer PEPE from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecievePEPE.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/mnt.jpg',
                name: 'Recieve MNT',
                description:
                    'Transfer Mantle from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveMNT.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/TRX.png',
                name: 'Recieve TRX',
                description:
                    'Transfer TRON from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveTRX.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/usdt.png',
                name: 'Recieve USDT',
                description:
                    'Transfer Tether from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveUSDT.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/usdc.png',
                name: 'Recieve USDC',
                description:
                    'Transfer USDC from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveUSDC.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/xrp.png',
                name: 'Recieve XRP',
                description:
                    'Transfer Ripple from external wallet, or purchase with Debit card',
                top: false,
                bottom: false,
                onTap: () {
                  goto(context, RecieveXRP.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              BottomsheetTile(
                image: 'assets/images/x.png',
                name: 'Recieve X',
                description:
                    'Transfer X from external wallet, or purchase with Debit card',
                top: false,
                bottom: true,
                onTap: () {
                  goto(context, RecieveX.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}
