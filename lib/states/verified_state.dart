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

class VerifiedState extends ConsumerStatefulWidget {
  const VerifiedState({Key? key}) : super(key: key);
  static const routeName = '/VerifyUser';

  @override
  ConsumerState<VerifiedState> createState() => _VerifiedStateState();
}

class _VerifiedStateState extends ConsumerState<VerifiedState> {
  final KrakenRepository repository = KrakenRepository();
  var uid = FirebaseAuth.instance.currentUser!.uid;
  late Future futureHolder;
  late String randomStart = '';
  bool isEmailVerified = false;

  final startlist = [
    "Getting the Cryto Engine ready",
  ];

  Future<bool> start() async {
    try {
      await ref.read(authProvider).getCurrentUser(uid);

      btcPrice = await repository.getCryptoPrice('bitcoin');
      ethPrice = await repository.getCryptoPrice('ethereum');
      solPrice = await repository.getCryptoPrice('solana');
      dogePrice = await repository.getCryptoPrice('dogecoin');
      dogePrice = await repository.getCryptoPrice('binancecoin');

      print('Bitcoin Price: $btcPrice');
      print('Ethereum Price: $ethPrice');
      print('Solana Price: $solPrice');
      print('Dogecoin Price: $dogePrice');

      // await ref.read(symbolsProvider).fetchSymbols();
      ref.watch(authProvider).listenTocurrentUserNotifier(uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  randomText() {
    Random random = Random();
    int randomIndex = random.nextInt(startlist.length);
    final randomItem = startlist[randomIndex];
    setState(() {
      randomStart = randomItem;
    });
  }

  @override
  void initState() {
    randomText();
    futureHolder = start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHolder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading(),
                    SizedBox(height: 100),
                    Text(
                      randomStart,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return Land();
        }
        if (snapshot.data == false) {
          return Networkiss();
        }

        return Center(
          child: Text(
            'This Error is the first of it\'s kind.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}
