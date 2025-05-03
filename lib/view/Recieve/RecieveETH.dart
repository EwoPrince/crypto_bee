import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RecieveETH extends StatefulWidget {
  const RecieveETH({super.key});
  static const routeName = '/RecieveETH';

  @override
  State<RecieveETH> createState() => _RecieveBTCState();
}

class _RecieveBTCState extends State<RecieveETH> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recieve Ethereum'),
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
                    'assets/images/eth_address.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Send only Ethereum to this address'),
              Text('Don\'t send NFTs to this address.'),
              Text(
                'Network: Ethereum (ERC20)',
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
                        Text('0xd7e990f0480966DB6c038a5951A0F6D43D30de74'),
                        SizedBox(height: 20),
                        Text('Tap to copy Address'),
                      ],
                    ),
                  )).onTap(() async {
                await Clipboard.setData(ClipboardData(
                    text: "0xd7e990f0480966DB6c038a5951A0F6D43D30de74"));
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
                    text: "0xd7e990f0480966DB6c038a5951A0F6D43D30de74"));
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
