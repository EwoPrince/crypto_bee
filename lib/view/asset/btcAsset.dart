import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/Recieve/RecieveBTC.dart';
import 'package:crypto_beam/view/asset/btcHistory.dart';
import 'package:crypto_beam/view/send/sendBTC.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/view/swap/swap.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String numToCrypto(double value) {
  return value
      .toStringAsFixed(6)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String numToCurrency(double value, String decimals) {
  return '\$${value.toStringAsFixed(int.parse(decimals))}';
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class Btcasset extends ConsumerStatefulWidget {
  const Btcasset({super.key});
  static const routeName = '/btcasset';

  @override
  ConsumerState<Btcasset> createState() => _BtcassetState();
}

class _BtcassetState extends ConsumerState<Btcasset> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final btcPrice = prices['XBTUSD'] ?? 0.0;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'User not authenticated',
            style: TextStyle(fontSize: 18),
            semanticsLabel: 'User not authenticated',
          ),
        ),
      );
    }

    if (btcPrice == 0.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bitcoin',
            style: TextStyle(fontWeight: FontWeight.bold),
            semanticsLabel: 'Bitcoin',
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Price data unavailable',
            style: TextStyle(fontSize: 18),
            semanticsLabel: 'Price data unavailable',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BitCoin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/btc.png',
              height: 70,
              width: 70,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                size: 70,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${numToCrypto(user.BTC)} BTC',
              style: Theme.of(context).textTheme.headlineLarge,
              semanticsLabel: '${numToCrypto(user.BTC)} BTC',
            ),
            const SizedBox(height: 6),
            Text(
              '${numToCurrency(user.BTC * btcPrice, '2')}',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel:
                  'USD value ${numToCurrency(user.BTC * btcPrice, '2')}',
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                    icon: Icons.arrow_upward,
                    label: 'Send',
                    tooltip: 'Send BTC',
                    onTap: () {
                      goto(context, Sendbtc.routeName, 'BTC');
                    }),
                _buildActionButton(
                    icon: Icons.arrow_downward,
                    label: 'Receive',
                    tooltip: 'Receive BTC',
                    onTap: () {
                      goto(context, RecieveBTC.routeName, null);
                    }),
                _buildActionButton(
                    icon: Icons.stacked_bar_chart_outlined,
                    label: 'Stake',
                    tooltip: 'Stake BTC',
                    onTap: () {
                      user.BTC == 0.0
                          ? showUpMessage(
                              context,
                              'You dont have any BTC, so you can\'t perform this transaction right now. Please contact customer service',
                              'Bitcoin currently Unavailable',
                            )
                          : goto(context, Stake.routeName, 'XBTUSD');
                    }),
                _buildActionButton(
                    icon: Icons.swap_vert,
                    label: 'Swap',
                    tooltip: 'Swap BTC',
                    onTap: () {
                      user.BTC == 0
                          ? showMessage(context,
                              'You currently don\'t have enough BTC to swap')
                          : goto(context, Swapcoin.routeName, 'XBTUSD');
                    }),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: BTCHistory('BTC')),
            Divider(),
            Text(
              'Current BTC price',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel: 'Current BTC Price',
            ),
            SizedBox(height: 6),
            Text(
              '${numToCurrency(btcPrice, '4')}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              semanticsLabel: 'BNB price ${numToCurrency(btcPrice, '4')}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                semanticLabel: label,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                semanticsLabel: label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
