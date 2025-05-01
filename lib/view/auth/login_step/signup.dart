// ignore_for_file: must_be_immutable

import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/auth/login_step/Xfullname.dart';
import 'package:crypto_bee/view/auth/login_step/signin.dart';
import 'package:crypto_bee/view/userguild/tac.dart'; // Make sure this is imported.
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/x.dart';
import 'package:flutter/material.dart'; // Make sure this is imported.
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Signup extends ConsumerStatefulWidget {
  Signup({
    super.key,
  });
  static const routeName = '/signup';

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  xignup() async {
    final formValidate = _formKey2.currentState?.validate();
    if (!formValidate!) {
      return;
    }
    _formKey2.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    ref
        .read(authProvider)
        .setEmailPass(_emailController.text, _passwordController.text);
    Future.delayed(const Duration(milliseconds: 300), () {
      goto(
        context,
        XFullName.routeName,
        null,
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Create an Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                 Center(
                  child: Text(
                  "Get started and create your account.",
                  style: TextStyle(color: Colors.grey),)
                ),const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                   enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade800,
                      ),
                    ),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                      ),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                       if (mounted) {
                    setState(() {
                     _passwordVisible = !_passwordVisible;
                       });
                        }
                      },
                    ),
                  
                      enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
        ),
        focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(
                  color: Theme.of(context).primaryColor
        )),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                       if (mounted) {
                       setState(() {
                     _confirmPasswordVisible = !_confirmPasswordVisible;
                       });
                        }
                      },
                    ),
                      enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading ? const Loading() : button(context, 'Sign Up', xignup),
                const SizedBox(height: 10),
                 Center(
                  child: TextButton(onPressed: () {goto(context, Signin.routeName, null);}, child: const Text('Already have an account? Sign in'),),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("By signing up, I agree to the "),
                    GestureDetector(
                      onTap: () {
                        goto(context, tac.routeName, null);
                      },
                      child: Text(
                        "Terms and Conditions",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
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
  extension on Widget {
  onTap(Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}
