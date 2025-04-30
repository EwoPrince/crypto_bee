import 'package:flutter/material.dart';
import 'package:crypto_bee/view/userguild/additonal_res.dart';
import 'package:crypto_bee/view/userguild/privacy_tips.dart';
import 'package:crypto_bee/view/account/security.dart';
import 'package:crypto_bee/view/account/yourAccount.dart';
import 'package:crypto_bee/widgets/settingsTile.dart';
import 'package:crypto_bee/x.dart';

class Settingss extends StatefulWidget {
  static const routeName = '/Settings';
  @override
  State<Settingss> createState() => _SettingssState();
}

class _SettingssState extends State<Settingss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: [
              SettingsTile(
                context,
                Icons.person_outline,
                'Your account',
                'See information about your account and Edit any if you want to.',
              ).onTap(() {
                goto(
                  context,
                  YourAccount.routeName,
                  null,
                );
              }),
              SettingsTile(
                context,
                Icons.lock_outline,
                'Account access',
                'Manage your account security, or change your password if you forgot your password.',
              ).onTap(() {
                goto(context, SecurityScreen.routeName, null);
              }),
              SettingsTile(
                context,
                Icons.privacy_tip_outlined,
                'Privacy and Safety',
                'Get tips on how to keep your account secured and what to share on cryptobee.',
              ).onTap(() {
                goto(
                  context,
                  PrivacyTips.routeName,
                  null,
                );
              }),
              SettingsTile(
                context,
                Icons.menu_outlined,
                'Additional resources',
                'Check out other places for helpful information to learn more about cryptobee products and services',
              ).onTap(() {
                goto(
                  context,
                  AdditonalRes.routeName,
                  null,
                );
              }),
            ],
          )),
    );
  }
}
