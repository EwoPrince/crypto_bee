import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;

class LoacationService {
  
  Future<void> reportPost(
    String report,
    String reportUid,
  ) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Report')
        .doc(CurrentId)
        .set({
      'report': report,
      'reportPostid': reportUid,
    });
  }

  static Future<void> GetCurrentLocation(String uid) async {
   
  }
}
