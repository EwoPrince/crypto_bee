import 'package:flutter/material.dart';

Widget drawerTile(
  IconData icon,
  String title,
) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
        ),
        SizedBox(width: 16,),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        )
      ],
    ),
  );
}
