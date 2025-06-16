import 'package:crypto_beam/services/chat_service.dart';
import 'package:crypto_beam/view/notification/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final chatProvider =
    ChangeNotifierProvider<ChatProviders>((ref) => ChatProviders());

class ChatProviders extends ChangeNotifier {
  List<ChatContact> _contacts = [];
  int _unreadChat = 1;

  List<ChatContact> get contacts => _contacts;
  int get unreadChat => _unreadChat;

  Future<void> fetchChatContacts(String uid) async {
    try {
      final Stream<List<ChatContact>> dataStream =
          ChatService.getChatContacts(uid);
      dataStream.listen((data) {
        
        List<ChatContact> chatx = data.where((element) {
          bool notSeen =
              element.isSeen == false && element.lastMessageBy != uid;

          return notSeen;
        }).toList();

        _unreadChat = chatx.length;
        _contacts = data;
        
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}
