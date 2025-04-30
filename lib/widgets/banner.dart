import 'package:flutter/material.dart';

Widget BannerLook(
  BuildContext context,
  String? image,
  String name,
  String subheadline,
  String maintext,
  String footer,
) {
  final size = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Theme.of(context).colorScheme.secondaryContainer,
    ),
    width: size.width * 0.9,
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (image!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
              height: size.width * 0.3,
              width: size.width * 0.88,
            ),
          ),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          subheadline,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          maintext,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Divider(),
        Text(
          footer,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    ),
  );
}
