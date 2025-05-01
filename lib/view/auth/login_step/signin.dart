import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/states/verified_state.dart';
import 'package:crypto_bee/view/auth/login_step/signup.dart';
import 'package:crypto_bee/view/auth/forgot.dart';
import 'package:crypto_bee/view/userguild/tac.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart'; // Make sure this is imported.
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Make sure this is imported.
class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  static const routeName = '/signin';

  @override
  ConsumerState<Signin> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passVisibility = true;
  bool _isLoading = false;

  signin() async {
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
        .loginUser(
          _emailcontroller.text,
          _passwordcontroller.text,
        )
        .then((value) {
      become(context, VerifiedState.routeName, null);

      setState(() {
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      showMessage(context, 'Error ${error.toString()}');
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 30),
                const SizedBox(height: 10),
                Center(

                  child: Text(
                  "Log in to your Account'",
                  style: TextStyle(color: Colors.grey),)
                ),const SizedBox(height: 30),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                           focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                         ),
                        validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _emailcontroller.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                       cursorColor: Theme.of(context).primaryColor,
                       
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                  
                   

                      TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordcontroller,
                        autofocus: false,
                        obscureText: _passVisibility,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: _passVisibility
                                ? const Icon(Icons.visibility_off)
                                : Icon(
                                    Icons.visibility,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _passVisibility = !_passVisibility;
                                });
                              }
                            },
                          ),
                          labelText: "password",
                           labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Enter your password',
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                           focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                        ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                      const SizedBox(height: 30),
                      _isLoading ? const Loading() : button(context, 'LOGIN', signin),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            goto(context, Signup.routeName, null);
                          },
                          child: const Text('Don\'t have an account? Sign up'),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      goto(
                        context,
                        Forgort.routeName,
                        null,
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button(BuildContext context, String text, Function() fct) {
    return ElevatedButton(
      onPressed: fct,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
                        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}