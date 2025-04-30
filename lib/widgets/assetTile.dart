import 'package:flutter/material.dart';

Widget AssetTile(
  BuildContext context,
  String? image,
  String name,
  String amount,
  String asset,
  String currentPrice,
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
    width: size.width * 0.9,
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (image!.isNotEmpty)
          Image.asset(
            image,
            height: 35,
            width: 35,
          ),
        // SizedBox(width: 10),
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                currentPrice,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                asset,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                amount,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
      ],
    ),
  );
}
