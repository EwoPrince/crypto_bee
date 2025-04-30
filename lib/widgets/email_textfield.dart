import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

TextFormField emailTextField(
  String text,
  TextEditingController controller,
) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    validator: (value) =>
        EmailValidator.validate(value!) ? null : "Please enter a valid email",
    controller: controller,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
    ),
    decoration: InputDecoration(
      // labelText: text,
      hintText: text,
      contentPadding: EdgeInsets.all(10),
      // enabledBorder: OutlineInputBorder(
      //   borderSide: BorderSide(color: color!),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      // focusedBorder: OutlineInputBorder(
      //   borderSide: BorderSide(color: color),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      // disabledBorder: OutlineInputBorder(
      //   borderSide: BorderSide(color: Colors.red),
      //   borderRadius: BorderRadius.circular(10),
      // ),
    ),
  );
}
