import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/account/general_setting.dart';
import 'package:crypto_beam/view/userguild/helpcenter.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavDrawer extends ConsumerStatefulWidget {
  @override
  ConsumerState<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends ConsumerState<NavDrawer> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final user = ref.watch(authProvider).user;
      return Drawer(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: ExtendedImage.network(
              //     "${user!.photoUrl}",
              //     width: 120,
              //     height: 120,
              //     fit: BoxFit.cover,
              //     cache: true,
              //     shape: BoxShape.circle,
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(30.0),
              //     ),
              //   ).onTap(() {
              //     goto(
              //       context,
              //       EditPicProfile.routeName,
              //       null,
              //     );
              //   }),
              // ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user!.name}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Divider(
                        height: 2,
                        thickness: 3.0,
                      ),
                    ],
                  ),
                ),
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        goto(
                          context,
                          Settingss.routeName,
                          null,
                        );
                      },
                      child: Text(
                        'Settings and Privacy',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        goto(
                          context,
                          helpcenter.routeName,
                          null,
                        );
                      },
                      child: Text(
                        'Help Center',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
