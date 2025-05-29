import 'dart:async';
import 'dart:math';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/dashboard/land.dart';
import 'package:crypto_beam/view/userguild/networkIssuse.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_beam/states/repository.dart';

// Price provider for storing cryptocurrency prices
final priceProvider = StateNotifierProvider<PriceNotifier, Map<String, double>>(
    (ref) => PriceNotifier());

class PriceNotifier extends StateNotifier<Map<String, double>> {
  PriceNotifier() : super({});
}

final priceChangesProvider =
    StateNotifierProvider<PriceChangesNotifier, Map<String, double>>(
        (ref) => PriceChangesNotifier());

class PriceChangesNotifier extends StateNotifier<Map<String, double>> {
  PriceChangesNotifier() : super({});
}

class VerifiedState extends ConsumerStatefulWidget {
  const VerifiedState({Key? key}) : super(key: key);
  static const routeName = '/VerifyUser';

  @override
  ConsumerState<VerifiedState> createState() => _VerifiedStateState();
}

class _VerifiedStateState extends ConsumerState<VerifiedState>
    with TickerProviderStateMixin {
  final KrakenRepository repository = KrakenRepository();
  late Future<bool> futureHolder;
  late AnimationController _textAnimationController;
  String randomStart = '';
  String? errorMessage;
  Timer? _textCycleTimer;

  final startList = [
    "Getting CryptoBeam Ready",
    "Fetching Market Data",
    "Syncing User Profile",
    "Preparing Charts",
  ];

  Future<bool> start({int retryCount = 0, int maxRetries = 3}) async {
    if (retryCount >= maxRetries) {
      setState(() {
        errorMessage =
            'Max retries reached. Please check your network and try again.';
      });
      return false;
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await ref.read(authProvider).getCurrentUser(user.uid);

      final prices = await repository.getCryptoPrices([
        'bitcoin',
        'ethereum',
        'solana',
        'dogecoin',
        'binancecoin',
      ]);

      // Map CoinGecko coin IDs to Kraken-style pair names
      final priceMap = {
        'XBTUSD': prices['bitcoin'] ?? 0.0,
        'ETHUSD': prices['ethereum'] ?? 0.0,
        'SOLUSD': prices['solana'] ?? 0.0,
        'XDGUSD': prices['dogecoin'] ?? 0.0,
        'BNBUSD': prices['binancecoin'] ?? 0.0,
      };
      print('Prices: $priceMap');

      final pricechanges = await repository.getCryptoPriceChanges([
        'bitcoin',
        'ethereum',
        'solana',
        'dogecoin',
        'binancecoin',
      ]);

      final priceChangeMap = {
        'XBTUSD': pricechanges['bitcoin'] ?? 0.0,
        'ETHUSD': pricechanges['ethereum'] ?? 0.0,
        'SOLUSD': pricechanges['solana'] ?? 0.0,
        'XDGUSD': pricechanges['dogecoin'] ?? 0.0,
        'BNBUSD': pricechanges['binancecoin'] ?? 0.0,
      };
      print('Prices: $priceChangeMap');

      ref.read(priceProvider.notifier).state = priceMap;
      ref.read(priceChangesProvider.notifier).state = priceChangeMap;

      ref.read(authProvider).listenTocurrentUserNotifier(user.uid);
      return true;
    } catch (e, st) {
      setState(() {
        errorMessage = e.toString().contains('Rate limit')
            ? 'Rate limit exceeded. Retrying in 30 seconds...'
            : e.toString().contains('ClientException')
                ? 'Network error. Please check your internet connection.'
                : 'Failed to initialize: $e';
      });
      if (e.toString().contains('Rate limit') ||
          e.toString().contains('ClientException')) {
        await Future.delayed(const Duration(seconds: 30));
        return start(retryCount: retryCount + 1, maxRetries: maxRetries);
      }
      return false;
    }
  }

  void cycleText() {
    final randomIndex = Random().nextInt(startList.length);
    setState(() {
      randomStart = startList[randomIndex];
    });
    _textAnimationController.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    cycleText();
    _textCycleTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) => cycleText());
    futureHolder = start();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _textCycleTimer?.cancel();
    repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: futureHolder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Loading(),
                    const SizedBox(height: 100),
                    FadeTransition(
                      opacity: _textAnimationController
                          .drive(CurveTween(curve: Curves.easeInOut)),
                      child: Text(
                        randomStart,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.data == true) {
           become(context, Land.routeName, null);
        return  Land();
        }

        if (snapshot.data == false) {
          return const Networkiss();
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage ?? 'An unexpected error occurred.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                      futureHolder = start();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
