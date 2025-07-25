import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/provider/chat_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/Recieve/Deposit.dart';
import 'package:crypto_beam/view/account/general_setting.dart';
import 'package:crypto_beam/view/asset/hmstrAsset.dart';
import 'package:crypto_beam/view/asset/mntAsset.dart';
import 'package:crypto_beam/view/asset/pepeAsset.dart';
import 'package:crypto_beam/view/asset/trxAsset.dart';
import 'package:crypto_beam/view/asset/usdcAsset.dart';
import 'package:crypto_beam/view/asset/usdtAsset.dart';
import 'package:crypto_beam/view/asset/xAsset.dart';
import 'package:crypto_beam/view/asset/xrpAsset.dart';
import 'package:crypto_beam/view/notification/notification_list.dart';
import 'package:crypto_beam/view/send/Transfer.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/view/swap/swap.dart';
import 'package:crypto_beam/view/userguild/additonal_res.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/column_with_spacing.dart';
import 'package:crypto_beam/widgets/stakeBS.dart';
import 'package:crypto_beam/widgets/walletBS.dart';
import 'package:crypto_beam/x.dart';
import 'package:crypto_beam/x.dart' as x;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_beam/view/asset/bnbAsset.dart';
import 'package:crypto_beam/view/asset/btcAsset.dart';
import 'package:crypto_beam/view/asset/dogeAsset.dart';
import 'package:crypto_beam/view/asset/ethAsset.dart';
import 'package:crypto_beam/view/asset/solAsset.dart';
import 'package:url_launcher/url_launcher.dart';

// Utility functions
String numToCrypto(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

// TradingCoin class
class TradingCoin {
  final String name;
  final String tradingPair;
  final String price;
  final double change24h;
  final bool hasFireIcon;
  final bool hasLaunchpool;
  final String? launchpoolTimeRemaining;
  final String route;

  TradingCoin({
    required this.name,
    required this.tradingPair,
    required this.price,
    required this.change24h,
    this.hasFireIcon = false,
    this.hasLaunchpool = false,
    this.launchpoolTimeRemaining,
    required this.route,
  });
}

// CoinData class
class CoinData {
  final String pair;
  final String displayName;
  final double price;
  final double percentageChange;
  final String balance;

  CoinData({
    required this.pair,
    required this.displayName,
    required this.price,
    required this.percentageChange,
    required this.balance,
  });
}

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore>
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
    var unreadchat = ref.watch(chatProvider).unreadChat;
    final prices = ref.watch(priceProvider);
    final pricechange = ref.watch(priceChangesProvider);
    final user = ref.watch(authProvider).user;

    final coinList = [
      CoinData(
        pair: 'XBTUSD',
        displayName: 'BTC/USDT',
        price: prices['XBTUSD'] ?? 0.0,
        percentageChange: pricechange['XBTUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user!.BTC * (prices['XBTUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'ETHUSD',
        displayName: 'ETH/USDT',
        price: prices['ETHUSD'] ?? 0.0,
        percentageChange: pricechange['ETHUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.ETH * (prices['ETHUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'SOLUSD',
        displayName: 'SOL/USDT',
        price: prices['SOLUSD'] ?? 0.0,
        percentageChange: pricechange['SOLUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.SOL * (prices['SOLUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'XDGUSD',
        displayName: 'DOGE/USDT',
        price: prices['XDGUSD'] ?? 0.0,
        percentageChange: pricechange['XDGUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.DOGE * (prices['XDGUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'BNBUSD',
        displayName: 'BNB/USDT',
        price: prices['BNBUSD'] ?? 0.0,
        percentageChange: pricechange['BNBUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.BNB * (prices['BNBUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'HMSTRUSD',
        displayName: 'HMSTR/USDT',
        price: prices['HMSTRUSD'] ?? 0.0,
        percentageChange: pricechange['HMSTRUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.HMSTR * (prices['HMSTRUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'PEPEUSD',
        displayName: 'PEPE/USDT',
        price: prices['PEPEUSD'] ?? 0.0,
        percentageChange: pricechange['PEPEUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.PEPE * (prices['PEPEUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'MNTUSD',
        displayName: 'MNT/USDT',
        price: prices['MNTUSD'] ?? 0.0,
        percentageChange: pricechange['MNTUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.MNT * (prices['MNTUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'TRXUSD',
        displayName: 'TRX/USDT',
        price: prices['TRXUSD'] ?? 0.0,
        percentageChange: pricechange['TRXUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.TRX * (prices['TRXUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'USDTUSD',
        displayName: 'USDT/USDT',
        price: prices['USDTUSD'] ?? 0.0,
        percentageChange: pricechange['USDTUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.USDT * (prices['USDTUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'USDCUSD',
        displayName: 'USDC/USDT',
        price: prices['USDCUSD'] ?? 0.0,
        percentageChange: pricechange['USDCUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.USDC * (prices['USDCUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'XRPUSD',
        displayName: 'XRP/USDT',
        price: prices['XRPUSD'] ?? 0.0,
        percentageChange: pricechange['XRPUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.XRP * (prices['XRPUSD'] ?? 1))}',
      ),
      CoinData(
        pair: 'XUSD',
        displayName: 'X/USDT',
        price: prices['XUSD'] ?? 0.0,
        percentageChange: pricechange['XUSD'] ?? 0.00,
        balance: '\$ ${numToCrypto(user.X * (prices['XUSD'] ?? 1))}',
      ),
    ];

    final tradingCoins = [
      TradingCoin(
        name: 'BTC',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XBTUSD'] ?? 0.0, '2'),
        change24h: pricechange['XBTUSD'] ?? 0.00,
        hasFireIcon: true,
        route: Btcasset.routeName,
      ),
      TradingCoin(
        name: 'ETH',
        tradingPair: '/USDT',
        price: numToCurrency(prices['ETHUSD'] ?? 0.0, '2'),
        change24h: pricechange['ETHUSD'] ?? 0.00,
        hasFireIcon: true,
        route: ETHasset.routeName,
      ),
      TradingCoin(
        name: 'SOL',
        tradingPair: '/USDT',
        price: numToCurrency(prices['SOLUSD'] ?? 0.0, '2'),
        change24h: pricechange['SOLUSD'] ?? 0.00,
        hasFireIcon: true,
        route: SOLasset.routeName,
      ),
      TradingCoin(
        name: 'DOGE',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XDGUSD'] ?? 0.0, '2'),
        change24h: pricechange['XDGUSD'] ?? 0.00,
        route: DOGEasset.routeName,
      ),
      TradingCoin(
        name: 'BNB',
        tradingPair: '/USDT',
        price: numToCurrency(prices['BNBUSD'] ?? 0.0, '2'),
        change24h: pricechange['BNBUSD'] ?? 0.00,
        hasFireIcon: true,
        hasLaunchpool: true,
        route: Bnbasset.routeName,
      ),
      TradingCoin(
        name: 'HMSTR',
        tradingPair: '/USDT',
        price: numToCurrency(prices['HMSTRUSD'] ?? 0.0, '2'),
        change24h: pricechange['HMSTRUSD'] ?? 0.00,
        hasFireIcon: false,
        route: HMSTRasset.routeName,
      ),
      TradingCoin(
        name: 'PEPE',
        tradingPair: '/USDT',
        price: numToCurrency(prices['PEPEUSD'] ?? 0.0, '2'),
        change24h: pricechange['PEPEUSD'] ?? 0.00,
        hasFireIcon: true,
        route: PEPEasset.routeName,
      ),
      TradingCoin(
        name: 'MNT',
        tradingPair: '/USDT',
        price: numToCurrency(prices['MNTUSD'] ?? 0.0, '2'),
        change24h: pricechange['MNTUSD'] ?? 0.00,
        hasFireIcon: true,
        route: MNTasset.routeName,
      ),
      TradingCoin(
        name: 'TRX',
        tradingPair: '/USDT',
        price: numToCurrency(prices['TRXUSD'] ?? 0.0, '2'),
        change24h: pricechange['TRXUSD'] ?? 0.00,
        hasFireIcon: true,
        route: TRXasset.routeName,
      ),
      TradingCoin(
        name: 'USDT',
        tradingPair: '/USD',
        price: numToCurrency(prices['USDTUSD'] ?? 0.0, '2'),
        change24h: pricechange['USDTUSD'] ?? 0.00,
        hasFireIcon: true,
        route: USDTasset.routeName,
      ),
      TradingCoin(
        name: 'USDC',
        tradingPair: '/USDT',
        price: numToCurrency(prices['USDCUSD'] ?? 0.0, '2'),
        change24h: pricechange['USDCUSD'] ?? 0.00,
        hasFireIcon: false,
        route: USDCasset.routeName,
      ),
      TradingCoin(
        name: 'XRP',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XRPUSD'] ?? 0.0, '2'),
        change24h: pricechange['XRPUSD'] ?? 0.00,
        hasFireIcon: true,
        route: XRPasset.routeName,
      ),
      TradingCoin(
        name: 'X',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XUSD'] ?? 0.0, '2'),
        change24h: pricechange['XUSD'] ?? 0.00,
        hasFireIcon: false,
        route: Xasset.routeName,
      ),
    ];

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
                  IconButton(
                    onPressed: () => showWalletBottomSheet(context, ref),
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 30,
                    ),
                    tooltip: 'Open wallet',
                  ),
                  Text(
                    "Beam",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, size: 30),
                        onPressed: () =>
                            goto(context, Settingss.routeName, null),
                        tooltip: 'Settings',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications, size: 30),
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
                                child: Text(
                                  unreadchat.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ).onTap(() =>
                            goto(context, NotificationList.routeName, null)),
                      ),
                    ],
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  child:
                      TransferService.calculateUserDollarValue(user, prices) ==
                              0
                          ? ColumnWithSpacing(
                              spacing: 8,
                              children: [
                                Text(
                                  "Deposit and start trading.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomButton(
                                  name: "Purchase Crypto",
                                  onTap: () =>
                                      goto(context, Deposit.routeName, null),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            )
                          : ColumnWithSpacing(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  "Experience Seamless Trading",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  numToCurrency(
                                      TransferService.calculateUserDollarValue(
                                          user, prices),
                                      '2'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                    icon: CupertinoIcons.creditcard,
                    label: 'Deposit',
                    onTap: () => goto(context, Deposit.routeName, null),
                  ),
                  ActionButton(
                    icon: CupertinoIcons.arrow_2_circlepath,
                    label: 'Convert',
                    onTap: () => goto(context, Swapcoin.routeName, 'XBTUSD'),
                  ),
                  ActionButton(
                    icon: Icons.stacked_bar_chart_outlined,
                    label: 'Trade',
                    onTap: () => goto(context, Stake.routeName, 'XBTUSD'),
                  ),
                  ActionButton(
                    icon: CupertinoIcons.rocket_fill,
                    label: 'Transfer',
                    onTap: () => goto(context, Transfer.routeName, null),
                  ),
                  ActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    onTap: () => goto(context, AdditonalRes.routeName, null),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Click(Card(
                    child: Container(
                      width: 150,
                      height: 100,
                      child: const Center(child: Text("1V1 Instant Trading")),
                    ),
                  )).onTap(
                    () {
                      final btcPrice = prices['XBTUSD'] ?? 0.0;
                      if (btcPrice == 0.0) {
                        x.showMessage(context, 'BTC price not available');
                        return;
                      }
                      showStakeBottomSheet(context, 'XBTUSD', btcPrice,);
                    },
                  ),
                  const SizedBox(width: 10),
                  Click(Card(
                    child: Container(
                      width: 150,
                      height: 100,
                      child: const Center(child: Text("Puzzle Hunt")),
                    ),
                  )).onTap(() async {
                    // Placeholder; replace with actual URL
                    if (!await launchUrl(
                      x.url2,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception('Could not launch ${x.url2}');
                    }
                  }),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text("Favorites"),
                  SizedBox(width: 10),
                  Text("Hot"),
                  SizedBox(width: 10),
                  Text("New"),
                ],
              ),
              SizedBox(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    FittedBox(child: Tab(text: 'Spot')),
                    FittedBox(child: Tab(text: 'Derivatives')),
                  ],
                ),
              ),
              SizedBox(
                height: 1000,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coinList.length,
                      itemBuilder: (context, index) {
                        final coin = coinList[index];
                        return ListTile(
                          style: ListTileStyle.drawer,
                          leading: Text(
                            coin.displayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(numToCurrency(coin.price, '2')),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              "${coin.percentageChange.toStringAsFixed(3)} % ",
                              style: TextStyle(
                                color: coin.percentageChange.isNegative
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                          trailing: Text(
                            coin.balance,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onTap: () =>
                              goto(context, tradingCoins[index].route, null),
                        );
                      },
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tradingCoins.length,
                      itemBuilder: (context, index) {
                        return _buildTradingCoinTile(tradingCoins[index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradingCoinTile(TradingCoin coin) {
    return ListTile(
      onTap: () => goto(context, coin.route, null),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            coin.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (coin.hasFireIcon)
            const Icon(Icons.local_fire_department, color: Colors.orange),
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(coin.tradingPair),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(coin.price),
            if (coin.hasLaunchpool)
              Container(
                padding: const EdgeInsets.all(4),
                color: Colors.grey[800],
                child: const Text(
                  "Launchpool",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            if (coin.launchpoolTimeRemaining != null)
              Text(
                coin.launchpoolTimeRemaining!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
      trailing: Column(
        children: [
          Text(
            "24H change",
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: coin.change24h.isNegative ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${coin.change24h.toStringAsFixed(3)} %",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onTap,
          tooltip: label,
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
