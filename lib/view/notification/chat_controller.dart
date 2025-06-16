import 'package:crypto_beam/model/message.dart';
import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/notification/chat_repository.dart';
import 'package:crypto_beam/view/notification/notification_screen.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final Ref ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }




  void openChat(BuildContext context, User user) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shrinkWrap: true,
                children: [
                  Center(child: Text('Loading Chat Data')),
                  SizedBox(height: 10),
                  Loading(),
                ]),
          );
        });

    final currentUser = ref.watch(authProvider).user;
    final chat = await chatRepository.openChat(user, currentUser!);

      goto(context, NotificationScreen.routeName, {
        "name": chat!.profile[user.uid]!.username,
        "uid": chat.chatId,
        "isGroupChat": false,
        "profilePic": chat.profile[user.uid]!.profilePic,
        "recieverUserId": chat.profile[user.uid]!.uid,
      });
  }

  void deleteTextMessage(
    BuildContext context,
    String chatId,
    String messageId,
    bool isGroupChat,
  ) {
    // chatRepository.deleteTextMessage(
    //   context: context,
    //   chatId: chatId,
    //   messageId: messageId,
    //   isGroupChat: isGroupChat,
    // );
  }

  void clearChat(
    BuildContext context,
    String chatId,
  ) {
    chatRepository.clearChat(
      context: context,
      chatId: chatId,
    );
  }

  
  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }

}
