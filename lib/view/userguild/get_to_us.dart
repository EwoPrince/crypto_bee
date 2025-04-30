import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetToUs extends StatefulWidget {
  GetToUs({Key? key}) : super(key: key);
  static const routeName = '/GetToUs';

  @override
  State<GetToUs> createState() => _GetToUsState();
}

class _GetToUsState extends State<GetToUs> {
  TextEditingController messagecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Make Complaints and Enquiries about process, products, and services concerning cryptobee.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'or just write us a letter telling us about how you feel...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    Form(
                      key: _formKey,
                      child: expandableTextField(
                        'words words words words words words...',
                        Theme.of(context).primaryColor,
                        messagecontroller,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    button(
                      context,
                      'Send Message',
                      () async {
                        final formValidate = _formKey.currentState?.validate();

                        if (!(formValidate!)) {
                          return;
                        }
                        _formKey.currentState?.save();

                        showMessage(context, 'sending message...');
                        users.update({
                          'message': messagecontroller.text,
                        }).then((device) {
                          Navigator.pop(context);
                          showUpMessage(
                              context, 'Message sent successfully', 'Success');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
