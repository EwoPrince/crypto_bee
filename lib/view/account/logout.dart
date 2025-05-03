import 'package:crypto_beam/view/auth/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/x.dart';

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);
  static const routeName = '/LogOut';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log out'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Would you like to log out of your cryptobee account, you will be able to sign in when ever you insert your Email and password.',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Spacer(),
            Consumer(builder: (context, ref, child) {
              return CustomButton(
                color: Colors.white,
               name:
                'Log Out',
              onTap:   () async {
                  ref.read(authProvider).logoutUser();
                  become(context, Onboarding.routeName, null);
                },
              );
            }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
