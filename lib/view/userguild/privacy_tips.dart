import 'package:crypto_bee/view/userguild/helpcenter.dart';
import 'package:crypto_bee/widgets/settingsTile.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';

class PrivacyTips extends StatefulWidget {
  const PrivacyTips({Key? key}) : super(key: key);
  static const routeName = '/PrivacyTips';

  @override
  State<PrivacyTips> createState() => _PrivacyTipsState();
}

class _PrivacyTipsState extends State<PrivacyTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Safety'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get tips on how to keep your account secured and what to share on cryptobee.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: true,
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Use data to make cryptobee work',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'We need to store and process your data in other to provide you the basic cryptobee services, By using cryptobee, you allow us to provide this basic service. You can stop this by Deactivating or Deleting your account',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Use data to Customize and improve my cryptobee Experience',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'This allow us to use and process information about how you navigate and use cryptobee for analytical purpose, also allowing us to include you in new features and exprerimental test.',
                textAlign: TextAlign.center,
              ),
              Spacer(),
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
            ],
          )),
    );
  }
}
