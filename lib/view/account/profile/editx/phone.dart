import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';

class Phone extends ConsumerStatefulWidget {
  const Phone({super.key});
  static const routeName = '/EditPhoneNumber';

  @override
  ConsumerState<Phone> createState() => _PhoneState();
}

class _PhoneState extends ConsumerState<Phone> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phonenumbercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Number"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'This makes it easier for you to recover your account, for you and your HutBoxer to find each other on cryptobeam, and more.',
                textAlign: TextAlign.center,
              ),
              Text(
                'To keep your account safe, only use a phone number that you own.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                labelText: 'Phone number',
                hintText: 'Enter your phone number',
                controller: phonenumbercontroller,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.phone),
                maxLines: 1,
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
              Spacer(),
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
    try {
      setState(() {
        _isLoading = true;
      });
      var uid = ref.read(authProvider).user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'phone': phonenumbercontroller.text});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Phone Number Updated'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating phone number: ${error.toString()}'),
          duration: const Duration(seconds: 3),
        ));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
