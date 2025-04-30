import 'dart:async';
import 'package:crypto_bee/route/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// const firebaseConfig = {
  // apiKey: "AIzaSyBDFSPir71sTUPyU0_mjWZRPo2jIzzGgu4",
  // authDomain: "swampthevotedamn.firebaseapp.com",
  // databaseURL: "https://swampthevotedamn-default-rtdb.firebaseio.com",
  // projectId: "swampthevotedamn",
  // storageBucket: "swampthevotedamn.firebasestorage.app",
  // messagingSenderId: "855278277443",
  // appId: "1:855278277443:web:025d973757895b2b1855f6",
  // measurementId: "G-ZPNR8X3H5Y"
// };

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
  apiKey: "AIzaSyBDFSPir71sTUPyU0_mjWZRPo2jIzzGgu4",
  appId: "1:855278277443:web:025d973757895b2b1855f6",
  messagingSenderId: "855278277443",
  projectId: "swampthevotedamn",
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: FlexColorScheme.dark(
        scheme: FlexScheme.amber,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ).toTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
