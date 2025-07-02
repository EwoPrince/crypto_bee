import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/Recieve/RecieveUSDC.dart';
import 'package:crypto_beam/view/asset/btcHistory.dart';
import 'package:crypto_beam/view/send/sendBTC.dart';
import 'package:crypto_beam/view/stake/stake.dart';
import 'package:crypto_beam/view/swap/swap.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Utility functions from Wallet and TradeTile
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

class USDCasset extends ConsumerStatefulWidget {
  const USDCasset({super.key});
  static const routeName = '/USDCasset';

  @override
  ConsumerState<USDCasset> createState() => _USDCassetState();
}

class _USDCassetState extends ConsumerState<USDCasset> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final USDCPrice = prices['USDCUSD'] ?? 0.0;

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

    if (USDCPrice == 0.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'USDC',
            style: TextStyle(fontWeight: FontWeight.bold),
            semanticsLabel: 'USDC',
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
          'USDC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/usdc.png',
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
              '${numToCrypto(user.USDC)} USDC',
              style: Theme.of(context).textTheme.headlineLarge,
              semanticsLabel: '${numToCrypto(user.USDC)} USDC',
            ),
            const SizedBox(height: 6),
            Text(
              '${numToCurrency(user.USDC * USDCPrice, '2')}',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel:
                  'USD value ${numToCurrency(user.USDC * USDCPrice, '2')}',
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  tooltip: 'Send USDC',
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'USDC');
                  },
                ),
                _buildActionButton(
                  icon: Icons.arrow_downward,
                  label: 'Receive',
                  tooltip: 'Receive USDC',
                  onTap: () {
                    goto(context, RecieveUSDC.routeName, null);
                  },
                ),
                _buildActionButton(
                  icon: Icons.stacked_bar_chart_outlined,
                  label: 'Stake',
                  tooltip: 'Stake USDC',
                  onTap: () {
                    if (user.USDC == 0.0) {
                      showMessage(
                        context,
                        'You don\'t have any USDC to stake. Please contact customer service.',
                      );
                    } else {
                      goto(context, Stake.routeName, 'USDCUSD');
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.swap_vert,
                  label: 'Swap',
                  tooltip: 'Swap USDC',
                  onTap: () {
                    if (user.USDC == 0.0) {
                      showMessage(
                          context, 'You don\'t have enough USDC to swap.');
                    } else {
                      goto(context, Swapcoin.routeName, 'USDCUSD');
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: BTCHistory('USDC')),
            Divider(),
            Text(
              'Current USDC Price',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel: 'Current USDC Price',
            ),
            SizedBox(height: 6),
            Text(
              numToCurrency(USDCPrice, '4'),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              semanticsLabel: 'USDC price ${numToCurrency(USDCPrice, '4')}',
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
