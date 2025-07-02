import 'package:crypto_beam/view/send/sendBTC.dart';
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                BottomsheetTile(
                  image: 'assets/images/btc.png',
                  name: 'Bitcoin',
                  description: 'Transfer Bitcoin to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'BTC');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/eth.png',
                  name: 'Ethereum',
                  description: 'Transfer Ethereum to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'ETH');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/doge.png',
                  name: 'DOGE',
                  description: 'Transfer DOGE to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'DOGE');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/bnb.png',
                  name: 'BNB',
                  description: 'Transfer BNB to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'BNB');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/sol.png',
                  name: 'Solana',
                  description: 'Transfer Solana to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, "SOL");
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/hmstr.png',
                  name: 'Hamstar Kombat',
                  description: 'Transfer Hamstar Kombat to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'HMSTR');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/pepe.jpeg',
                  name: 'PEPE',
                  description: 'Transfer Pepe to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'PEPE');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/mnt.jpg',
                  name: 'Mantle',
                  description: 'Transfer Mantle to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'MNT');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/TRX.png',
                  name: 'Tron',
                  description: 'Transfer Tron to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'TRX');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/usdt.png',
                  name: 'Tether (USDT)',
                  description: 'Transfer Tether to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'USDT');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/usdc.png',
                  name: 'USDC',
                  description: 'Transfer USDC to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'USDC');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/xrp.png',
                  name: 'Ripple (XRP)',
                  description: 'Transfer Ripple to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'XRP');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/x.png',
                  name: 'X',
                  description: 'Transfer X to external wallet.',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'X');
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
