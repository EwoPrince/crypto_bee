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
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/hmstr.png',
                  name: 'Hamster Kombat',
                  description:
                      'Deposit Hamster Kombat from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveHMSTR.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/pepe.jpeg',
                  name: 'PEPE',
                  description:
                      'Deposit PEPE from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecievePEPE.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/mnt.jpg',
                  name: 'Mantle',
                  description:
                      'Deposit Mantle from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveMNT.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/TRX.png',
                  name: 'TRON',
                  description:
                      'Deposit TRON from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveTRX.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/usdt.png',
                  name: 'Tether',
                  description:
                      'Deposit Tether from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveUSDT.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/usdc.png',
                  name: 'USDC',
                  description:
                      'Deposit USDC from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveUSDC.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/xrp.png',
                  name: 'Ripple',
                  description:
                      'Deposit Ripple from external wallet, or purchase with Debit card',
                  top: true,
                  bottom: true,
                  onTap: () {
                    goto(context, RecieveXRP.routeName, null);
                  },
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(height: 20),
                BottomsheetTile(
                  image: 'assets/images/x.png',
                  name: 'X',
                  description:
                      'Deposit X from external wallet, or purchase with Debit card',
                  top: true,
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
        ),
      ),
    );
  }
}
