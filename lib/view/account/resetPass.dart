import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/email_textfield.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/x.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);
  static const routeName = '/ResetPassWord';

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Password Reset'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text('To Reset your Password, you would have to...'),
              SizedBox(
                height: 10,
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: emailTextField(
                  'confirm your Email',
                  _emailcontroller,
                ),
              ),
              Spacer(),
              _isLoading
                  ? Loading()
                  : Consumer(builder: (context, ref, child) {
                      return button(
                        context,
                        'Verify',
                        () async {
                          final formValidate =
                              _formKey.currentState?.validate();
                          if (!(formValidate!)) {
                            return;
                          }
                          _formKey.currentState?.save();
                          setState(() {
                            _isLoading = true;
                          });
                          await ref
                              .read(authProvider)
                              .resetPass(_emailcontroller.text)
                              .then((value) {
                            showUpMessage(
                              context,
                              'check in your email to input your new password',
                              'Password Link Sent',
                            );
                          }).onError((error, stackTrace) {
                            showMessage(
                              context,
                              'Error ${error.toString()}',
                            );
                          });
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
