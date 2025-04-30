import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/auth/verify.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class XPhone extends ConsumerStatefulWidget {
  const XPhone({super.key});
  static const routeName = '/PhoneNumber';

  @override
  ConsumerState<XPhone> createState() => _PhoneState();
}

class _PhoneState extends ConsumerState<XPhone> {
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
                'This makes it easier for you to recover your account.',
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
              _isLoading ? Loading() : button(context, 'Update', updateprofile),
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
    try {
      final EP = ref.read(authProvider).EPData;
      final FN = ref.read(authProvider).FNData;
      print('${EP['email']}, ${EP['password']}, ${FN['fullname']},}');
      await ref
          .read(authProvider)
          .registerUser(
            EP['email'],
            EP['password'],
            FN['fullname'],
            phonenumbercontroller.text,
          )
          .then((value) {
        become(context, verify.routeName, null);
        showUpMessage(
            context, 'Registration Mail sent successfully', 'Sign up Success');
      });
    } catch (e) {
      showUpMessage(context, "Error", e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
