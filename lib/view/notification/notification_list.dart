import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/provider/chat_provider.dart';
import 'package:crypto_beam/view/notification/chat_repository.dart';
import 'package:crypto_beam/view/notification/notification_screen.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});
  
  static const routeName = '/NotificationList';

  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
  late Future futureHolder;

  Future<bool> fetchdata() async {
    final user = ref.read(authProvider).user;
    try {
      await ref.read(chatProvider).fetchChatContacts(user!.uid);
      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> newLoad() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return true;
  }

  Future<void> onRefresh() async {
    setState(() {
      futureHolder = fetchdata();
    });
  }

  @override
  initState() {
      futureHolder = fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification'),),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder(
            future: futureHolder,
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Text('error');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Consumer(builder: (context, ref, child) {
                final data = ref.watch(chatProvider).contacts;
                final newdata =
                    data.where((element) => element.chatId.isNotEmpty && element.membersUid.length > 1).toList();
                    
                return newdata.isEmpty
                    ? Center(
                        child: Text(
                          'You have no Notification',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: newdata.length,
                        itemBuilder: (context, index) {
                          var chatContactData = newdata[index];

                          final otherUser = chatContactData.getProfiles
                              .where((element) =>
                                  element.uid !=
                                  ref.read(authProvider).user!.uid)
                              .firstOrNull;

                          return singleChatTile(
                            context,
                            chatContactData,
                            otherUser,
                            ref,
                          );
                        },
                      );
              });
            }),
      ),
    );
  }
}






Widget singleChatTile(
  BuildContext context,
  ChatContact chatContactData,
  ChatProfile? otherUser,
  WidgetRef ref,
) {
  final user = ref.read(authProvider).user;
  final isMe = chatContactData.lastMessageBy == user!.uid;
   return Column(
    children: [
      if(otherUser != null)
      ListTile(
        onLongPress: () {
          // ChatOptionshowModalBottomSheet(context, chatContactData, ref);
        },
        onTap: () {
          goto(context, NotificationScreen.routeName, {
            "name": otherUser.username,
            "uid": chatContactData.chatId,
            "isGroupChat": false,
            "profilePic": chatContactData.lastMessage,
            "recieverUserId": chatContactData.chatId,
          });
        },
          title: Text(
            otherUser.username,
         ),
        subtitle: Text(
          chatContactData.lastMessage,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 12,
             color: Colors.grey,
           ),
        ),
         trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Text(
                readTimestamp(chatContactData.datePublished),
                style: TextStyle(
                   color: !isMe && !chatContactData.isSeen
                    ? Colors.green
                     : Colors.grey,
                  fontSize: 13,
                 ),
               ),
            if (chatContactData.isSeen && isMe)
             const Icon(
                Icons.done_all,
                size: 20,
                 color: Colors.blue,
             ),
              if (!chatContactData.isSeen && isMe)
              const Icon(
                 Icons.done,
               size: 20,
              color: Colors.grey,
           ),
             if (!isMe && !chatContactData.isSeen)
               Container(
                  decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                    color: Colors.green,
                 ),
                  height: 12,
                  width: 12,
                ),
              ],
            ),
      ),
      const Divider(
        color: Colors.grey,
          thickness: 0.3,
          height: 0.3,
          indent: 85,
      ),
   ],
  );
}