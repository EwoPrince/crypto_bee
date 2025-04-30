import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/Recieve/RecieveSOL.dart';
import 'package:crypto_bee/view/asset/solHistory.dart';
import 'package:crypto_bee/view/send/sendSOL.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:crypto_bee/view/swap/swap.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SOLasset extends ConsumerStatefulWidget {
  const SOLasset({super.key});
  static const routeName = '/solasset';

  @override
  ConsumerState<SOLasset> createState() => _SOLassetState();
}

class _SOLassetState extends ConsumerState<SOLasset> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOL',
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
                'assets/images/sol.png',
                height: 70,
                width: 70,
              ),
              SizedBox(height: 10),
              Text(
                '${numToCrypto(user!.SOL / solPrice)} SOL',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(user.SOL, '2'),
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
                    goto(context, Sendsol.routeName, null);
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
                    goto(context, RecieveSOl.routeName, null);
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
                    user.SOL == 0.0
                        ? showUpMessage(
                            context,
                            'You dont have any SOL, so you can\'t perform this transaction right now. Please contact customer service',
                            'Solana currently Unavailable',
                          )
                        : goto(context, Stake.routeName, 'SOL/USD');
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
                    user.SOL == 0
                        ? showMessage(context,
                            'You currently don\'t have enough SOL to swap')
                        : goto(context, Swapcoin.routeName, 'SOL/USD');
                  }),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: SOLHistory()),
              Divider(),
              Text(
                'Current SOL price',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(solPrice, '4'),
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
