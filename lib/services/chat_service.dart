import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_beam/view/notification/chat_repository.dart';




class ChatService {
  // static Stream<QuerySnapshot<ChatContact>> getChatContacts(String uid) {
  //   final snapshot = FirebaseFirestore.instance
  //       .collection("chats")
  //       .where("membersUid", arrayContains: uid)
  //       .orderBy( "datePublished", descending: true)
  //       .withConverter(
  //         fromFirestore: (data, _) =>
  //             ChatContact.fromMap(data.data() as Map<String, dynamic>),
  //         toFirestore: (data, _) => data.toMap(),
  //       )
  //       .snapshots();

  //   return snapshot;
  // }

  static Stream<List<ChatContact>> getChatContacts(String uid) {
    return FirebaseFirestore.instance
        .collection("Notification")
        .orderBy("datePublished", descending: true)
        .snapshots()
        .map((event) {

      List<ChatContact> chats = [];

      for (var document in event.docs) {
        var chat = ChatContact.fromMap(document.data());
        if (chat.membersUid.contains(uid)) {
          chats.add(chat);
        }
      }
      
      return chats;
        });

  }


}
