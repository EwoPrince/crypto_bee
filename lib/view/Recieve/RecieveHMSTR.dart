import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RecieveHMSTR extends StatefulWidget {
  const RecieveHMSTR({super.key});
  static const routeName = '/RecieveHMSTR';

  @override
  State<RecieveHMSTR> createState() => _RecieveBTCState();
}

class _RecieveBTCState extends State<RecieveHMSTR> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  late Future<bool> futureHolder;

  Future<bool> start() async {
    if (uid == null) {
      debugPrint('No user signed in');
      return false;
    }
    try {
      var doc = await FirebaseFirestore.instance
          .collection('extras')
          .doc('BTC_id2')
          .get();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> lizzy = List<String>.from(data['ids'] ?? []);
      return lizzy.contains(uid);
    } catch (e, st) {
      debugPrint('Startup error: $e\n$st');
      return false;
    }
  }

  @override
  void initState() {
    futureHolder = start();
    super.initState();
  }

  Widget buildWalletUI({
    required String address,
    required String qrImage,
    required BuildContext context,
  }) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            height: 200,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                qrImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Send only HMSTR to this address'),
          const Text('Don\'t send NFTs to this address.'),
          Text(
            'Network: TON',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text('Wallet Address'),
                  Text(address),
                  const SizedBox(height: 20),
                  const Text('Tap to copy Address'),
                ],
              ),
            ),
          ).onTap(() async {
            await Clipboard.setData(ClipboardData(text: address));
            showMessage(context, 'Wallet Address copied successfully');
          }),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Buy with credit card",
                style: TextStyle(fontSize: 16), // Simplified style
              ),
            ),
          ).onTap(() async {
            try {
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                showMessage(context, 'Could not launch URL');
              }
            } catch (e) {
              showMessage(context, 'Error launching URL: $e');
            }
          }),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recieve HMSTR'),
      ),
      body: uid == null
          ? const Center(
              child: Text(
                'Please sign in to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : FutureBuilder<bool>(
              future: futureHolder,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
                if (snapshot.data == true) {
                  return buildWalletUI(
                    address: 'UQBDuCVw9_qwdYC2TVbl2ly-1RuRtkSmq6kNBSD7FavBJR98',
                    qrImage: 'assets/images/hmstr_address.jpeg',
                    context: context,
                  );
                }
                if (snapshot.data == false) {
                  return buildWalletUI(
                    address: 'UQBDuCVw9_qwdYC2TVbl2ly-1RuRtkSmq6kNBSD7FavBJR98',
                    qrImage: 'assets/images/hmstr_address.jpeg',
                    context: context,
                  );
                }
                return const Center(
                  child: Text(
                    'An unexpected error occurred.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
