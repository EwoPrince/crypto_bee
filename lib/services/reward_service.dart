import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;

class RewardDervice {
  Future<void> rewardUserSilver(int amount) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentId)
        .update({'river': FieldValue.increment(amount)});
  }

  Future<void> rewardUserGold(int amount) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentId)
        .update({'sea': FieldValue.increment(amount)});
  }
}
