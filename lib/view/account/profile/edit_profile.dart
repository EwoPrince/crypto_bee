import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
// import 'package:crypto_bee/view/account/profile/editx/full_name.dart';
// import 'package:crypto_bee/view/account/profile/editx/phone.dart';
import 'package:crypto_bee/widgets/button.dart';
import 'package:crypto_bee/widgets/loading.dart';
import 'package:crypto_bee/widgets/textField.dart';

class Editprofile extends ConsumerStatefulWidget {
  const Editprofile({Key? key}) : super(key: key);
  static const routeName = '/EditProfile';

  @override
  ConsumerState<Editprofile> createState() => _EditprofileState();
}


class _EditprofileState extends ConsumerState<Editprofile> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController phonenumbercontroller = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    phonenumbercontroller.dispose();
    super.dispose();
  }

  updateprofile() async {
    setState(() {
      _isLoading = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Profile Updated'),
    ));
    setState(() {
      _isLoading = false;
    });

      Navigator.pushNamed(context, '/land');
  }

  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var user = ref.read(authProvider).user;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(           
          padding: const EdgeInsets.all(8.0),
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
              const SizedBox(
                height: 20.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'Full Name',
                      hintText: user!.name,
                      controller: namecontroller,
                      validator: (value) {
                        return null;
                      },
                      // onTap: () {
                      //   Navigator.pushNamed(context, FullName.routeName);
                      // },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomTextField(
                      labelText: 'Phone number',
                      hintText: user.phone,
                      controller: phonenumbercontroller,
                      validator: (value) {
                        return null;
                      },
                      // readOnly: true,
                      // onTap: () {
                      //   Navigator.pushNamed(context, Phone.routeName);
                      // },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              _isLoading
                  ? const Loading()
                  : Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child:SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                          name: 'Done',
                          onTap: updateprofile,
                          color: Theme.of(context).primaryColor),
                    )),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
