import 'package:crypto_beam/view/Recieve/RecieveBNB.dart';
import 'package:crypto_beam/view/Recieve/RecieveBTC.dart';
import 'package:crypto_beam/view/Recieve/RecieveDoge.dart';
import 'package:crypto_beam/view/Recieve/RecieveETH.dart';
import 'package:crypto_beam/view/Recieve/RecieveSOL.dart';
import 'package:crypto_beam/widgets/BSTile.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});
  static const routeName = '/Deposit';

  @override
  State<Deposit> createState() => _RecieveBTCState();
}

class _RecieveBTCState extends State<Deposit> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit'),
      ),
      body: Container(
        width: size.width,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              BottomsheetTile(
                image: 'assets/images/btc.png',
                name: 'Bitcoin',
                description:
                    'Deposit Bitcoin from external wallet, or purchase with Debit card',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, RecieveBTC.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/eth.png',
                name: 'Ethereum',
                description:
                    'Deposit Ethereum from external wallet, or purchase with Debit card',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, RecieveETH.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/doge.png',
                name: 'DOGE',
                description:
                    'Deposit DOGE from external wallet, or purchase with Debit card',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, RecieveDoge.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/bnb.png',
                name: 'BNB',
                description:
                    'Deposit BNB from external wallet, or purchase with Debit card',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, RecieveBNB.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/sol.png',
                name: 'Solana',
                description:
                    'Deposit Solana from external wallet, or purchase with Debit card',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, RecieveSOl.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
