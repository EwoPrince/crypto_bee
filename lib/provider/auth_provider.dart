import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_bee/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final authProvider =
    ChangeNotifierProvider<AuthProviders>((ref) => AuthProviders());

class AuthProviders extends ChangeNotifier {
  User? _user;
  bool _isLogin = false;
  Map<String, dynamic> _EPData = {};
  Map<String, dynamic> _FNData = {};
  Map<String, dynamic> _UNData = {};

  User? get user => _user;
  bool get isLogin => _isLogin;
  Map<String, dynamic> get EPData => _EPData;
  Map<String, dynamic> get FNData => _FNData;
  Map<String, dynamic> get UNData => _UNData;
  String? get firebaseCurrentUserId => x.FirebaseAuth.instance.currentUser?.uid;

  void setEmailPass(
    String email,
    String password,
  ) {
    _EPData = {
      "email": email,
      "password": password,
    };
    notifyListeners();
  }

  void setfirstName(String fn) {
    _FNData = {"fullname": fn};
    notifyListeners();
  }

  Future registerUser(
    String email,
    String password,
    String fullname,
    String phone,
  ) async {
    await x.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      await setUpAccount(email, fullname, phone, password);
    });
  }

  Future setUpAccount(
    String email,
    String fullname,
    String phone,
    String password,
  ) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(CurrentId).set(
      {
        "name": fullname,
        "password": password,
        "email": email,
        "phone": phone,
        "photoUrl":
            'https://firebasestorage.googleapis.com/v0/b/sellingfishing.appspot.com/o/startprofile%2Fmocking_1_generated.jpg?alt=media&token=e0eac257-2cee-4d01-a557-7d3350840ff3',
        "uid": CurrentId,
        "BTC": 0.00,
        "ETH": 0.00,
        "DOGE": 0.00,
        "SOL": 0.00,
        "dollar": 0.00,
        "referrers": [],
      },
    );

    listenTocurrentUserNotifier(CurrentId);
  }

  Future withdrawRequest(
      String address, String amount, String name, String page) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    var transcationId = const Uuid().v1();
    var datePublished = DateTime.now();
    final mount = double.tryParse(amount);

    await FirebaseFirestore.instance.collection("users").doc(CurrentId).update(
      {
        "dollar": FieldValue.increment(-mount!),
        page: FieldValue.increment(-mount),
      },
    );

    await FirebaseFirestore.instance
        .collection("withdrawal")
        .doc(CurrentId)
        .set(
      {
        "address": address,
        "amount": amount,
        "uid": CurrentId,
        "name": name,
        "page": page,
      },
    );

    await FirebaseFirestore.instance
        .collection('transcation')
        .doc(transcationId)
        .set({
      "transcationId": transcationId,
      "receiver_username":
          'Your transaction is being process, this may take up to 20 minutes.',
      "receiver_uid": CurrentId,
      "receiver_pic": user!.photoUrl,
      page: amount,
      "withdraw": true,
      "date": datePublished,
    });
  }

  Future swapRequest(
    String exchange_amount,
    String recovery_amount,
    String label,
    String page,
  ) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    var transcationId = const Uuid().v1();
    var datePublished = DateTime.now();
    final mount = double.tryParse(recovery_amount);
    final count = double.tryParse(exchange_amount);

    await FirebaseFirestore.instance.collection("users").doc(CurrentId).update(
      {
        // "dollar": FieldValue.increment(-mount!),
        label: FieldValue.increment(count!),
        page: FieldValue.increment(-count),
      },
    );

    await FirebaseFirestore.instance
        .collection('transcation')
        .doc(transcationId)
        .set({
      "transcationId": transcationId,
      "receiver_username": 'Your swap transaction was processed successfully.',
      "receiver_uid": CurrentId,
      "receiver_pic": user!.photoUrl,
      label: count,
      "withdraw": false,
      "date": datePublished,
      "swap": true,
    });
  }

  Future loginUser(String email, String password) async {
    await x.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final CurrentId = x.FirebaseAuth.instance.currentUser!.uid;
    final documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(CurrentId)
        .get();
    if (documentSnapshot.exists) {
      _user = User.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    listenTocurrentUserNotifier(CurrentId);
    notifyListeners();
    return user;
  }

  Future getCurrentUser(String uid) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (documentSnapshot.exists) {
      _user = User.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future listenTocurrentUserNotifier(String uid) async {
    final snapshot =
        FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
    snapshot.listen((document) {
      if (document.exists) {
        _user = User.fromMap(document.data() as Map<String, dynamic>);
      }
    });
    notifyListeners();
  }

  Future logoutUser() async {
    await x.FirebaseAuth.instance.signOut();
    final CurrentId = x.FirebaseAuth.instance.currentUser!.uid;
    getCurrentUser(CurrentId);
    notifyListeners();
  }

  Future resetPass(String pass) async {
    x.FirebaseAuth.instance.sendPasswordResetEmail(email: pass);
  }

  Future DeleteAccount(String email, String password) async {
    final currentId = x.FirebaseAuth.instance.currentUser!.uid;
    final credentials =
        x.EmailAuthProvider.credential(email: email, password: password);

    // Delete user document
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentId)
        .delete();

    // Reauthenticate and delete user account
    await x.FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credentials);
    await x.FirebaseAuth.instance.currentUser!.delete();

    // Clear current user data
    _user = null;
    notifyListeners();
  }
}
