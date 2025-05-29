import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/auth/verify.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/column_with_spacing.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ColumnWithSpacing(spacing: 20, children: [
            const Text(
              'This makes it easier for you to recover your account.',
              textAlign: TextAlign.center,
            ),
            const Text(
              'To keep your account safe, only use a phone number that you own.',
              textAlign: TextAlign.center,
            ),
            CustomTextField(
              labelText: "phone number",
              hintText: "Enter your phone number",
              controller: phonenumbercontroller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                if (value.length < 10) {
                  return 'Phone number must be at least 10 digits.';
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
                      name: 'Update',
                      onTap: updateprofile,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ]),
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
    try {
      setState(() => _isLoading = true);
      final EP = ref.read(authProvider).EPData;
      final FN = ref.read(authProvider).FNData;
      await ref.read(authProvider).registerUser(
            EP['email'],
            EP['password'],
            FN['fullname'],
            phonenumbercontroller.text,
          );
      if (context.mounted) {
        become(context, verify.routeName, null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Mail sent successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error${e.toString()}")));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
