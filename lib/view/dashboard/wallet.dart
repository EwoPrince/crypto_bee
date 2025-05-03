import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/account/general_setting.dart';
import 'package:crypto_beam/view/asset/bnbAsset.dart';
import 'package:crypto_beam/view/asset/btcAsset.dart';
import 'package:crypto_beam/view/asset/dogeAsset.dart';
import 'package:crypto_beam/view/asset/ethAsset.dart';
import 'package:crypto_beam/view/asset/solAsset.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/widgets/assetTile.dart';
import 'package:crypto_beam/widgets/recieveBS.dart';
import 'package:crypto_beam/widgets/sendBS.dart';
import 'package:crypto_beam/widgets/walletBS.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30),
                GestureDetector(
                  //this is the wallet button
                  onTap: () => showWalletBottomSheet(context, ref),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wallet,
                          size: 24,
                        ),
                        Text(
                          " Wallet ",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, Settingss.routeName),
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                ),
              ],
            ),
            Text(
              'Available Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              numToCurrency(user!.dollar, '2'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              //this is the user name
              user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  icon: Icons.arrow_downward,
                  label: 'Receive',
                  onTap: () => showRecieveModalBottomSheet(context),
                ),
                ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  onTap: () => showSendModalBottomSheet(context),
                ),
                ActionButton(
                  icon: Icons.stacked_bar_chart_outlined,
                  label: 'Stake',
                  onTap: () => Navigator.pushNamed(context, Stake.routeName),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Crypto Asset',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, Btcasset.routeName),
              child: AssetTileWidget(
                color: Theme.of(context).primaryColor,
                image: 
                'assets/images/btc.png',
              name:   'BTC',
              amount:   numToCurrency(user.BTC, '2'),
             asset:    numToCrypto(user.BTC / btcPrice),
             currentPrice:    numToCurrency(btcPrice, '4'),
             top:    true,
            bottom:     false,
              ),
            ),
            if (user.BNB != 0)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, Bnbasset.routeName),
              child: AssetTileWidget(
                color: Theme.of(context).primaryColor,
                image: 
                
                  'assets/images/bnb.png',
                name:   'BNB',
               amount:    numToCurrency(user.BNB, '2'),
               asset:    numToCrypto(user.BNB / bnbPrice),
               currentPrice:    numToCurrency(bnbPrice, '4'),
               top:    false, 
               bottom: false,),
              ),
            if (user.ETH != 0)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, ETHasset.routeName),
                child: AssetTileWidget(
                color: Theme.of(context).primaryColor,
                image: 
                
                  'assets/images/eth.png',
               name:    'ETH',
               amount:    numToCurrency(user.ETH, '2'),
               asset:    numToCrypto(user.ETH / ethPrice),
               currentPrice:    numToCurrency(ethPrice, '4'),
               top:    false, bottom:  false,),
              ),
            if (user.DOGE != 0)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, DOGEasset.routeName),
           child: AssetTileWidget(
                color: Theme.of(context).primaryColor,
                image: 
                
                  'assets/images/doge.png',
            name:       'DOGE',
             amount:      numToCurrency(user.DOGE, '2'),
              asset:     numToCrypto(user.DOGE / dogePrice),
              currentPrice:     numToCurrency(dogePrice, '4'),
             top:      false, bottom:  false,),
              ),
            if (user.SOL != 0)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, SOLasset.routeName),
              child: AssetTileWidget(
                color: Theme.of(context).primaryColor,
                image: 
                
                  'assets/images/sol.png',
                 name:  'SOL',
               amount:    numToCurrency(user.SOL, '2'),
               asset:    numToCrypto(user.SOL / solPrice),
               currentPrice:    numToCurrency(solPrice, '4'),
               top:    false,bottom:  true,),)
          ],
        ),),
    );
  }
}


class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

    @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
          ),
          Text(//style: Theme.of(context).textTheme.bodySmall,
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
