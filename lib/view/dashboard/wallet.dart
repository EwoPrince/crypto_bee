import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/account/general_setting.dart';
import 'package:crypto_bee/view/asset/bnbAsset.dart';
import 'package:crypto_bee/view/asset/btcAsset.dart';
import 'package:crypto_bee/view/asset/dogeAsset.dart';
import 'package:crypto_bee/view/asset/ethAsset.dart';
import 'package:crypto_bee/view/asset/solAsset.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:crypto_bee/widgets/assetTile.dart';
import 'package:crypto_bee/widgets/recieveBS.dart';
import 'package:crypto_bee/widgets/sendBS.dart';
import 'package:crypto_bee/widgets/walletBS.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({super.key});

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(authProvider).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            size: 24,
                          ),
                          Text(
                            " Wallet ",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ).onTap(() {
                    showWalletBottomSheet(context, ref);
                  }),
                  IconButton(
                    onPressed: () {
                      goto(
                        context,
                        Settingss.routeName,
                        null,
                      );
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Text(
                'Available Balance',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                numToCurrency(user!.dollar, '2'),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Text(
                user.name,
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
                    showRecieveModalBottomSheet(context);
                  }),
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
                    showSendModalBottomSheet(context);
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
                    // showStakeBottomSheet(context);
                    goto(context, Stake.routeName, 'XBTUSD');
                  }),
                ],
              ),
              SizedBox(height: 70),
              Text(
                'Crypto Asset',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              AssetTile(
                context,
                'assets/images/btc.png',
                'BTC',
                numToCurrency(user.BTC, '2'),
                numToCrypto(user.BTC / btcPrice),
                numToCurrency(btcPrice, '4'),
                true,
                false,
              ).onTap(() {
                goto(context, Btcasset.routeName, null);
              }),
              if (user.BNB != 0)
                AssetTile(
                  context,
                  'assets/images/bnb.png',
                  'BNB',
                  numToCurrency(user.BNB, '2'),
                  numToCrypto(user.BNB / bnbPrice),
                  numToCurrency(bnbPrice, '4'),
                  false,
                  false,
                ).onTap(() {
                  goto(context, Bnbasset.routeName, null);
                }),
              AssetTile(
                context,
                'assets/images/eth.png',
                'ETH',
                numToCurrency(user.ETH, '2'),
                numToCrypto(user.ETH / ethPrice),
                numToCurrency(ethPrice, '4'),
                false,
                false,
              ).onTap(() {
                goto(context, ETHasset.routeName, null);
              }),
              AssetTile(
                context,
                'assets/images/doge.png',
                'DOGE',
                numToCurrency(user.DOGE, '2'),
                numToCrypto(user.DOGE / dogePrice),
                numToCurrency(dogePrice, '4'),
                false,
                false,
              ).onTap(() {
                goto(context, DOGEasset.routeName, null);
              }),
              AssetTile(
                context,
                'assets/images/sol.png',
                'SOL',
                numToCurrency(user.SOL, '2'),
                numToCrypto(user.SOL / solPrice),
                numToCurrency(solPrice, '4'),
                false,
                true,
              ).onTap(() {
                goto(context, SOLasset.routeName, null);
              }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
