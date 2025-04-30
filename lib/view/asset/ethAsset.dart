import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/Recieve/RecieveETH.dart';
import 'package:crypto_bee/view/asset/ethHistory.dart';
import 'package:crypto_bee/view/send/sendETH.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:crypto_bee/view/swap/swap.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ETHasset extends ConsumerStatefulWidget {
  const ETHasset({super.key});
  static const routeName = '/ethasset';

  @override
  ConsumerState<ETHasset> createState() => _ETHassetState();
}

class _ETHassetState extends ConsumerState<ETHasset> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ETH',
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
                'assets/images/eth.png',
                height: 70,
                width: 70,
              ),
              SizedBox(height: 10),
              Text(
                '${numToCrypto(user!.ETH / ethPrice)} ETH',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(user.ETH, '2'),
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
                    goto(context, Sendeth.routeName, null);
                    // showUpMessage(context,
                    //     'First Purchase Ethereum to transfer', 'Send ETH');
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
                    goto(context, RecieveETH.routeName, null);
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
                    user.ETH == 0.0
                        ? showUpMessage(
                            context,
                            'You dont have any ETH, so you can\'t perform this transaction right now. Please contact customer service',
                            'Ethereum currently Unavailable',
                          )
                        : goto(context, Stake.routeName, 'ETH/USD');
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
                    user.ETH == 0
                        ? showMessage(context,
                            'You currently don\'t have enough ETH to swap')
                        : goto(context, Swapcoin.routeName, 'ETH/USD');
                  }),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: ETHHistory()),
              Divider(),
              Text(
                'Current ETH price',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 6),
              Text(
                numToCurrency(ethPrice, '4'),
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
