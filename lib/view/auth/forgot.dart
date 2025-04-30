import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/email_textfield.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Forgort extends ConsumerStatefulWidget {
  const Forgort({Key? key}) : super(key: key);
  static const routeName = '/ForgotPassword';

  @override
  ConsumerState<Forgort> createState() => _ForgortState();
}

class _ForgortState extends ConsumerState<Forgort> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: emailTextField(
                  'Input your Email',
                  _emailcontroller,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _isLoading
                  ? Loading()
                  : button(
                      context,
                      'Reset',
                      () async {
                        final formValidate = _formKey.currentState?.validate();

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
                              'Check in your email to reset password',
                              'Reset Link sent');
                          _isLoading = false;
                        }).onError((error, stackTrace) {
                          showMessage(
                            context,
                            'Error ${error.toString()}',
                          );
                        });

                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
            ],
          ),
        ));
  }
}
