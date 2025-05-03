import 'package:crypto_beam/view/userguild/get_to_us.dart';
import 'package:crypto_beam/view/userguild/helpcenter.dart';
import 'package:crypto_beam/view/userguild/tac.dart';
import 'package:crypto_beam/widgets/settingsTile.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';

class AdditonalRes extends StatefulWidget {
  const AdditonalRes({Key? key}) : super(key: key);
  static const routeName = '/AdditonalResources';

  @override
  State<AdditonalRes> createState() => _AdditonalResState();
}

class _AdditonalResState extends State<AdditonalRes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additonal Resources'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Check out other places for helpful information to learn more about CryptoBlaze products and services',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          SettingsTile(
            context,
            Icons.menu_book_outlined,
            'Terms and Conditions',
            'See the document governing the contractual relationship between cryptobee and its user.',
          ).onTap(() {
            goto(
              context,
              tac.routeName,
              null,
            );
          }),
          SettingsTile(
            context,
            Icons.help_center_outlined,
            'Help Center',
            'A centralized hub for users to access information around process, products, and services concerning cryptobee.',
          ).onTap(() {
            goto(
              context,
              helpcenter.routeName,
              null,
            );
          }),
          SettingsTile(
            context,
            Icons.contact_support_outlined,
            'Get to us',
            'Make Complaints and Enquiries about process, products, and services concerning cryptobee.',
          ).onTap(() {
            goto(
              context,
              GetToUs.routeName,
              null,
            );
          }),
        ],
      ),
    );
  }
}
