import 'package:flutter/material.dart';

Padding button(BuildContext context, String name, VoidCallback onTap,) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      // width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
      ),
    ),
  );
}
