import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/services/transfer_service.dart';
import 'package:crypto_beam/states/verified_state.dart';
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
import 'package:crypto_beam/x.dart' as x;
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Utility functions (unchanged)
String numToCrypto(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

// CoinData class (unchanged)
class CoinData {
  final String pair;
  final String displayName;
  final double price;
  final double percentageChange;
  final String balance;
  final String route;
  final String symbol;

  CoinData({
    required this.pair,
    required this.displayName,
    required this.price,
    required this.percentageChange,
    required this.balance,
    required this.route,
    required this.symbol,
  });
}

class Wallet extends ConsumerStatefulWidget {
  const Wallet({super.key});
  static const routeName = '/Wallet';

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

  String _getImagePath(String symbol) {
    switch (symbol) {
      case 'BTC':
        return 'assets/images/btc.png';
      case 'BNB':
        return 'assets/images/bnb.png';
      case 'ETH':
        return 'assets/images/eth.png';
      case 'DOGE':
        return 'assets/images/doge.png';
      case 'SOL':
        return 'assets/images/sol.png';
      default:
        return 'assets/images/default.png';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final pricechange = ref.watch(priceChangesProvider);
    final totalAssets = TransferService.calculateUserDollarValue(user!, prices);

    final coinList = [
      CoinData(
        pair: 'XBTUSD',
        displayName: 'BTC/USDT',
        price: prices['XBTUSD'] ?? 0.0,
        percentageChange: pricechange['XBTUSD'] ?? 0.00,
        balance: '${numToCrypto(user.BTC)} ',
        route: Btcasset.routeName,
        symbol: 'BTC',
      ),
      CoinData(
        pair: 'ETHUSD',
        displayName: 'ETH/USDT',
        price: prices['ETHUSD'] ?? 0.0,
        percentageChange: pricechange['ETHUSD'] ?? 0.00,
        balance: '${numToCrypto(user.ETH)} ',
        route: ETHasset.routeName,
        symbol: 'ETH',
      ),
      CoinData(
        pair: 'SOLUSD',
        displayName: 'SOL/USDT',
        price: prices['SOLUSD'] ?? 0.0,
        percentageChange: pricechange['SOLUSD'] ?? 0.00,
        balance: '${numToCrypto(user.SOL)} ',
        route: SOLasset.routeName,
        symbol: 'SOL',
      ),
      CoinData(
        pair: 'XDGUSD',
        displayName: 'DOGE/USDT',
        price: prices['XDGUSD'] ?? 0.0,
        percentageChange: pricechange['XDGUSD'] ?? 0.00,
        balance: '${numToCrypto(user.DOGE)} ',
        route: DOGEasset.routeName,
        symbol: 'DOGE',
      ),
      CoinData(
        pair: 'BNBUSD',
        displayName: 'BNB/USDT',
        price: prices['BNBUSD'] ?? 0.0,
        percentageChange: pricechange['BNBUSD'] ?? 0.00,
        balance: '${numToCrypto(user.BNB)} ',
        route: Bnbasset.routeName,
        symbol: 'BNB',
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30),
                  Text(
                    'My Assets',
                    style: Theme.of(context).textTheme.titleLarge,
                    semanticsLabel: 'My Assets',
                  ),
                  IconButton(
                    onPressed: () => showWalletBottomSheet(context, ref),
                    icon: const Icon(Icons.account_circle_rounded, size: 30),
                    tooltip: 'Open wallet settings',
                  ),
                ],
              ),
              SizedBox(height: 18),
              Text(
                'Total Assets',
                style: Theme.of(context).textTheme.titleLarge,
                semanticsLabel: 'Total Assets',
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    numToCurrency(totalAssets, '2'),
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    ' USD',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Text(
                '= ${numToCrypto(totalAssets / (prices['XBTUSD'] ?? 1))} BTC',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                semanticsLabel: 'Total assets in BTC',
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome, ${user.name}! Start managing your assets.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                      semanticsLabel: 'Welcome message for ${user.name}',
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
                    tooltip: 'Receive cryptocurrency',
                  ),
                  ActionButton(
                    icon: Icons.arrow_upward,
                    label: 'Send',
                    onTap: () => showSendModalBottomSheet(context),
                    tooltip: 'Send cryptocurrency',
                  ),
                  ActionButton(
                    icon: Icons.stacked_bar_chart_outlined,
                    label: 'Trade',
                    onTap: () => goto(context, Stake.routeName, 'XBTUSD'),
                    tooltip: 'Trade cryptocurrency',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    FittedBox(child: Tab(text: 'Account')),
                    FittedBox(child: Tab(text: 'Asset')),
                  ],
                ),
              ),
              SizedBox(
                height: 420,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Account Tab
                    Column(
                      children: [
                        ListTile(
                          style: ListTileStyle.drawer,
                          title: const Text('Funding Account'),
                          subtitle: Text(
                            numToCurrency(totalAssets, '2'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text: "16wvwzgAmRWgfW6sMjvUK9J8CUJeCaP2FV"));
                            x.showMessage(
                                context, 'Wallet Address copied successfully');
                            if (!await launchUrl(
                              x.url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch ${x.url}');
                            }
                          },
                          // semanticsLabel: 'Funding account balance ${numToCurrency(totalAssets, '2')}',
                        ),
                        Divider(),
                        ListTile(
                          style: ListTileStyle.drawer,
                          title: const Text('Settings'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () =>
                              x.goto(context, Settingss.routeName, null),
                          // semanticsLabel: 'Go to settings',
                        ),
                        Divider(),
                      ],
                    ),
                    // Asset Tab
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coinList.length,
                      itemBuilder: (context, index) {
                        final coin = coinList[index];
                        return AssetTileWidget(
                          image: _getImagePath(coin.symbol),
                          name: coin.displayName,
                          amount: coin.balance,
                          asset: coin.symbol,
                          currentPrice: coin.price,
                          percentageChange:
                              "${coin.percentageChange.toStringAsFixed(3)} % ",
                          top: index == 0,
                          bottom: index == coinList.length - 1,
                          onTap: () => x.goto(context, coin.route, null),
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
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String tooltip;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
