import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/Recieve/RecieveXRP.dart';
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

class XRPasset extends ConsumerStatefulWidget {
  const XRPasset({super.key});
  static const routeName = '/XRPasset';

  @override
  ConsumerState<XRPasset> createState() => _XRPassetState();
}

class _XRPassetState extends ConsumerState<XRPasset> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prices = ref.watch(priceProvider);
    final XRPPrice = prices['XRPUSD'] ?? 0.0;

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

    if (XRPPrice == 0.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ripple',
            style: TextStyle(fontWeight: FontWeight.bold),
            semanticsLabel: 'Ripple',
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
          'Ripple',
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
              'assets/images/xrp.png',
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
              '${numToCrypto(user.XRP)} XRP',
              style: Theme.of(context).textTheme.headlineLarge,
              semanticsLabel: '${numToCrypto(user.XRP)} XRP',
            ),
            const SizedBox(height: 6),
            Text(
              '${numToCurrency(user.XRP * XRPPrice, '2')}',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel:
                  'USD value ${numToCurrency(user.XRP * XRPPrice, '2')}',
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  tooltip: 'Send XRP',
                  onTap: () {
                    goto(context, Sendbtc.routeName, 'XRP');
                  },
                ),
                _buildActionButton(
                  icon: Icons.arrow_downward,
                  label: 'Receive',
                  tooltip: 'Receive XRP',
                  onTap: () {
                    goto(context, RecieveXRP.routeName, null);
                  },
                ),
                _buildActionButton(
                  icon: Icons.stacked_bar_chart_outlined,
                  label: 'Stake',
                  tooltip: 'Stake XRP',
                  onTap: () {
                    if (user.XRP == 0.0) {
                      showMessage(
                        context,
                        'You don\'t have any XRP to stake. Please contact customer service.',
                      );
                    } else {
                      goto(context, Stake.routeName, 'XRPUSD');
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.swap_vert,
                  label: 'Swap',
                  tooltip: 'Swap XRP',
                  onTap: () {
                    if (user.XRP == 0.0) {
                      showMessage(
                          context, 'You don\'t have enough XRP to swap.');
                    } else {
                      goto(context, Swapcoin.routeName, 'XRPUSD');
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: BTCHistory('XRP')),
            Divider(),
            Text(
              'Current XRP Price',
              style: Theme.of(context).textTheme.titleMedium,
              semanticsLabel: 'Current XRP Price',
            ),
            SizedBox(height: 6),
            Text(
              numToCurrency(XRPPrice, '5'),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              semanticsLabel: 'XRP price ${numToCurrency(XRPPrice, '4')}',
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
