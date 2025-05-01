import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double height;
  final Color color;

  const CustomButton({
    Key? key,
    required this.name,
    required this.onTap,
    this.padding = const EdgeInsets.all(10),
    this.height = 50,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(name, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w800, fontSize: 16,)),
        ),
      ),
    );
  }
}
