import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_beam/model/message.dart';
import 'package:crypto_beam/model/user.dart';
import 'package:crypto_beam/x.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });


  Stream<List<Message>> getChatStream(String chatId) {
    return firestore
        .collection('Notification')
        .doc(chatId)
        .collection('messages')
        .orderBy('datePublished')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }


  Future<ChatContact?> openChat(User user, User currentUser) async {
    var uidList = [];
    uidList.add(currentUser.uid);
    uidList.add(user.uid);

    var chatContact = await firestore
        .collection('chats')
        .where('membersUid', isEqualTo: uidList)
        .limit(1)
        .get();

    if (chatContact.size > 0) {

      return ChatContact.fromMap(chatContact.docs.first.data());
    } else {
      var uidList = [];

      uidList.add(user.uid);
      uidList.add(currentUser.uid);

      var chatContact2 = await firestore
          .collection('chats')
          .where('membersUid', isEqualTo: uidList)
          .limit(1)
          .get();

      if (chatContact2.size > 0) {
        return ChatContact.fromMap(chatContact2.docs.first.data());
      }
    }

    return null;
  }
  

  // void _saveDataToContactsSubcollection(
  //   User senderUserData,
  //   String text,
  //   DateTime datePublished,
  //   String chatId,
  //   bool isGroupChat,
  //   bool isSeen,
  // ) async {
    
  //     await firestore.collection('Notifications').doc(chatId).update({
  //       'lastMessage': text,
  //       'datePublished': DateTime.now().millisecondsSinceEpoch,
  //       'isSeen': isSeen,
  //       'lastMessageBy': senderUserData.uid,
  //     });
  //   }
  

  void _saveSeenDataToContactsSubcollection(
    String chatId,
    bool isGroupChat,
    bool isSeen,
  ) async {
    await firestore.collection('Notification').doc(chatId).update({
      'isSeen': isSeen,
    });
  }

  // void _saveMessageToMessageSubcollection({
  //   required String chatId,
  //   required String text,
  //   required DateTime datePublished,
  //   required String messageId,
  //   required MessageEnum messageType,
  //   required String senderUsername,
  //   required bool isGroupChat,
  // }) async {
  //   final message = Message(
  //     senderId: auth.currentUser!.uid,
  //     chatId: chatId,
  //     text: text,
  //     type: messageType,
  //     datePublished: datePublished,
  //     messageId: messageId,
  //     isSeen: false,
  //     repliedMessage: '',
  //     repliedTo: '',
  //     repliedMessageType: MessageEnum.text,
  //   );

  //   // users -> sender id -> reciever id -> messages -> message id -> store message
  //   await firestore
  //       .collection('Notifications')
  //       .doc(chatId)
  //       .collection('messages')
  //       .doc(messageId)
  //       .set(
  //         message.toMap(),
  //       );
  // }

  // void deleteTextMessage({
  //   required BuildContext context,
  //   required String chatId,
  //   required String messageId,
  //   required bool isGroupChat,
  // }) async {
  //   try {
  //     await firestore
  //         .collection('Notifications')
  //         .doc(chatId)
  //         .collection('messages')
  //         .doc(messageId)
  //         .delete();
  //   } catch (e) {
  //     showMessage(context, e.toString());
  //   }
  // }

  void clearChat({
    required BuildContext context,
    required String chatId,
  }) async {
    try {
      // await firestore.collection('Notifications').doc(chatId).delete();
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String chatId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('Notification')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      _saveSeenDataToContactsSubcollection(
        chatId,
        false,
        true,
      );
    } catch (e) {
      showMessage(context, e.toString());
    }
  }
}





class ChatContact {
  final String chatId;
  final List<String> membersUid;
  final DateTime datePublished;
  final String lastMessage;
  final Map<String, dynamic> profile;
  final bool isSeen;
  final String lastMessageBy;

  List<ChatProfile> get getProfiles => profile.entries.map((data) {
        return ChatProfile(
          username: data.value["username"],
          profilePic: data.value["profilePic"],
          uid: data.value["uid"],
        );
      }).toList();

  ChatContact({
    required this.chatId,
    required this.membersUid,
    required this.datePublished,
    required this.lastMessage,
    required this.profile,
    required this.isSeen,
    required this.lastMessageBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'profile': profile,
      'membersUid': membersUid,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      chatId: map['chatId'] ?? '',
      profile: map['profile'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      datePublished: DateTime.fromMillisecondsSinceEpoch(
          map['datePublished'] ?? map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
      isSeen: map['isSeen'] ?? true,
      lastMessageBy: map['lastMessageBy'] ?? ''
    );
  }
}

class ChatProfile {
  final String uid;
  final String username;
  final String profilePic;

  ChatProfile({
    required this.uid,
    required this.username,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory ChatProfile.fromMap(Map<String, dynamic> map) {
    return ChatProfile(
      uid: map["uid"] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}

