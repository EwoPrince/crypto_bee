import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/Recieve/RecieveBTC.dart';
import 'package:crypto_beam/view/asset/btcHistory.dart';
import 'package:crypto_beam/view/send/sendBTC.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/view/swap/swap.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Btcasset extends ConsumerStatefulWidget {
  const Btcasset({super.key});
  static const routeName = '/btcasset';

  @override
  ConsumerState<Btcasset> createState() => _BtcassetState();
}

class _BtcassetState extends ConsumerState<Btcasset> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BitCoin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/btc.png',
                height: 70,
                width: 70,
              ),
              SizedBox(height: 10),
              Text(
                '${numToCrypto(user!.BTC / btcPrice)} BTC',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(user.BTC, '2'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 40,
                        ),
                        Text(
                          'Send',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).onTap(() {
                    goto(context, Sendbtc.routeName, null);
                  }),
                  Container(
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          size: 40,
                        ),
                        Text(
                          'Recieve',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).onTap(() {
                    goto(context, RecieveBTC.routeName, null);
                  }),
                  Container(
                    child: Column(
                      children: [
                        Icon(
                          Icons.stacked_bar_chart_outlined,
                          size: 40,
                        ),
                        Text(
                          'Stake',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).onTap(() {
                    user.BTC == 0.0
                        ? showUpMessage(
                            context,
                            'You dont have any BTC, so you can\'t perform this transaction right now. Please contact customer service',
                            'Bitcoin currently Unavailable',
                          )
                        : goto(context, Stake.routeName, 'XBTUSD');
                  }),
                  Container(
                    child: Column(
                      children: [
                        Icon(
                          Icons.swap_vert,
                          size: 40,
                        ),
                        Text(
                          'Swap',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).onTap(() {
                    user.BTC == 0
                        ? showMessage(context,
                            'You currently don\'t have enough BTC to swap')
                        : goto(context, Swapcoin.routeName, 'XBTUSD');
                  }),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: BTCHistory()),
              Divider(),
              Text(
                'Current BTC price',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(btcPrice, '4'),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
