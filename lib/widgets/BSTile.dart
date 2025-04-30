import 'package:flutter/material.dart';

Widget BSTile(
  BuildContext context,
  String? image,
  String name,
  String describtion,
  bool top,
  bool buttom,
) {
  final size = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
      borderRadius: top
          ? BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )
          : buttom
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
              : null,
      color: Theme.of(context).colorScheme.secondaryContainer,
    ),
    width: size.width - 13,
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (image!.isNotEmpty)
          Image.asset(
            image,
            height: 40,
            width: 40,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              width: size.width * 0.65,
              child: Text(
                describtion,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 28,
        ),
      ],
    ),
  );
}
