import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/auth/login_step/Xphone.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/column_with_spacing.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/x.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ColumnWithSpacing(
            spacing: 20.0,
            children: [
              const Text(
                'Your Full Name would be used for accountabily reasons, so give us accurate details.',
                textAlign: TextAlign.center,
              ),
              CustomTextField(
                labelText: "Full Name",
                hintText: "Enter your full name",
                controller: namecontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const Spacer(),
              _isLoading
                  ? const Loading()
                  : SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        name: 'Next',
                        onTap: updateprofile,
                        color: Theme.of(context).primaryColor,
                      ),
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
    setState(() => _isLoading = true);

    ref.read(authProvider).setfirstName(namecontroller.text);
    goto(context, XPhone.routeName, null);

    setState(() => _isLoading = false);
  }
}
