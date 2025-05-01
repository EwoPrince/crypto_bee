import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double iconSize;
  final Color color;
  final Color iconColor;

  const DrawerTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
    this.padding = const EdgeInsets.all(8.0),
    this.spacing = 16.0,
    this.iconSize = 24.0,
    required this.color,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData, size: iconSize, color: iconColor,),
            SizedBox(width: spacing),
            Text(title, textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
      ),
    );
  }
}
