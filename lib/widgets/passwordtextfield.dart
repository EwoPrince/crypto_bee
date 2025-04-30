import 'package:flutter/material.dart';

TextField passwordTextField(
  String text,
  TextEditingController controller,
  Widget widget,
  bool _passVisibility,
) {
  return TextField(
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.visiblePassword,
    controller: controller,
    autofocus: false,
    obscureText: _passVisibility,
    decoration: InputDecoration(
      suffixIcon: IconButton(
        icon: _passVisibility
            ? Icon(Icons.visibility_off)
            : Icon(Icons.visibility),
        onPressed: () {
          _passVisibility = !_passVisibility;
        },
      ),
      labelText: text,
      labelStyle: TextStyle(),
      contentPadding: EdgeInsets.all(10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
