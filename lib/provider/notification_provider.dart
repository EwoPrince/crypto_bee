// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:crypto_bee/model/chat_contact.dart';
// import 'package:crypto_bee/services/game_services.dart';

// final notificationProvider =
//     ChangeNotifierProvider<NotificationProviders>((ref) => NotificationProviders());

// class NotificationProviders extends ChangeNotifier {
//   List<ChatContact> _chatnote = [];

//   List<ChatContact> get chatnote => _chatnote;

//   Future<void> fetchChatNotification(String uid) async {
//     try {
//       final Stream<List<ChatContact>> dataStream =
//           GameService.getgames(uid);
//       dataStream.listen((data) {
//         _chatnote = data;
//         notifyListeners();
//       });
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }
// }
