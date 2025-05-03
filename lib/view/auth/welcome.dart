import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Welcome extends StatefulWidget {
  const Welcome();
  static const routeName = '/WelcomeTocryptobee';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0), // Adjust the padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome to the cryptoBeam',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'You\'re all set to take control of your crypto journey.',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'With Crypto Beam, you can:',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '🔐 Securely manage your wallet (non-custodial – only you control your keys)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '🔄 Instantly trade crypto with ease',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '📊 Track your portfolio and transactions in real time',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
         CustomButton(
                    color: Theme.of(context).primaryColor,
                    name: 
              'Done',
             onTap: () {
                become(context, VerifiedState.routeName, null);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
