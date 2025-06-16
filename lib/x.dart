import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Define price provider
// final priceProvider = StateProvider<Map<String, double>>((ref) => {
//       'BTC': 0.0,
//       'ETH': 0.0,
//       'DOGE': 0.0,
//       'SOL': 0.0,
//       'BNB': 0.0,
//     });

String numToCrypto(double number) {
  String pattern = '0.' + '0' * int.parse('4');
  NumberFormat format = NumberFormat(pattern);

  return format.format(number);
}

String numToCurrency(double number, String digit) {
  String pattern = '0.' + '0' * int.parse(digit);
  NumberFormat format = NumberFormat(pattern);

  return '\$' + format.format(number);
}

String readTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final diff = now.difference(timestamp);

  if (diff.inSeconds < 60) {
    return 'just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inDays < 365) {
    final weeks = (diff.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  } else {
    final years = (diff.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }
}

Duration normalspeed = Duration(milliseconds: 700);

// double btcPrice = 101682.90;
// double bnbPrice = 611.80;
// double ethPrice = 3132.63;
// double solPrice = 234.59;
// double dogePrice = 0.33;

// double btcPriceLP = 57648.53;
// double ethPriceLP = 2424.81;
// double solPriceLP = 157.74;
// double dogePriceLP = 0.30945;

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

final Uri url = Uri.parse('https://paybis.com');
final Uri url2 = Uri.parse('https://btcpuzzle.info/tools/visual-puzzle-hunter');



void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        content: Text(text),
        dismissDirection: DismissDirection.vertical,
      ),
    );
}

void showUpMessage(BuildContext context, String text, String title) {
  Flushbar(
    title: title,
    message: text,
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

void errorUpMessage(BuildContext context, String text, String title) {
  Flushbar(
    title: title,
    message: text,
    duration: Duration(seconds: 2),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

void goto(BuildContext context, String location, Object? extra) {
  context.push(location, extra: extra);

  // Navigator.of(context).push(
  //   PageRouteBuilder(
  //     transitionDuration: Duration(milliseconds: 250),
  //     pageBuilder: (_, __, ___) => screen,
  //     transitionsBuilder: (_, animation, __, child) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: child,
  //       );
  //     },
  //   ),
  // );
}

void become(BuildContext context, String location, Object? extra) {
  context.pushReplacement(location, extra: extra);

  // Navigator.of(context).pushAndRemoveUntil(
  //   PageRouteBuilder(
  //     transitionDuration: Duration(milliseconds: 250),
  //     pageBuilder: (_, __, ___) => screen,
  //     transitionsBuilder: (_, animation, __, child) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: child,
  //       );
  //     },
  //   ),
  //   ModalRoute.withName('/Home'),
  // );
}

const globalStyle = TextStyle(
  fontFamily: 'DMSans',
  fontSize: 12,
  fontWeight: FontWeight.w800,
);

extension Click on Widget {
  Widget onTap(VoidCallback? callback) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: callback,
      child: this,
    );
  }
}

extension DoubleClick on Widget {
  Widget onDoubleTap(VoidCallback? callback) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onDoubleTap: callback,
      child: this,
    );
  }
}
