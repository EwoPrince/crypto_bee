import 'package:crypto_bee/view/auth/onboarding.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'To Delete your account, Confirm your email and password.',
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              Text(
                'WARNING, This action cannot be undone.',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'Email',
                      hintText: "Email",
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email field is required";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                  controller: _passwordcontroller,
                  obscureText: !_passVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_passVisibility
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                       if (mounted) {
                    setState(() {
                     _passVisibility = !_passVisibility;
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
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              _isLoading
                  ? const Loading()
                  : Consumer(builder: (context, ref, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          name: 'Delete Account!',
                          onTap: () async {
                            final formValidate =
                                _formKey.currentState?.validate();
                            if (!(formValidate!)) {
                              return;
                            }
                            _formKey.currentState?.save();
                            setState(() {
                              _isLoading = true;
                            });
                            final success = await ref
                                .read(authProvider)
                                .DeleteAccount(
                                  _emailcontroller.text,
                                  _passwordcontroller.text,
                                );
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Wrong credentials")));
                            }
                            if(context.mounted){
                               Navigator.pushNamed(context, Onboarding.routeName);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
