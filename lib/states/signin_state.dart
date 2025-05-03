import 'package:crypto_beam/states/verified_state.dart';
import 'package:crypto_beam/view/auth/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sign extends StatefulWidget {
  static const routeName = '/';
  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 550,
              child: Center(
                child: Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.fill,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Onboarding();
          }
          return VerifiedState();
        },
      ),
    );
  }
}
