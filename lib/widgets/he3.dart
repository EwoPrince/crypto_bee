import 'package:crypto_beam/widgets/recieveBS.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget hes3(
  BuildContext context,
) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your history',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'will be shown here',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Make your first transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 30),
      ],
    ),
  );
}

Widget buy_recieve(
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            " Buy asset ",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ).onTap(() async {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      }),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            " Receive ",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ).onTap(() {
        showRecieveModalBottomSheet(context);
      }),
    ],
  );
}
