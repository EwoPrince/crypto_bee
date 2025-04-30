// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
import 'package:crypto_bee/view/account/profile/editx/full_name.dart';
import 'package:crypto_bee/view/account/profile/editx/phone.dart';
import 'package:crypto_bee/view/dashboard/land.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';
import 'package:crypto_bee/x.dart';

class Editprofile extends ConsumerStatefulWidget {
  Editprofile({
    Key? key,
  }) : super(key: key);
  static const routeName = '/EditProfile';

  @override
  ConsumerState<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends ConsumerState<Editprofile> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController whatsupcontroller = TextEditingController();

  updateprofile() async {
    setState(() {
      _isLoading = true;
    });
    showUpMessage(context, 'Profile Updated', '');
    setState(() {
      _isLoading = false;
    });
    become(context, Land.routeName, null);
    // goto(context, EditPicProfile());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 52,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Give us some Information about yourself.',
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    reusableTextField(
                      '${user!.name}',
                      namecontroller,
                      Theme.of(context).primaryColor,
                      () {
                        goto(context, FullName.routeName, null);
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    phoneTextField(
                      '${user.phone}',
                      phonenumbercontroller,
                      Theme.of(context).primaryColor,
                      () {
                        goto(context, Phone.routeName, null);
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              _isLoading
                  ? Loading()
                  : button(context, 'Done', () {
                      updateprofile();
                    }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
