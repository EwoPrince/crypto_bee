import 'package:flutter/material.dart';
import 'package:crypto_bee/view/account/profile/edit_profile.dart';
import 'package:crypto_bee/view/account/account_information.dart';
import 'package:crypto_bee/view/account/deactivate.dart';
import 'package:crypto_bee/view/account/logout.dart';
import 'package:crypto_bee/widgets/settingsTile.dart';
import 'package:crypto_bee/x.dart';

class YourAccount extends StatefulWidget {
  const YourAccount({Key? key}) : super(key: key);
  static const routeName = '/MyAccount';

  @override
  State<YourAccount> createState() => _YourAccountState();
}

class _YourAccountState extends State<YourAccount> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'See information about your account and Edit any if you want to, or learn how to deactivate your account.',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SettingsTile(
              context,
              Icons.person_outline,
              'Account Information',
              'See information about your account.',
            ).onTap(() {
              goto(
                context,
                AccountInformation.routeName,
                null,
              );
            }),
            SettingsTile(
              context,
              Icons.person_add_outlined,
              'Edit Account Information',
              'Manage your account details, edit full name, phone number, or visible Email.',
            ).onTap(() {
              goto(
                context,
                Editprofile.routeName,
                null,
              );
            }),
            SettingsTile(
              context,
              Icons.person_remove_outlined,
              'Log out',
              'sign out of your account, you will be able to sign in when ever you insert your Email and password.',
            ).onTap(() {
              goto(context, LogOut.routeName, null);
            }),
            const Spacer(),
            InkWell(
              onTap: () {
                goto(context, Deactivate.routeName, null);
              },
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Deactivate Account",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Divider(
                            height: 2,
                            thickness: 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 130,
                            child: Text(
                              'Find out how you cound deactivate your account',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
