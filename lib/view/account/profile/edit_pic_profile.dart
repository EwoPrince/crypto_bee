// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:crypto_bee/services/storage_methods.dart';
import 'package:crypto_bee/provider/auth_provider.dart';
// import 'package:crypto_bee/view/dashboard/land.dart';
// import 'package:crypto_bee/widgets/button.dart';
// import 'package:crypto_bee/widgets/loading.dart';
// import 'package:crypto_bee/x.dart';

class EditPicProfile extends ConsumerStatefulWidget {
  const EditPicProfile({Key? key}) : super(key: key);
  static const routeName = '/EditProfilePic';

  @override
  ConsumerState<EditPicProfile> createState() => _EditPicProfileState();
}

class _EditPicProfileState extends ConsumerState<EditPicProfile> {
  // final ImagePicker _picker = ImagePicker();
  // bool _isLoading = false;
  Uint8List? _image;
  Uint8List? image;
  // XFile? _xfile;

  // updatePicTheProfile() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     var uid = ref.read(authProvider).user!.uid;
  //     final photoUrl = await StorageMethods()
  //         .uploadProfileImageToStorage('profilePics', _image!, false);
  //     FirebaseFirestore.instance.collection('users').doc(uid).update({
  //       'photoUrl': photoUrl,
  //     });
  //     become(context, Land.routeName, null);
  //     showUpMessage(
  //       context,
  //       "Your new profile picture has been updated.",
  //       "New Profile pic",
  //     );
  //   } catch (e) {
  //     showMessage(
  //       context,
  //       e.toString(),
  //     );
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // selectImage() async {
  //   _xfile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   image = await _xfile!.readAsBytes();
  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Picture'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final user = ref.watch(authProvider).user;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: _image != null
                  ? CircleAvatar(
                      radius: 200,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : user != null
                      ? Image.network(
                          "${user.photoUrl}",
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
            ),
            // _image != null
            //     ? _isLoading
            //         ? Loading()
            //         : button(context, 'Upload Profile Pic', updatePicTheProfile)
            //     : button(context, 'Select Profile pic', selectImage),
          ],
        );
      }),
    );
  }
}
