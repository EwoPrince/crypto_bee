import 'package:flutter/material.dart';

class BottomsheetTile extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final bool top;
  final bool bottom;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;

  const BottomsheetTile({
    Key? key,
    required this.image,
    required this.name,
    required this.description,
    this.top = false,
    this.bottom = false,
    required this.onTap,
    required this.color,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BorderRadius? borderRadius;
    if (top) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );
    } else if (bottom) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.labelLarge),
                SizedBox(
                  width: size.width * 0.65,
                  child: Text(description, overflow: TextOverflow.ellipsis, maxLines: 3, softWrap: true, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
            if (icon != null) Icon(icon, size: 28),
          ],
        ),
      ),
    );
  }
}
