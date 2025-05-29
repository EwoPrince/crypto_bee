import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RecieveBTC extends StatefulWidget {
  const RecieveBTC({super.key});
  static const routeName = '/RecieveBTC';

  @override
  State<RecieveBTC> createState() => _RecieveBTCState();
}

class _RecieveBTCState extends State<RecieveBTC> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recieve Bitcoin'),
      ),
      body: Container(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
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
                    'assets/images/btc_address.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Send only Bitcoin to this address'),
              Text('Don\'t send NFTs to this address.'),
              Text(
                'Network: Bitcoin',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text('Wallet Address'),
                        Text('bc1q24tj0ytwyl3lnjd6hyqlh6n34m94hx5nqumrqk'),
                        SizedBox(height: 20),
                        Text('Tap to copy Address'),
                      ],
                    ),
                  )).onTap(() async {
                await Clipboard.setData(ClipboardData(
                    text: "bc1q24tj0ytwyl3lnjd6hyqlh6n34m94hx5nqumrqk"));
                showMessage(context, 'Wallet Address copied successfully');
              }),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    " Buy with credit card ",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ).onTap(() async {
                await Clipboard.setData(ClipboardData(
                    text: "bc1q24tj0ytwyl3lnjd6hyqlh6n34m94hx5nqumrqk"));
                showMessage(context, 'Wallet Address copied successfully');
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $url');
                }
              }),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
