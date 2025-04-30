import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/auth/login_step/Xphone.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class XFullName extends ConsumerStatefulWidget {
  const XFullName({super.key});
  static const routeName = '/FullName';

  @override
  ConsumerState<XFullName> createState() => _FullNameState();
}

class _FullNameState extends ConsumerState<XFullName> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Name"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text(
                'Your Full Name would be used for accountabily reasons, so give us accurate details.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              reusableTextField(
                  'Full Name', namecontroller, Theme.of(context).primaryColor,
                  () {
                return null;
              }),
              Spacer(),
              _isLoading
                  ? Loading()
                  : button(context, 'Next', () {
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
    ref.read(authProvider).setfirstName(namecontroller.text);
    goto(
      context,
      XPhone.routeName,
      null,
    );
    setState(() {
      _isLoading = false;
    });
  }
}
