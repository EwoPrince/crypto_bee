import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';

class Phone extends ConsumerStatefulWidget {
  const Phone({super.key});
  static const routeName = '/EditPhoneNumber';

  @override
  ConsumerState<Phone> createState() => _PhoneState();
}

class _PhoneState extends ConsumerState<Phone> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phonenumbercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Number"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text(
                'This makes it easier for you to recover your account, for you and your HutBoxer to find each other on cryptobee, and more.',
                textAlign: TextAlign.center,
              ),
              Text(
                'To keep your account safe, only use a phone number that you own.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              phoneTextField('phone number', phonenumbercontroller,
                  Theme.of(context).primaryColor, () {
                return null;
              }),
              Spacer(),
              _isLoading
                  ? Loading()
                  : button(context, 'Update', () {
                      updateprofile();
                    }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateprofile() async {
    final formValidate = _formKey.currentState?.validate();

    if (!(formValidate!)) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    var uid = ref.read(authProvider).user!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'phone': phonenumbercontroller.text,
    }).then((userx) {
      showUpMessage(context, 'Phone Number Updated', "");
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
