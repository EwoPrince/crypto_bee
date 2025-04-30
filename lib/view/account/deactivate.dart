import 'package:crypto_bee/view/auth/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/email_textfield.dart';
import 'package:crypto_bee/widgets/loading.dart';

import '../../x.dart';

class Deactivate extends StatefulWidget {
  const Deactivate({Key? key}) : super(key: key);

  static const routeName = '/Deactivate';

  @override
  State<Deactivate> createState() => _DeactivateState();
}

class _DeactivateState extends State<Deactivate> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passVisibility = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'To Delete your account, Confirm your email and password.',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          Text(
            'WARNING, This action cannot be undone.',
            softWrap: true,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: emailTextField(
                    "Email",
                    _emailcontroller,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordcontroller,
                    autofocus: false,
                    obscureText: _passVisibility,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "password field is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _passVisibility
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility, color: Colors.red),
                        onPressed: () {
                          _passVisibility = !_passVisibility;
                          setState(() {});
                        },
                      ),
                      labelText: "password",
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
          _isLoading
              ? Loading()
              : Consumer(builder: (context, ref, child) {
                  return button(context, 'Delete Account!', () async {
                    final formValidate = _formKey.currentState?.validate();
                    if (!(formValidate!)) {
                      return;
                    }
                    _formKey.currentState?.save();
                    setState(() {
                      _isLoading = true;
                    });
                    await ref.read(authProvider).DeleteAccount(
                          _emailcontroller.text,
                          _passwordcontroller.text,
                        );
                    become(context, Onboarding.routeName, null);
                    setState(() {
                      _isLoading = false;
                    });
                  });
                }),
        ],
      ),
    );
  }
}
