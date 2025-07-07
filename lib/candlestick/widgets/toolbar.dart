import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  final EdgeInsets padding;
  final double? height;

  const ToolBar({
    Key? key,
    required this.children,
    required this.color,
    this.padding = const EdgeInsets.all(2.0),
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chart toolbar',
      child: SizedBox(
        height: height,
        child: Container(
          color: color,
          child: Padding(
            padding: padding,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: children
                    .asMap()
                    .entries
                    .map((entry) => Padding(
                          padding: EdgeInsets.only(
                              right: entry.key < children.length - 1 ? 4.0 : 0),
                          child: entry.value,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}