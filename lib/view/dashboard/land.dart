import 'package:crypto_bee/view/dashboard/drawer.dart';
import 'package:crypto_bee/view/dashboard/explore.dart';
import 'package:crypto_bee/view/dashboard/wallet.dart';
import 'package:crypto_bee/view/dashboard/history.dart';
import 'package:crypto_bee/view/stake/stake.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Land extends ConsumerStatefulWidget {
  Land({Key? key}) : super(key: key);
  static const routeName = '/Home';

  @override
  ConsumerState<Land> createState() => _LandState();
}

class _LandState extends ConsumerState<Land> with WidgetsBindingObserver {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  int _currentIndex = 0;

  bool willpop = false;

  final pages = [
    Profile(),
    Wallet(),
    Stake(),
    History(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: willpop,
      child: Scaffold(
        drawer: NavDrawer(),
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 1,
          enableFeedback: true,
          iconSize: 30.0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          unselectedIconTheme: IconThemeData(size: 24),
          selectedIconTheme: IconThemeData(size: 36),
          items: [
            BottomNavigationBarItem(
              tooltip: 'Home',
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              tooltip: 'Wallet',
              label: 'Wallet',
              icon: Icon(Icons.wallet),
            ),
            BottomNavigationBarItem(
              tooltip: 'Track',
              label: 'Track',
              icon: Icon(Icons.trending_up),
            ),
            BottomNavigationBarItem(
              tooltip: 'History',
              label: 'history',
              icon: Icon(Icons.history),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}
