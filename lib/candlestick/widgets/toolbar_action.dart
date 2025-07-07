import 'package:flutter/material.dart';

class ToolBarAction extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double width;
  final double height;
  final Color? color;
  final String? semanticsLabel;

  const ToolBarAction({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width = 30,
    this.height = 30,
    this.color,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? 'Toolbar action',
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        width: width,
        height: height,
        child: RawMaterialButton(
          elevation: 0,
          fillColor: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
          splashColor: color?.withOpacity(0.3) ?? Colors.grey.withOpacity(0.3),
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Center(child: child),
        ),
      ),
    );
  }
}