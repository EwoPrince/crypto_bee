import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/widgets/button.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/textField.dart';
import 'package:crypto_beam/x.dart';

class FullName extends ConsumerStatefulWidget {
  const FullName({super.key});
  static const routeName = '/EditFullName';

  @override
  ConsumerState<FullName> createState() => _FullNameState();
}

class _FullNameState extends ConsumerState<FullName> {
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
              CustomTextField(
                labelText: 'Full Name',
                hintText: '',
                controller: namecontroller,
              ),
              Spacer(),
              _isLoading
                  ? Loading()
                  : CustomButton(
                      name: 'Update',
                      onTap: () {
                        updateprofile();
                      },
                      color: Theme.of(context).primaryColor,
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
    setState(() {
      _isLoading = true;
    });
    var uid = ref.read(authProvider).user!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': namecontroller.text,
    }).then((userx) {
      showUpMessage(context, 'Full Name Updated', '');
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
