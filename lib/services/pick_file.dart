// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../x.dart';



// Future<File?> pickImageFromGallery(BuildContext context) async {
//   File? image;
//   try {
//     final XFile? pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery, requestFullMetadata: false);

//     if (pickedImage != null) {
//       image = File(pickedImage.path);
//     }
//   } catch (e) {
//     showMessage(context, e.toString());
//   }
//   return image;
// }

// Future<File?> pickImageFromCamara(BuildContext context) async {
//   File? image;
//   try {
//     final XFile? pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.camera, requestFullMetadata: false);

//     if (pickedImage != null) {
//       image = File(pickedImage.path);
//     }
//   } catch (e) {
//     showMessage(context, e.toString());
//   }
//   return image;
// }

// Future<File?> pickVideoFromGallery(BuildContext context) async {
//   File? video;
//   try {
//     final XFile? pickedVideo =
//         await ImagePicker().pickVideo(source: ImageSource.gallery, );

//     if (pickedVideo != null) {
//       video = File(pickedVideo.path);
//     }
//   } catch (e) {
//     showMessage(context, e.toString());
//   }
//   return video;
// }


