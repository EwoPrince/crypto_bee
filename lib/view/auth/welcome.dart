import 'package:crypto_bee/states/verified_state.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/x.dart';
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
                'Welcome to the cryptobee',
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
                'At cryptobee, we specialize in maximizing your investments through strategic crypto asset management. Our mission is to provide unparalleled opportunities in the fast-evolving world of digital currencies. With a commitment to transparency, security, and innovation, we empower our clients to achieve their financial goals with confidence.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
         CustomButton(
                    color: Colors.white,
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
