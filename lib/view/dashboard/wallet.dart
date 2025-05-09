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

class _WalletState extends ConsumerState<Wallet> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: 
                        Text(
                          " My Assets ",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                  ),
                  IconButton(
                    onPressed: () => showWalletBottomSheet(context, ref),
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Text(
                'Total Assets',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: [
                  Text(
                  '${user!.dollar} ',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  
              Text(
                ' USD',
                style: Theme.of(context).textTheme.bodySmall,
              ),
                ],
              ),
              Text(
                '= ${user.BTC} BTC',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12),),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          //this is the user name
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        
                        Text(
                          //this is the user name
                          '*         would you like to begin',
                    
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
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
                    label: 'Trade',
                    onTap: () => Navigator.pushNamed(context, Stake.routeName),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  TextButton(onPressed: () {
                  _tabController.animateTo(0);}, child: const Text("Account")),
                  TextButton(
                      onPressed: () {
                  _tabController.animateTo(1);}, child: const Text("Asset"))
                ],
              ),         
              const SizedBox(height: 8),
              ListTile(
                              style: ListTileStyle.drawer,
                              title: Text('Funding'),
                              subtitle: Text(
                  numToCurrency(user.dollar, '2'),),
                              trailing: Icon(Icons.arrow_forward ),
                            ),
                            
              ListTile(
                              style: ListTileStyle.drawer,
                              title: Text('Unified Trading'),
                              subtitle: Text(
                  numToCurrency(user.dollar, '2'),),
                              trailing: Icon(Icons.arrow_forward ),
                            ),
              
            ],
          ),
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
