import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/Recieve/RecieveDoge.dart';
import 'package:crypto_bee/view/asset/dogeHistory.dart';
import 'package:crypto_bee/view/send/sendDOGE.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:crypto_bee/view/swap/swap.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DOGEasset extends ConsumerStatefulWidget {
  const DOGEasset({super.key});
  static const routeName = '/dogeasset';

  @override
  ConsumerState<DOGEasset> createState() => _DOGEassetState();
}

class _DOGEassetState extends ConsumerState<DOGEasset> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DOGE',
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
                'assets/images/doge.png',
                height: 70,
                width: 70,
              ),
              SizedBox(height: 10),
              Text(
                '${numToCrypto(user!.DOGE / dogePrice)} DOGE',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(user.DOGE, '2'),
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
                    goto(context, Senddoge.routeName, null);
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
                    goto(context, RecieveDoge.routeName, null);
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
                    user.DOGE == 0.0
                        ? showUpMessage(
                            context,
                            'You dont have any DOGE, so you can\'t perform this transaction right now. Please contact customer service',
                            'DOGE currently Unavailable',
                          )
                        : goto(context, Stake.routeName, 'XDGUSD');
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
                    user.DOGE == 0
                        ? showMessage(context,
                            'You currently don\'t have enough DOGE to swap')
                        : goto(context, Swapcoin.routeName, 'XDGUSD');
                  }),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: DogeHistory()),
              Divider(),
              Text(
                'Current DOGE price',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(dogePrice, '4'),
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
