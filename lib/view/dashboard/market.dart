import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/asset/bnbAsset.dart';
import 'package:crypto_beam/view/asset/btcAsset.dart';
import 'package:crypto_beam/view/asset/dogeAsset.dart';
import 'package:crypto_beam/view/asset/ethAsset.dart';
import 'package:crypto_beam/view/asset/hmstrAsset.dart';
import 'package:crypto_beam/view/asset/mntAsset.dart';
import 'package:crypto_beam/view/asset/pepeAsset.dart';
import 'package:crypto_beam/view/asset/solAsset.dart';
import 'package:crypto_beam/view/asset/trxAsset.dart';
import 'package:crypto_beam/view/asset/usdcAsset.dart';
import 'package:crypto_beam/view/asset/usdtAsset.dart';
import 'package:crypto_beam/view/asset/xAsset.dart';
import 'package:crypto_beam/view/asset/xrpAsset.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Utility functions from Explore
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

class Market extends ConsumerStatefulWidget {
  const Market({super.key});
  static const routeName = '/Market';

  @override
  ConsumerState<Market> createState() => _MarketState();
}

class _MarketState extends ConsumerState<Market>
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
        price: numToCurrency(prices['HMSTRUSD'] ?? 0.0, '4'),
        change24h: pricechange['HMSTRUSD'] ?? 0.00,
        hasFireIcon: false,
        route: HMSTRasset.routeName,
      ),
      TradingCoin(
        name: 'PEPE',
        tradingPair: '/USDT',
        price: numToCurrency(prices['PEPEUSD'] ?? 0.0, '4'),
        change24h: pricechange['PEPEUSD'] ?? 0.00,
        hasFireIcon: true,
        route: PEPEasset.routeName,
      ),
      TradingCoin(
        name: 'MNT',
        tradingPair: '/USDT',
        price: numToCurrency(prices['MNTUSD'] ?? 0.0, '4'),
        change24h: pricechange['MNTUSD'] ?? 0.00,
        hasFireIcon: false,
        hasLaunchpool: true,
        route: MNTasset.routeName,
      ),
      TradingCoin(
        name: 'TRX',
        tradingPair: '/USDT',
        price: numToCurrency(prices['TRXUSD'] ?? 0.0, '3'),
        change24h: pricechange['TRXUSD'] ?? 0.00,
        hasFireIcon: false,
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
        hasLaunchpool: true,
        route: USDCasset.routeName,
      ),
      TradingCoin(
        name: 'XRP',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XRPUSD'] ?? 0.0, '4'),
        change24h: pricechange['XRPUSD'] ?? 0.00,
        hasFireIcon: true,
        route: XRPasset.routeName,
      ),
      TradingCoin(
        name: 'X',
        tradingPair: '/USDT',
        price: numToCurrency(prices['XUSD'] ?? 0.0, '5'),
        change24h: pricechange['XUSD'] ?? 0.00,
        hasFireIcon: true,
        hasLaunchpool: true,
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
              SizedBox(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    FittedBox(child: Tab(text: 'Derivatives')),
                    FittedBox(child: Tab(text: 'Spot')),
                  ],
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Streak feature activated')),
                      );
                    },
                    child: const Text('Streak'),
                  ),
                  DropdownButton<String>(
                    value: 'USDT',
                    items: const [
                      DropdownMenuItem(value: 'USDT', child: Text('USDT')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                    ],
                    onChanged: (value) {
                      // Placeholder for currency filter
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected $value')),
                      );
                    },
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'New listing: BNB/USDT – Grab a share of the 5,500,000…',
                    semanticsLabel: 'New listing announcement',
                  ),
                ),
              ),
              SizedBox(
                height: 1000,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tradingCoins.length,
                      itemBuilder: (context, index) {
                        return _buildTradingCoinTile(tradingCoins[index]);
                      },
                    ),
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
                            child: Text(numToCurrency(coin.price, '4')),
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
                          // semanticsLabel: '${coin.displayName} price ${numToCurrency(coin.price, '2')}',
                        );
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
                  'Launchpool',
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
      // semanticsLabel: '${coin.name} price ${coin.price}, 24-hour change ${coin.change24h}',
    );
  }
}
