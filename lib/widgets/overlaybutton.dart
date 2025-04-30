import 'package:flutter/material.dart';

Widget overlayButton(
  String Name,
  VoidCallback? onTap,
) {
  return Container(
    // width: double.infinity,
    height: 50,
    child: Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          Name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}
