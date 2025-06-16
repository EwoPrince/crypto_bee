import 'package:crypto_beam/view/notification/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  final String name;
  final String recieverUserId;
  final String profilePic;

  const NotificationScreen({
    Key? key,
    required this.name,
    required this.profilePic,
    required this.recieverUserId,
  });

  static const routeName = '/ChatSpace';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
        centerTitle: false,
        
      ),
      body: Container(
        child: Column(
          children: [
            Text(
                profilePic,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            Expanded(
              child: ChatList(
                recieverUserId: recieverUserId,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
