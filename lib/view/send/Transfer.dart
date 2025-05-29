import 'package:crypto_beam/view/send/sendBNB.dart';
import 'package:crypto_beam/view/send/sendBTC.dart';
import 'package:crypto_beam/view/send/sendDOGE.dart';
import 'package:crypto_beam/view/send/sendETH.dart';
import 'package:crypto_beam/view/send/sendSOL.dart';
import 'package:crypto_beam/widgets/BSTile.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});
  static const routeName = '/Transfer';

  @override
  State<Transfer> createState() => _RecieveBTCState();
}

class _RecieveBTCState extends State<Transfer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
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
                    'Transfer Bitcoin to external wallet.',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, Sendbtc.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/eth.png',
                name: 'Ethereum',
                description:
                    'Transfer Ethereum to external wallet.',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, Sendeth.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/doge.png',
                name: 'DOGE',
                description:
                    'Transfer DOGE to external wallet.',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, Senddoge.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/bnb.png',
                name: 'BNB',
                description:
                    'Transfer BNB to external wallet.',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, SendBnb.routeName, null);
                },
                color: Theme.of(context).cardColor,
              ),
              SizedBox(height: 20),
              BottomsheetTile(
                image: 'assets/images/sol.png',
                name: 'Solana',
                description:
                    'Transfer Solana to external wallet.',
                top: true,
                bottom: true,
                onTap: () {
                  goto(context, Sendsol.routeName, null);
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
