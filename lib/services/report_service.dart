import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;

class ReportService {
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

  Future<void> BlockUser(String uid) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentId)
        .update({'blockedUsers': FieldValue.arrayUnion([uid]),});
  }
}
