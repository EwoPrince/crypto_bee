import 'package:flutter/material.dart';

Widget SettingsTile(
  BuildContext context,
  IconData icon,
  String name,
  String describtion,
) {
  final size = MediaQuery.of(context).size;
  return Container(
    width: size.width - 10,
    padding: EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          icon,
          size: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(
              height: 4,
              thickness: 4,
            ),
            SizedBox(
    width: size.width - 90,

              child: Text(
                describtion,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
