import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/Recieve/RecieveHMSTR.dart';
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

class HMSTRasset extends ConsumerStatefulWidget {
  const HMSTRasset({super.key});
  static const routeName = '/HMSTRasset';

  @override
  ConsumerState<HMSTRasset> createState() => _HMSTRassetState();
}

class _HMSTRassetState extends ConsumerState<HMSTRasset> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final HMSTRPrice = prices['HMSTRUSD'] ?? 0.0;

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

    if (HMSTRPrice == 0.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hamster-Kombat',
            style: TextStyle(fontWeight: FontWeight.bold),
            semanticsLabel: 'Hamster-Kombat',
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
          'Hamster-Kombat',
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
              'assets/images/hmstr.png',
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
              '${numToCrypto(user.HMSTR)} HMSTR',
              style: Theme.of(context).textTheme.headlineLarge,
              semanticsLabel: '${numToCrypto(user.HMSTR)} HMSTR',
            ),
            const SizedBox(height: 6),
            Text(
              '${numToCurrency(user.HMSTR * HMSTRPrice, '2')}',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel:
                  'USD value ${numToCurrency(user.HMSTR * HMSTRPrice, '2')}',
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  tooltip: 'Send HMSTR',
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'HMSTR');
                  },
                ),
                _buildActionButton(
                  icon: Icons.arrow_downward,
                  label: 'Receive',
                  tooltip: 'Receive HMSTR',
                  onTap: () {
                    goto(context, RecieveHMSTR.routeName, null);
                  },
                ),
                _buildActionButton(
                  icon: Icons.stacked_bar_chart_outlined,
                  label: 'Stake',
                  tooltip: 'Stake HMSTR',
                  onTap: () {
                    if (user.HMSTR == 0.0) {
                      showMessage(
                        context,
                        'You don\'t have any HMSTR to stake. Please contact customer service.',
                      );
                    } else {
                      goto(context, Stake.routeName, 'HMSTRUSD');
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.swap_vert,
                  label: 'Swap',
                  tooltip: 'Swap HMSTR',
                  onTap: () {
                    if (user.HMSTR == 0.0) {
                      showMessage(
                          context, 'You don\'t have enough HMSTR to swap.');
                    } else {
                      goto(context, Swapcoin.routeName, 'HMSTRUSD');
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: BTCHistory('HMSTR')),
            Divider(),
            Text(
              'Current HMSTR Price',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel: 'Current HMSTR Price',
            ),
            SizedBox(height: 6),
            Text(
              numToCurrency(HMSTRPrice, '4'),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              semanticsLabel: 'HMSTR price ${numToCurrency(HMSTRPrice, '4')}',
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
