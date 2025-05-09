import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/account/general_setting.dart';
import 'package:crypto_beam/view/dashboard/wallet.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/view/swap/swap.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/column_with_spacing.dart';
import 'package:crypto_beam/widgets/recieveBS.dart';
import 'package:crypto_beam/widgets/sendBS.dart';
import 'package:crypto_beam/widgets/walletBS.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class CoinData {
  final String name;
  final String price;
  final String percentageChange;
  final bool isChecked;

  CoinData(
      {required this.name,
      required this.price,
      required this.percentageChange,
      required this.isChecked});
}

class _ExploreState extends ConsumerState<Explore> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CoinData> coinList = [
    CoinData(name: "BTC/USDT", price: btcPrice.toString(), percentageChange: "-0.90%", isChecked: true),
    CoinData(name: "ETH/USDT", price: ethPrice.toString(), percentageChange: "-0.28%", isChecked: true),
    CoinData(name: "DOGE/USDT", price: dogePrice.toString(), percentageChange: "-0.61%", isChecked: true),
    CoinData(name: "SOL/USDT", price: solPrice.toString(), percentageChange: "-0.65%", isChecked: true),
    CoinData(name: "BNB/USDT", price: bnbPrice.toString(), percentageChange: "+0.55%", isChecked: true),
  ];
  
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
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.account_circle_rounded).onTap(()=> showWalletBottomSheet(context, ref)),
                  const Text("Crypto Beam"),
                  Row(
                    children: [
                      Icon(Icons.settings_outlined).onTap(() => goto(context, Settingss.routeName, null)),
                      Stack(
                        children: [
                          const Icon(Icons.notifications),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  // decoration: BoxDecoration(
                  //   color: Colors.orange,
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: 
                  user!.dollar == 0
                  ?
                  ColumnWithSpacing(
                    spacing: 8,
                    children: [
                
                
                       Text(
                        "Deposit and start trading.",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold),
                      ),
                      CustomButton(name: "Deposit Now", onTap: (){}, color: Theme.of(context).primaryColor,),
                    ],
                  )
                  : ColumnWithSpacing(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                
                
                       Text(
                        textAlign: TextAlign.start,
                        "Experience seamless trading",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      
                Text(
                  numToCurrency(user.dollar, '2'),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white54),
                ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                    icon: CupertinoIcons.money_dollar,
                    label: 'Deposit',
                    onTap: () => showRecieveModalBottomSheet(context),
                  ),
                  ActionButton(
                    icon: CupertinoIcons.arrow_2_circlepath,
                    label: 'Convert',
                    onTap: () => goto(context, Swapcoin.routeName, null), 
                  ),
                  ActionButton(
                    icon: Icons.stacked_bar_chart_outlined,
                    label: 'Trade',
                    onTap: () => goto(context, Stake.routeName, null),
                  ),
                  ActionButton(
                    icon: CupertinoIcons.rocket_fill,
                    label: 'Transfer',
                    onTap: () => showSendModalBottomSheet(context),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Card(
                    child: Container(
                      width: 150,
                      height: 100,
                      child: Center(child: const Text("1V1 Trading Arena")),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Card(
                    child: Container(
                      width: 150,
                      height: 100,
                      child: Center(child: const Text("Puzzle Hunt")),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text("Favorites"),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Hot"),
                  SizedBox(
                    width: 10,
                  ),
                  Text("New"),
                ],
              ),
              Row(
                children: [
                  TextButton(onPressed: () {
                  _tabController.animateTo(0);}, child: const Text("Spot")),
                  TextButton(
                      onPressed: () {
                  _tabController.animateTo(1);}, child: const Text("Derivatives"))
                ],
              ),              
              SizedBox(
                height: 450,
                child: TabBarView(
                  controller: _tabController,
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: coinList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              style: ListTileStyle.drawer,
                              leading: Text(coinList[index].name, style: Theme.of(context).textTheme.titleMedium,),
                              title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text(coinList[index].price),
                              ),
                              subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text(coinList[index].percentageChange),
                              ),
                              trailing: Icon(
                                  coinList[index].isChecked ? Icons.check : null),
                            );
                          }),
                          ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: coinList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              style: ListTileStyle.drawer,
                              leading: Text(coinList[index].name, style: Theme.of(context).textTheme.titleMedium,),
                              title: Text(coinList[index].price),
                              subtitle: Text(coinList[index].percentageChange),
                              trailing: Icon(
                                  coinList[index].isChecked ? Icons.check : null),
                            );
                          }),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
